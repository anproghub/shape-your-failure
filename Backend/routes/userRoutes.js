const express = require('express');
const userController = require('./../controllers/userController');
const authController = require('./../controllers/authController');
const notificationController = require('./../controllers/notificationController');
const router = express.Router();

// Signup request
router.post('/signup', authController.signUp);

// Email verification
router.get('/verifyEmail/:verificationToken/:id', authController.verifyEmail);

// Login request
router.post('/login', authController.login);

// Forgot password request
router.post('/forgotPassword', authController.forgotPassword);

// Reset password request
router.get('/resetPassword/:passwordResetToken/:id', authController.resetPassword);

// To fetch user info using bearer token
router.get('/me', authController.protectRoute, userController.getUser);

// To fetch user profile image
router.get('/image/:fileName', authController.protectRoute, userController.getUserImage);

router.put('/', authController.protectRoute, userController.updateUser);

// Get information of users
router.get('/', authController.protectRoute, userController.getAllUsers);

//get all notifications of a user
router.get("/notification", authController.protectRoute, notificationController.getAllNotification);

module.exports = router;