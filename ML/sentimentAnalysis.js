const fetch = require('node-fetch');
const tf  = require('@tensorflow/tfjs-node');
const urls = {
    model: 'https://storage.googleapis.com/tfjs-models/tfjs/sentiment_cnn_v1/model.json',
    metadata: 'https://storage.googleapis.com/tfjs-models/tfjs/sentiment_cnn_v1/metadata.json'
};
const SentimentThreshold = {'Positive' : 0.9,
                            'Neutral' : 0.65,
}
 
//loading the inbuild model of tensorflow
async function loadModel(url) {
    try {
        const model = await tf.loadLayersModel(url);
        return model;
    } catch (err) {
        console.log(err);
    }
}
 
//loading the metadata of tensorflow
async function loadMetadata(url) {
    try {
        const metadataJson = await fetch(url);
        const metadata = await metadataJson.json();
        return metadata;
    } catch (err) {
        console.log(err);
    }
}

//function for padding the sequence
function padsequences(sequences, maxlen, padding = 'pre', truncating = 'pre', value = 0) {
    return sequences.map(seq => {
        // Perform truncation.
        if (seq.length > maxlen) {
            if (truncating === 'pre') {
                seq.splice(0, seq.length - maxlen);
            } else {
                seq.splice(maxlen, seq.length - maxlen);
            }
        }
        // Perform padding.
        if (seq.length < maxlen) {
            const pad = [];
            for (let i =0; i < maxlen - seq.length; ++i) {
                pad.push(value);
            }
            if (padding =='pre') {
                seq = pad.concat(seq);
            } else {
                seq = seq.concat(pad);
            }
        }
        return seq;
    });
}

//function which receives the text via api call and then process the text to calculate its sentiment score
exports.processData = async (desc) => {

    //cleaning text i.e removing url and stuff
    desc = await desc.replace(/(?:https?|ftp):\/\/[\n\S]+/g, '');
    desc = await desc.replace(/[^a-z0-9 .!]/gi,'');
    // desc = desc.replace(/./g, " ");
    const sentiment_score = await getSentimentScore(desc);
    let desc_sentiment = '';
    if(sentiment_score > SentimentThreshold.Positive){
        desc_sentiment = 'Positive';
    } else if(sentiment_score > SentimentThreshold.Neutral){
        desc_sentiment = 'Neutral';
    } else{
        desc_sentiment = 'Negative';
    }
    return sentiment_score;
}
  
//function to calculate the sentiment score of the text using tensorflow
async function getSentimentScore(text) {
    const metadata = await loadMetadata(urls.metadata);
    const model = await loadModel(urls.model);
    let inputText = await text.trim().toLowerCase().replace(/(\.|\,|\!)/g, ' ').trim().split(' ');
    inputText =  await inputText.filter(e =>  e);
    // Convert the words to a sequence of word indices.
    const sequence = inputText.map(word => {
        let wordIndex = metadata.word_index[word] + metadata.index_from;
        if (wordIndex > metadata.vocabulary_size) {
            wordIndex = OOV_INDEX;
        }
        return wordIndex;
    });
    // Perform truncation and padding.
    const paddedSequence = padsequences([sequence], metadata.max_len);
    const input = tf.tensor2d(paddedSequence, [1, metadata.max_len]);
    const predictOut = model.predict(input);
    const score = predictOut.dataSync()[0];
    // Tensor memory must be managed explicitly, out of scope isn't sufficient
    predictOut.dispose();
    return score;
}

