var mongoose = require('mongoose');
var Schema   = mongoose.Schema;

var submissionSchema = new Schema({
	'name' : String,
	'email' : String,
	'image_url' : String,
	'verified' : Boolean
});

module.exports = mongoose.model('submission', submissionSchema);
