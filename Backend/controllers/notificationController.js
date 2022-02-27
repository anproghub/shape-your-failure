const Notification = require('./../models/notificationModel');
const DbFeatures = require('./../utilities/dbFeatures');
const catchAsync = require('./../utilities/catchAsync');

//create a notification!
exports.createNotification = async(notificationObj) => {
    const notification = await Notification.create(notificationObj);
};

// fetch all notifications of a user
exports.getAllNotification = catchAsync(async(req, res, next) => {
    console.log(req.user._id);
    const dbFeatures = new DbFeatures(Notification.find(), req.query)
        .filter()
        .sort()
        .filterFields()
        .paginate();

    const notifications = await dbFeatures.dbQuery.find({receiverId : req.user._id});

    res.status(200).json({
        status: 'success',
        data: {
            notifications: notifications
        }
    });
});
