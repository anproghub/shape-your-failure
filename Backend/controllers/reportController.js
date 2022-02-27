const Post = require('./../models/postModel');
const catchAsync = require('./../utilities/catchAsync');
const { default: axios } = require("axios");
const NotificationController = require('./../controllers/notificationController');
const stringSimilarity = require('string-similarity');
const AppError = require('./../utilities/appError');
//Report a post
exports.reportPost = catchAsync(async(req, res, next) => {
    const type = req.body.type;
    const post = await Post.findById(req.params.id);

    //Increment the type of report (Spam, nudity, abusive lang, flaunting success)
    post.reportArray[type*1]++;
    await post.save();
    await res.status(200).json({
        status: 'success',
        message:  'Successfully reported the post!'
    });

    //If number of a type of reports exceed x, put check
    if(type*1 == 0)  {
        checkImage(post);
    }
    else if(type*1 == 1) {
        checkText(post);
    }
    else if(type*1 == 2) {
        checkSpam(post);
    }
    // TODO: else if(type*1 == 3) // Manual flaunting success
    // {
    //     
    // }
});

async function checkImage(post) {

    //Sending the url of the image to be tested in the headers
    const headers = {
        'imageurl': post.image
    };
    
    //Sending the request to port 8800 for doing NSFW check
    await axios.get('http://localhost:8800/image/', { headers })
    .then(async (response) => {
        const predictions = response.data;

        //If percentage of Porn or Hentai is more than 50%, remove post after sending notification
        //TODO: logic of removal
        if((predictions[0].className == 'Porn' || predictions[0].className == 'Hentai' || predictions[0].className == 'Drawing' || predictions[0].className == 'Neutral' || predictions[0].className == 'Sexy') && predictions[0].probability >= 0.7)
        {
            console.log("Pathetic post image. Deleted");
            await NotificationController.createNotification({
                type: 'Report',
                receiverId: post.userId,
                postId: post._id,
                message: `Your post titled: ${post.title} was deleted because it violated our community guidelines.`
            });
            await Comment.deleteMany({ postId: post._id });
            await Post.findByIdAndDelete(post._id);
        }
    }).catch(error => {
        console.error('There was an error!', error);
    });
}

async function checkText(post) {

    //Sending the post description for check
    const headers = {
        'text': post.description
    };

    //Sending the request to port 8800 for doing abusive language check
    await axios.get('http://localhost:8800/text/', { headers })
    .then(async (response) => {
        const predictions = response.data;

        //If any of the labels is true, set flag=true 
        let flag = false;
        for(var predIndex in predictions) {
            if(predictions[predIndex].results[0].match == true) {
                flag = true;
                break;
            }
        }

        //If any of the labels is true, send notification and remove the post
        if(flag) {
            await NotificationController.createNotification({
                type: 'Report',
                receiverId: post.userId,
                postId: post._id,
                message: `Your post titled: ${post.title} was deleted because it violated our community guidelines.`
            });
            await Comment.deleteMany({ postId: post._id });
            await Post.findByIdAndDelete(post._id);
        }
    }).catch(error => {
        console.error('There was an error!', error);
    });
}

async function checkSpam(post) {

    //If post description's size is bigger than x, do the check
    if(post.description.length > 5) {

        //Find previous posts and get the count of posts with similar descriptions
        const posts = await Post.find({"userId" : post.userId});
        let count = 0;
        for(var postIndex in posts)
        {
            const oldPost = await posts[postIndex];
            const fractionOfSimilarity = await stringSimilarity.compareTwoStrings(oldPost.description,post.description);
            if(fractionOfSimilarity > 0.85) {
                count++;
            }
        }

        //If count exceeds x, remove the post after sending notification
        if(count>=2)
        {
            await NotificationController.createNotification({
                type: 'Report',
                receiverId: post.userId,
                postId: post._id,
                message: `Your post titled: ${post.title} was deleted because it seems to be spam.`
            });
            await Comment.deleteMany({ postId: post._id });
            await Post.findByIdAndDelete(post._id);
        }
    }
}
