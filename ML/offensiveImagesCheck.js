const { default: axios } = require("axios");
const tf = require('@tensorflow/tfjs-node')

//We're using NSFWJS from tensorflow for classifying image
const nsfw = require('nsfwjs')

exports.imageAnalysis = async (img,auth) => {

  //Getting the pic using axios
  let pic = await axios({
    method: 'get',
    url: img,
    responseType : 'arraybuffer',
    headers: {
      'authorization' : auth
    }
  });

  //Loading the inbuild model
  const model = await nsfw.load() 

  // Image must be in tf.tensor3d format, we convert with tf.node.decodeImage(Uint8Array,channels)
  const image = await tf.node.decodeImage(pic.data,3)
  const predictions = await model.classify(image)

  // Tensor memory must be managed explicitly, out of scope isn't sufficient
  image.dispose() 

  //Returning the predictions in 5 categories
  return predictions;
}
