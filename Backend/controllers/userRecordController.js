const User = require('./../models/userModel');
const AppError = require('./../utilities/appError');
exports.createUserRecord = async(userRecordObj) => {
    const tags = userRecordObj.tags;
    const userId = userRecordObj.userId;
    const value = userRecordObj.value;
    let user = await User.findOne({ _id: userId });
    console.log(tags);
    for (tagIndex in tags) {
        const oldValue = user.userHistoryMap.get(tags[tagIndex]._id);
        console.log("Old value : ", oldValue);
        await user.userHistoryMap.set(tags[tagIndex]._id, value + (oldValue ? oldValue : 0));
        await user.save();
        console.log("value added");
    }
}