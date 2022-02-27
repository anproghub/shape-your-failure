const Tag = require('./../models/tagModel');

exports.getTagId = async(tagName) => {

    let tag = await Tag.findOne({ name: tagName });
    if (tag) {
        console.log('Exists: ', tag._id);
        return tag._id;
    } else {
        tag = await Tag.create({ name: tagName });
        console.log('Adding new tag: ', tag._id);
        return tag._id;
    }
}