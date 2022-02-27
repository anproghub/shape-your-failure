const Post = require('./../models/postModel');
const Comment = require('./../models/commentModel');
const catchAsync = require('./../utilities/catchAsync');
const { default: axios } = require("axios");
const NotificationController = require('./../controllers/notificationController');
const stringSimilarity = require('string-similarity');
const AppError = require('./../utilities/appError');
exports.reportAComment = catchAsync(async(req, res, next) => {
    
    const type = req.body.type;
    const comment = await Comment.findById(req.params.commentid);

    //Increment the type of report (Spam or abusive lang)
    comment.reportArray[type*1]++; // modulo
    await comment.save();
    await res.status(200).json({
        status: 'success',
        message:  'Successfully reported the comment :) !'
    });
    
    //If report type is abusive language, do this test
    if(type*1 == 0) { // TODO: logic when check will be called
        checkText(comment);
    }
    //If report type is spam, do this test
    else if(type*1 == 1) {
        checkSpam(comment);
    }
});

//utility for calcultaing the predictions on comment
async function checkText(comment) {

    //Set the 'text' property in header, this header will be sent with request
    const headers = {
        'text': comment.description
    };

    //Send the request for text analysis on port 8800
    await axios.get('http://localhost:8800/text/', { headers })
    .then(async (response) => {
        const predictions = response.data;
        //If any of the 7 categories turn out to be true, remove the post
        let flag = false;
        for(var predIndex in predictions) {
            if(predictions[predIndex].results[0].match == true) {
                flag = true;
                break;
            }
        }

        //If true, send notification to user whose post is getting deleted
        if(flag) {
            await NotificationController.createNotification({
                type: 'Report',
                receiverId: comment.userId,
                postId: comment.postId,
                message: `Your comment : ${comment.description} was deleted because it violated our community guidelines.`
            });
            //Before deleting main comment, delete the replies
            const replies = await Comment.deleteMany({ parentId: comment._id });
            //Now, delete the main comment
            await Comment.findByIdAndDelete(comment._id);
            //Change the comment count of the post
            await Post.updateOne({ _id: comment.postId }, { $inc: { commentCount: -1 * replies.deletedCount - 1 } });
        }
    }).catch(error => {
        console.error('There was an error!', error);
    });
}

async function checkSpam(comment) {

    // If description length is more than x, check for spam
    if(comment.description.length > 5) { //TODO: logic for check

        //Find previous comments of user
        const comments = await Comment.find({"userId" : comment.userId});

        //Check the count similar comments that have been posted before
        let count = 0;
        for(var postIndex in comments)
        {
            const oldComment = await comments[postIndex];
            const fractionOfSimilarity = await stringSimilarity.compareTwoStrings(oldComment.description,comment.description);
            if(fractionOfSimilarity > 0.85) {
                count++;
            }
        }
        
        //If count of similar comments exceeds this, send notification to user and delete the comment
        if(count>=2) // TODO: logic for deletion
        {
            await NotificationController.createNotification({
                type: 'Report',
                receiverId: comment.userId,
                postId: comment.postId,
                message: `Your comment : ${comment.description} was deleted because it seems to be spam.`
            });

            //Before deleting main comment, delete the replies
            const replies = await Comment.deleteMany({ parentId: comment._id });
            //Now, delete the main comment
            await Comment.findByIdAndDelete(comment._id);
            //Change the comment count of the post
            await Post.updateOne({ _id: comment.postId }, { $inc: { commentCount: -1 * replies.deletedCount - 1 } });
        }
    }
}
