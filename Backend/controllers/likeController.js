const Like = require('./../models/likeModel');
const Post = require('./../models/postModel');
const catchAsync = require('./../utilities/catchAsync');
const DbFeatures = require('./../utilities/dbFeatures');

//Like/Dislike post
exports.likePost = catchAsync(async(req, res, next) => {

    //checking if already like exists on the post
    let like = await Like.findOne({ userId: req.user._id, postId: req.params.id });
    const likeObj = {
        type: req.body.type,
        userId: req.user._id,
        postId: req.params.id,
    };
    let isLiked = true;
    //Already reaction of this user exists on this post
    if (like) {
        //if user sends the same reaction then dislike it 
        if (likeObj.type === 'None') {
            await Post.updateOne({ _id: req.params.id }, { $pull: { likes: like._id }, $inc: { likeCount: -1 } });
            await Like.findByIdAndDelete(like._id);
            isLiked = false;
        } else {
            like.type = likeObj.type;
            await like.save();
        }
    } else {
        // Like the post 
        like = await Like.create(likeObj);
        await Post.updateOne({ _id: req.params.id }, { $push: { likes: like._id }, $inc: { likeCount: 1 } });
    }
    res.status(200).json({
        status: 'success',
        message: isLiked ? 'Successfully liked the post!' : 'Successfully disliked the post!'
    });
});

// Function to get all reactions on a particular post
exports.getAllLikes = catchAsync(async(req, res, next) => {

    const dbFeatures = new DbFeatures(Like.find(), req.query)
        .filter()
        .sort()
        .filterFields()
        .paginate();
    const likes = await dbFeatures.dbQuery.find({postId : req.params.id});
    res.status(200).json({
        status: 'success',
        data: {
            likes : likes 
        }
    });
});