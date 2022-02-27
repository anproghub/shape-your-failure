const mongoose = require("mongoose");
const tagController = require('./../controllers/tagController');

const postSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true,
        minlength: [4, 'Minimum length of title must be 4.'],
        maxlength: [40, 'Maximum length of title must be 40.']
    },
    description: {
        type: String,
        required: true,
        trim: true,
        minlength: [4, 'Minimum length of description is 4.'],
        maxlength: [500, 'Maximum length of description is 500.'],
    },
    image: {
        type: String,
        trim: true
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    isUserPublic: {
        type: Boolean,
        default: true
    },
    commentCount: {
        type: Number,
        default: 0
    },
    tags: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Tag'
    }],
    likes: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Like'
    }],
    likeCount: {
        type: Number,
        default: 0
    },
    reportArray: {
        type: Array,
        'default': [0,0,0,0]
    },
}, { timestamps: true });

postSchema.methods.addTags = async(tags) => {
    var tagIds = [];
    for (var tagIndex in tags) {
        var tagId = await tagController.getTagId(tags[tagIndex]);
        tagIds.push(tagId);
    }
    return tagIds;
};
//populate username and userID
postSchema.pre('find', async function(next) {

    this.populate('tags', ['name']);
    this.populate('userId', ['username', 'image']);
    next();
});

module.exports = mongoose.model("Post", postSchema);