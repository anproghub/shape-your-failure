const express = require('express');
const app = express();
app.use(express.json());
// Set the environment variables
const dotenv = require('dotenv');
dotenv.config({ path: './config.env' });

//The ML checks will run parallely on this port
const port = 8800;
const router = express.Router();
const offensiveImagesCheck = require('./offensiveImagesCheck');
const offensiveTextsCheck = require('./offensiveTextsCheck');
const sentimentAnalysis = require('./sentimentAnalysis');
const { default: axios } = require('axios');
let auth = "";

//Setting route for analysing the image which has been sent for analysis
router.get('/image/', async (req,res) => {
    const predictions = await offensiveImagesCheck.imageAnalysis(req.headers.imageurl,auth);
    res.status(200).json(predictions);
});

//Setting route for analysing the text which has been sent for analysis
router.get('/text/', async (req,res) => {
    await offensiveTextsCheck.textAnalysis(res,req.headers.text);
});

//Setting route for analysing the sentiment of the text sent
router.get('/sentiment/', async (req,res) => {
    const sentimentScore = await sentimentAnalysis.processData(req.headers.desc);
    res.status(200).json({
        "sentimentScore" : sentimentScore});
});

app.use('/',router);

const server = app.listen(port, "0.0.0.0", () => {
    console.log(`Server started on port ${port}`);
    //TODO: Login the admin as it is required to be logged in for getting images
    auth = process.env.ADMIN_TOKEN;
    axios({
        method: 'get',
        url: "http://localhost:8000/users/me",
        headers: {
            'Content-Type' : 'application/json',
            'authorization' : auth
        }
    }).then(res => console.log(res.data)).catch(error => console.log(error));
});