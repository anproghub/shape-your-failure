const mongoose = require('mongoose');

const notificationSchema = mongoose.Schema({
    type: {
        type: String,
        enum: ['Comment', 'Like', 'Report', 'Reply'],
        required: true,
    },
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    postId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post',
        required: true
    },
    message: {
        type: String
    },
    viewed: {
        type: Boolean,
        default: false
    },  
    expire_at: {
        type: Date
    } 
}, { timestamps: true }).index({"expire_at": 1 }, { expireAfterSeconds: 30 } );;

//populating the senderId and postID in notificationSchema
notificationSchema.pre('find', async function(next) {
    this.populate('senderId', ['username', 'image']);
    this.populate('postId', ['title']);
    next();
});

const Notification = mongoose.model('Notification', notificationSchema);

module.exports = Notification;