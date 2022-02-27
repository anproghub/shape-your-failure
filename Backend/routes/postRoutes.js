const router = require("express").Router();
const postController = require('./../controllers/postController');
const authController = require('./../controllers/authController');
const likeController = require('./../controllers/likeController');
const commentController = require('./../controllers/commentController');
const reportCommentController = require('./../controllers/reportCommentController');
const reportController = require('./../controllers/reportController');

//create a post
router.post("/", authController.protectRoute, postController.createAPost);

//Update a post
router.put("/:id", authController.protectRoute, postController.updateAPost);

//Delete a post
router.delete("/:id", authController.protectRoute, postController.deleteAPost);

//Get all post
router.get("/", authController.protectRoute, postController.getAllPosts);

//Get recommended post
router.get("/recommended", authController.protectRoute, postController.getRecommendedPosts);

//Get post image
router.get("/image/:fileName", authController.protectRoute, postController.getPostImage);

//React on a particular post
router.post('/:id/like', authController.protectRoute, likeController.likePost);

//fetch all reactions on a particular post
router.get('/:id/like', authController.protectRoute, likeController.getAllLikes)

//Create a comment on a post with postid = :id
router.post('/:id/comment', authController.protectRoute, commentController.createAComment);

//Update a comment with :commendid on a post with postid = :id 
router.put('/:id/comment/:commentid', authController.protectRoute, commentController.updateAComment);

//Get comments with query on a post with postid = :id
router.get("/:id/comment", authController.protectRoute, commentController.getAllPostComments);

//Get all replies to a comment with :commendid on a post with postid = :id 
router.get("/:id/comment/:commentid", authController.protectRoute, commentController.getAllReplies);

//Delete a comment with :commendid on a post with postid = :id 
router.delete("/:id/comment/:commentid", authController.protectRoute, commentController.deleteAComment);

//Report a comment with :commentid on a post with postid = :id 
router.post("/:id/comment/:commentid/report/", authController.protectRoute, reportCommentController.reportAComment);

//Report a post with :id
router.post('/:id/report', authController.protectRoute, reportController.reportPost);

module.exports = router;