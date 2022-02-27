const mongoose = require('mongoose');

// Required for performing necessary data validations
const validator = require('validator');

// Required for generating strong hashes for sensitive data
const bcrypt = require('bcryptjs');

// Required for generating random tokens for verification purpose
const crypto = require('crypto');

const userSchema = mongoose.Schema({
    firstName: {
        type: String,
        minlength: [2, 'Minimum length of first name must be 2.'],
        maxlength: [20, 'Maximum length of first name must be 20.'],
        trim: true,
        required: [true, 'User must have a first name.']
    },
    lastName: {
        type: String,
        minlength: [2, 'Minimum length of last name must be 2.'],
        maxlength: [20, 'Maximum length of last name must be 20.'],
        trim: true,
        required: [true, 'User must have a last name.']
    },
    username: {
        type: String,
        minlength: [4, 'Minimum length of username must be 4'],
        maxlength: [20, 'Maximum length of username must be 20'],
        required: [true, 'A user must provide a username.'],
        trim: true,
        lowercase: true,
        unique: true
    },
    image: {
        type: String,
        default: `${process.env.SERVER_URL}/users/image/none.jpg`
    },
    bio: {
        type: String,
        maxlength: [100, 'Bio must be less than 100 characters.'],
        trim: true
    },
    email: {
        type: String,
        unique: true,
        required: [true, 'Please provide email.'],
        validate: [validator.isEmail, 'Please provide a valid email address.']
    },
    password: {
        type: String,
        required: [true, 'A user must have a password.'],
        minlength: [8, 'Password must be at least 8 characters long.'],
        select: false
    },
    isVerified: {
        type: Boolean,
        default: false
    },
    emailVerificationToken: String,
    emailVerificationExpiresAt: Date,
    createdAt: Date,
    passwordChangedAt: Date,
    passwordResetToken: String,
    passwordResetExpiresAt: Date
});

// Function to check if the password provided by user matches with hashed password stored in database
userSchema.methods.checkPassword = async function(candidatePassword, userPassword) {
    return await bcrypt.compare(candidatePassword, userPassword);
}

// Function to generate a password reset token for user
userSchema.methods.generatePasswordResetToken = function() {
    const resetToken = crypto.randomBytes(32).toString('hex');

    this.passwordResetToken = crypto.createHash('sha256').update(resetToken).digest('hex');
    this.passwordResetExpiresAt = Date.now() + 10 * 60 * 1000;

    return resetToken;
}

// Function to check if password has been changed since last jwt token
userSchema.methods.changedPassword = function(JWTTimestamp) {
    if (this.passwordChangedAt) {
        const changedTime = parseInt(this.passwordChangedAt.getTime() / 1000, 10);
        return JWTTimestamp < changedTime;
    }

    return false;
}

// Middleware to add the createdAt field for newly created user
userSchema.pre('save', function(next) {
    if (this.isNew) {
        this.createdAt = Date.now();
    }
    next();
});

// Middleware to set the passwordChangedAt field in user document
userSchema.pre('save', function(next) {
    if (!this.isModified('password') || this.isNew) {
        return next();
    }

    // -2000 is to ensure that the jwt issue time is always more than password change time
    this.passwordChangedAt = Date.now() - 2000;

    next();
});

// Middleware to generate a hash for password and store it in database 
userSchema.pre('save', async function(next) {

    // New hash should be generated whenever the password changes
    if (!this.isModified('password')) {
        return next();
    }
    this.password = await bcrypt.hash(this.password, 12);
    next();
});

const User = mongoose.model('User', userSchema);

module.exports = User;