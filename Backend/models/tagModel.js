const mongoose = require('mongoose');

//Schema for tags
const tagSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        maxlength: [20, 'Length of a tag cannot exceed 20.'],
    }
});

const Tag = mongoose.model('Tag', tagSchema);

module.exports = Tag;