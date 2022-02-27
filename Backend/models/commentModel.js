const mongoose = require("mongoose");
const Post = require("../models/postModel");
const notificationController = require('./../controllers/notificationController');

const CommentSchema = new mongoose.Schema({
    postId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post'
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    parentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Comment',
        default: null,
    },
    isRepliable: {
        type: Boolean
    },
    description: {
        type: String,
        maxlength: [100, 'Maximum length of a comment can be 100.'],
    },
    reportArray: {
        type: Array,
        'default': [0,0]
    },
}, { timestamps: true });

CommentSchema.pre('save', function(next) {
    this.wasNew = this.isNew;
    next();
});
//middleware to create notification when someone comments on a post
CommentSchema.post('save', async function() {
    if (this.wasNew) {

        await this.populate('postId', ['userId']);
        if(this.userId.toString() != this.postId.userId._id.toString())
        {
            await notificationController.createNotification({
                type: this.parentId ? 'Reply' : 'Comment',
                senderId: this.userId,
                receiverId: this.postId.userId,
                postId: this.postId
            });
        }
    }
});

// Populating username and image to show it in frontend while displaying a comment
CommentSchema.pre('find', async function(next) {
    this.populate('userId', ['username', 'image']);
    next();
});

module.exports = mongoose.model("Comment", CommentSchema);