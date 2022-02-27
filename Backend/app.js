const express = require('express');
const morgan = require('morgan');
const upload = require('express-fileupload');

const app = express();

const errorHandler = require('./controllers/errorController');
const userRoutes = require('./routes/userRoutes');
const postRoutes = require('./routes/postRoutes');

app.use(morgan('dev'));

// Middleware to read the body of http post request
app.use(express.json());

// Middleware to read the files provided with body
app.use(upload());

//specifying routes
app.use('/users', userRoutes);
app.use('/posts', postRoutes);

app.use('*', (req, res, next) => {
    res.status(404).send('This route is not defined!');
});
app.use(errorHandler);

module.exports = app;