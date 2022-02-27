// Required for generating random tokens for verification purpose
const crypto = require('crypto');

// Required for generating the bearer token to allow user to login
const jwt = require('jsonwebtoken');

// Used for making a function return a promise instead to response
const { promisify } = require('util');

const User = require('./../models/userModel');
const AppError = require('./../utilities/appError');
const catchAsync = require('./../utilities/catchAsync');
const sendMail = require('./../utilities/email');

// TODO: Filter data before sending to user

// This function generates a json web token for given user id
const signIn = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN
    });
};

// Function to register a new user
exports.signUp = catchAsync(async(req, res, next) => {

    // Generate an email verification token
    const emailVerificationToken = crypto.randomBytes(32).toString('hex');

    // Save the token and expire time in request body
    req.body.emailVerificationToken = emailVerificationToken;
    req.body.emailVerificationExpiresAt = Date.now() + 10 * 60 * 1000;

    // Create a new user using request body
    const newUser = await User.create(req.body);

    // Create a verification url
    const verificationUrl = `${req.protocol}://${req.get('host')}/users/verifyEmail/${emailVerificationToken}/${newUser._id}`;
    console.log(verificationUrl);
    // TODO: Replace text message with an HTML form
    // Create the message body to be sent via email
    const message = `Post on this url to verify your email.\n${verificationUrl}`;

    try {

        // Sending the email to the user
        await sendMail({
            email: newUser.email,
            subject: 'Shape your Failure email verification',
            message: message
        });

        // Send the response to the user
        res.status(200).json({
            status: 'success',
            message: 'You have been registered successfully. Please verify your email (within 10 minutes) to continue.'
        });

    } catch (err) {

        // In case of an error sending email, delete the newly created user
        await newUser.remove();
        return next(new AppError('Some problem occurred! Try again later.', 500));
    }

});

// Function to verify user email address
exports.verifyEmail = catchAsync(async(req, res, next) => {

    // Obtain the verification token from the url
    const verificationToken = req.params.verificationToken;
    const id = req.params.id;

    // Search for user with valid verification token and email in database
    const user = await User.findOne({
        _id: id,
        emailVerificationExpiresAt: { $gt: Date.now() },
        emailVerificationToken: verificationToken
    });

    // Report error if user not found
    if (!user) {
        return next(new AppError('Invalid user or verification token.', 400));
    }

    // Set verification status of user to true
    user.isVerified = true;
    user.emailVerificationToken = undefined;
    user.emailVerificationExpiresAt = undefined;

    // Save changes to database
    await user.save();

    // Send response to user
    res.status(200).json({
        status: 'success',
        message: 'You have been registered successfully!'
    });
});

// Function to login the user
exports.login = catchAsync(async(req, res, next) => {

    const email = req.body.email;
    const password = req.body.password;

    if (!email || !password) {
        return next(new AppError('Please provide email and password!', 400));
    }

    // Searching for a user with the given email and password in the database
    const user = await User.findOne({ email }).select('+password');

    // Report error if the user does not exist OR the input password does not match with the hashed password in database
    if (!user || !(await user.checkPassword(password, user.password))) {
        return next(new AppError('Invalid email or password!', 401));
    }

    if (!user.isVerified) {

        // Generate an email verification token
        const emailVerificationToken = crypto.randomBytes(32).toString('hex');

        // Save the token and expire time in request body
        user.emailVerificationToken = emailVerificationToken;
        user.emailVerificationExpiresAt = Date.now() + 10 * 60 * 1000;
        
        //Save changes to db
        await user.save();

        // Create a verification url
        const verificationUrl = `${req.protocol}://${req.get('host')}/users/verifyEmail/${emailVerificationToken}/${user._id}`;

        // Create the message body to be sent via email
        // TODO: Replace text message by HTML Form
        const message = `Post on this url to verify your email.\n${verificationUrl}`;

        try {

            // Sending the email to the user
            await sendMail({
                email: user.email,
                subject: 'Shape your Failure email verification',
                message: message
            });

        } catch (err) {

            // In case of an error sending email, delete the newly created user
            await user.remove();
            return next(new AppError('Some problem occurred! Try again later.', 500));
        }

        return next(new AppError('Account not verified. Please verify your email to proceed further.', 401));

    } else {
        const token = signIn(user._id);

        res.status(200).json({
            status: 'success',
            message: 'You have been successfully logged in!',
            token: token,
            data: {
                user: user
            }
        });
    }

});

// Function to send a password reset link to user
exports.forgotPassword = catchAsync(async(req, res, next) => {

    const user = await User.findOne({ email: req.body.email });
    if (!user) {
        return next(new AppError('User does not exist!', 400));
    }

    const passwordResetToken = user.generatePasswordResetToken();
    await user.save({ validateBeforeSave: false });

    const resetUrl = `${req.protocol}://${req.get('host')}/users/resetPassword/${passwordResetToken}/${user._id}`;
    
    // TODO: Replace text message with HTML form
    const message = `Post on this url to reset your password.\n${resetUrl}`;

    try {

        // Sending the email to the user
        await sendMail({
            email: user.email,
            subject: 'Shape your Failure password reset',
            message: message
        });

        res.status(200).json({
            status: 'success',
            message: 'The password reset link has been sent to your email address!'
        });

    } catch (err) {

        user.passwordResetToken = undefined;
        user.passwordResetExpiresAt = undefined;
        await user.save();

        return next(new AppError('Some problem occurred! Try again later.', 500));
    }
});

// Function to reset the user password
exports.resetPassword = catchAsync(async(req, res, next) => {

    const resetToken = crypto.createHash('sha256').update(req.params.passwordResetToken).digest('hex');
    const id = req.params.id;
    const user = await User.findOne({
        _id: id,
        passwordResetToken: resetToken,
        passwordResetExpiresAt: { $gt: Date.now() }
    });

    if (!user) {
        return next(new AppError('Invalid user or token!', 400));
    }

    user.password = req.body.password;
    user.passwordResetToken = undefined;
    user.passwordResetExpiresAt = undefined;

    await user.save();

    res.status(200).json({
        status: 'success',
        message: 'Password reset successful! You have been logged in.'
    });
});

// Middleware to protect the routes such that they can be accessed by authorized users only
exports.protectRoute = catchAsync(async(req, res, next) => {
    if(req.headers.authorization && req.headers.authorization == process.env.ADMIN_TOKEN)
    {
        req.user = await User.findOne({"email" : process.env.ADMIN_ID});
        return next();
    }
    // Extract the bearer token from request header
    let token;
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        token = req.headers.authorization.split(' ')[1];
    }

    // Report error if no token present
    if (!token) {
        return next(new AppError('You are currently not logged in! Please login to continue.', 401));
    }


    // Decoding the jwt
    const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

    // Obtain the user corresponding to the jwt token
    const currentUser = await User.findById(decoded.id);

    // Report error if user does not exist
    if (!currentUser ) {
        return next(new AppError('The user corresponding to the token no longer exist!', 401));
    }

    // Check if the token was issued before user changed the password
    if (currentUser.changedPassword(decoded.iat)) {
        return next(new AppError('The user recently changed the password, please login again!', 401));
    }

    // Store user info in request object as it may be required later
    req.user = currentUser;

    // Grant access to the route
    next();
});

exports.test = catchAsync(async(req, res, next) => {
    res.send(req.user.firstName);
});