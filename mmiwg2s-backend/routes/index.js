var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/health-check', (req, res) => {
  res.send('ok');
})

module.exports = router;
