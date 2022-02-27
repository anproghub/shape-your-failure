const Comment = require('./../models/commentModel');
const Post = require("../models/postModel");
const DbFeatures = require('./../utilities/dbFeatures');
const AppError = require("../utilities/appError");
const catchAsync = require('./../utilities/catchAsync');

// Function to add a comment
exports.createAComment = catchAsync(async(req, res, next) => {
    
    const newComment = await Comment.create({
        userId: req.user._id,
        postId: req.params.id,
        description: req.body.description,
        isRepliable: req.body.parentId==null ? true : false,
        parentId: req.body.parentId,
    });

    await Post.updateOne({ _id: newComment.postId }, { $inc: { commentCount: 1 } });

    res.status(200).json({
        status: 'success',
        data: {
            comment: newComment
        }
    });
});

//Function to update a Comment
exports.updateAComment = catchAsync(async(req, res, next) => {

    const comment = await Comment.updateOne({ _id: req.params.commentid }, { $set: req.body });

    if (!comment) {
        return next(new AppError('Comment not found!', 404));
    }

    res.status(200).json({
        status: 'success',
        data: {
            comment: comment
        }
    });
});

// Function to delete a Comment
exports.deleteAComment = catchAsync(async(req, res, next) => {

    const comment = await Comment.findOne({ _id: req.params.commentid, userId: req.user._id });

    if (!comment) {
        return next(new AppError('Comment not found!', 404));
    }

    //Before deleting main comment, delete the replies
    const replies = await Comment.deleteMany({ parentId: comment._id });
    //Now, delete the main comment
    await Comment.findByIdAndDelete(comment._id);
    //Change the comment count of the post
    await Post.updateOne({ _id: comment.postId }, { $inc: { commentCount: -1 * replies.deletedCount - 1 } });

    res.status(200).json({
        status: 'success',
        message: 'Comment deleted successfully!'
    });
});

// Function to get all comments in a post
exports.getAllPostComments = catchAsync(async(req, res, next) => {

    const dbFeatures = new DbFeatures(Comment.find({ postId: req.params.id, parentId: null }), req.query)
        .filter()
        .sort()
        .filterFields()
        .paginate();

    const postComments = await dbFeatures.dbQuery;
    
    res.status(200).json({
        status: 'success',
        data: {
            comments: postComments
        }
    });
});

// Function to get all replies on a comment
exports.getAllReplies = catchAsync(async(req, res, next) => {

    const dbFeatures = new DbFeatures(Comment.find(), req.query)
        .filter()
        .sort()
        .filterFields()
        .paginate();

    const commentReplies = await dbFeatures.dbQuery.find({ parentId: req.params.commentid});

    res.status(200).json({
        status: 'success',
        data: {
            replies: commentReplies
        }
    });
});
