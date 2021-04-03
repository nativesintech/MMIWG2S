const mongoose = require('mongoose');
const { Config } = require('../config');

mongoose.connect(Config.DB_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});
