var express = require('express');
var router = express.Router();
const submissionController = require('../controllers/submissionController.js');


router.get('/', function(req, res, next) {
  // res.render('index', { title: 'Express' });
  // res.render('index', {});
  res.sendStatus(200);
});

/* GET home page. */
router.get('/shared-with-us', submissionController.render);

router.get('/health-check', (req, res) => {
  res.send('ok');
})

module.exports = router;
