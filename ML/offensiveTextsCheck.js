const tfjs = require('@tensorflow/tfjs-node');
//Using Tensorflow's toxicity model
const toxicity = require('@tensorflow-models/toxicity');

//Threshold defines at what sensitivity do we stop allowing texts on our app
const threshold = 0.6;

exports.textAnalysis = async (res,text) => {
  // const sentences = text.split('.'); // Reg ex use, for ? ! 
  toxicity.load(threshold).then(model => {
    model.classify(text).then(predictions => res.status(200).json(predictions));
  });
}

