const AppError = require('./../utilities/appError');

exports.storeFile = async(file, path) => {
    file.mv(path, (err) => {
        if (err) {
            console.log(err);
            throw err;
        }
    });
};