var express = require('express');
var router = express.Router();
const submissionController = require('../controllers/submissionController.js');

/* GET home page. */
// router.get('/', function(req, res, next) {
//   // res.render('index', { title: 'Express' });
//   res.render('index', {});
// });

router.get('/', submissionController.render);

router.get('/health-check', (req, res) => {
  res.send('ok');
})

module.exports = router;
