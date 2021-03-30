var express = require('express');
var router = express.Router();
var submissionController = require('../controllers/submissionController.js');

/*
 * GET
 */
router.get('/', submissionController.list);

/*
 * GET
 */
router.get('/:id', submissionController.show);

/*
 * POST
 */
router.post('/', submissionController.create);

/*
 * PUT
 */
router.put('/:id', submissionController.update);

/*
 * DELETE
 */
router.delete('/:id', submissionController.remove);

module.exports = router;
