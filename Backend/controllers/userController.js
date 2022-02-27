const catchAsync = require('./../utilities/catchAsync');
const User = require('./../models/userModel');
const fileController = require('./../controllers/fileController');
const DbFeatures = require('./../utilities/dbFeatures');
const AppError = require('./../utilities/appError');

const fs = require('fs');
const path = require('path');

const storageDir = `${__dirname}\\..\\app-data\\user-images\\`;
const serverUrl = `${process.env.SERVER_URL}/users/image/`;

// Function to get current logged in user
exports.getUser = catchAsync(async(req, res, next) => {
    res.status(200).json({
        status: 'success',
        data: { user: req.user }
    });

});

// Function to get all user by querying using URL
exports.getAllUsers = catchAsync(async(req, res, next) => {
    const dbFeatures = new DbFeatures(User.find(), req.query)
        .filter()
        .sort()
        .filterFields()
        .paginate();

    let users = await dbFeatures.dbQuery;

    //Removing password field and then sending
    // for(var userIndex in users) {
    //     delete users[userIndex]['password'];
    // }

    res.status(200).json({
        status: 'success',
        data: { users: users }
    });
});

// Function to update User's image, firstname, lastname, bio
exports.updateUser = catchAsync(async(req, res, next) => {

    const user = req.user;

    //If user uploads an image, storing it on the server
    if (req.files && req.files.image) {
        try {
            await fileController.storeFile(req.files.image, storageDir + user._id + '.jpg');
            req.body.image = serverUrl + user._id + '.jpg';
        } catch (e) {
            return next(new AppError('Error while uploading the file!', 400));
        }
    }

    //If the request for the property is not null, only then change
    if (req.body.firstName != null) {
        user.firstName = req.body.firstName;
    }
    if (req.body.lastName != null) {
        user.lastName = req.body.lastName;
    }
    if (req.body.bio != null) {
        user.bio = req.body.bio;
    }
    if (req.body.image != null) {
        user.image = req.body.image;
    }

    await user.save();
    res.status(200).json({
        status: 'success',
        message: 'User details updated successfully!'
    });

});

// Function to get user's profile pic
exports.getUserImage = catchAsync(async(req, res, next) => {

    const file = path.resolve(storageDir + req.params.fileName);

    fs.stat(file, function(err, stat) {
        if (!err) {
            res.sendFile(file);
        } else {
            return next(new AppError('File not found!', 404));
        }
    });
});