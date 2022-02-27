const mongoose = require("mongoose");
const notificationController = require('./../controllers/notificationController');

const LikeSchema = new mongoose.Schema({
    type: {
        type: String,
        enum: ['Love', 'BetterLuckNextTime', 'Support', 'Relatable'],
        default: 'Love'
    },
    postId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post'
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
});

//middleware to create notification when someone likes a post
LikeSchema.post('save', async function() {

    await this.populate('postId', ['userId']);
    if(this.userId.toString() != this.postId.userId._id.toString())
    {
        await notificationController.createNotification({
            type: 'Like',
            senderId: this.userId,
            receiverId: this.postId.userId,
            postId: this.postId
        });
    }
});

//middleware to populate username and image while fetching reactions(to be displayed on frontend)
LikeSchema.pre('find', async function(next) {
    this.populate('userId', ['username', 'image']);
    next();
});

module.exports = mongoose.model("Like", LikeSchema);