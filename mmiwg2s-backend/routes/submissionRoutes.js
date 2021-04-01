const express = require('express');
const router = express.Router();
const submissionController = require('../controllers/submissionController.js');
const uploadContoller = require('../controllers/imageUploadController.js');
const rateLimit = require("express-rate-limit");

const apiLimiter = rateLimit({
   windowMs: process.env.WINDOW_MS,
   max: process.env.MAX_PER_WINDOW,
   statusCode: 200,
   message: {
    status: 429,
    error: 'Please wait a minute before you try again!'
   }
});

/*
 * GET
 * Returns random <number> entries default is 5
 */
router.get('/random/:number?', submissionController.list);

/*
 * GET
 * Returns the entry for the specific email id
 */
router.get('/:emailId', submissionController.show);

/*
 * POST
 * Accepts a submission
 */
router.post('/', apiLimiter, uploadContoller.uploadImg.single("image"), submissionController.create);

/*
 * PUT
 * This route is unused now
 * TODO update the verified or not using this
 */
// router.put('/:id', submissionController.update);

/*
 * DELETE
 * We do not want to delete any entries now
 */
// router.delete('/:id', submissionController.remove);

module.exports = router;
