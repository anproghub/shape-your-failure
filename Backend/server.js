// Set the environment variables
const dotenv = require('dotenv');
dotenv.config({ path: './config.env' });

const app = require('./app');
const mongoose = require('mongoose');

//Database Connection
mongoose.connect(process.env.DATABASE_HOST, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log('Connected to database!');
});

const hostname = process.env.SERVER_HOSTNAME;
const port = process.env.SERVER_PORT || 3000;

// Start the server
const server = app.listen(port, hostname, () => {
    console.log(`Server started on port ${port}.`);
});