var SubmissionModel = require('../models/submissionModel.js');
const deleteImg = require('../controllers/imageUploadController.js').deleteImg;

const saveSubmission = function(submission, res) {
  submission.save(function (err, submission) {
    if (err) {
      return res.status(500).json({
        message: 'Error when creating submission',
        error: err
      });
    }
    return res.status(201).json(submission);
  });
}

const resolveLocation = function(submissions) {
  if (process.env.BUCKET){
    submissions.map(sub => sub.image_url = "https://"+process.env.BUCKET+"."+process.env.STORAGE_LOCATION+"/"+sub.image_url);
  }
  else {
    const port = process.env.PORT || 3000;
    submissions.map(sub => sub.image_url = "http://localhost:"+port+"/"+process.env.STORAGE_LOCATION+"/"+sub.image_url);
  }
  return submissions
}

/**
* submissionController.js
*
* @description :: Server-side logic for managing submissions.
*/
module.exports = {

  /**
  * render random submissions
  */
  render: function (req, res) {
    SubmissionModel.aggregate([{$sample: {size: 20}}], function(err, submissions) {
      if (err) {
        return
      }
      res.render('index', { subs: resolveLocation(submissions) });
    });
  },

  /**
  * submissionController.list()
  */
  list: function (req, res) {

    const count = req.params.number ? parseInt(req.params.number) : 5;
    SubmissionModel.aggregate([{$sample: {size: count}}], function(err, submissions) {
      if (err) {
        return res.status(500).json({
          message: 'Error when getting submission.',
          error: err
        });
      }

      return res.json(resolveLocation(submissions));
    });
  },

  /**
  * submissionController.show()
  */
  show: function (req, res) {
    var id = req.params.emailId;

    SubmissionModel.findOne({email: id}, function (err, submission) {
      if (err) {
        return res.status(500).json({
          message: 'Error when getting submission.',
          error: err
        });
      }

      if (!submission) {
        return res.status(404).json({
          message: 'No such submission'
        });
      }

      return res.json(resolveLocation([submission]));
    });
  },

  /**
  * submissionController.create()
  */
  create: function (req, res) {

    SubmissionModel.findOne({email: req.body.email}, function (err, submission) {

      if (err) {
        return res.status(500).json({
          message: 'Error submitting submission.',
          error: err
        });
      }

      if (!submission) {
        // no previous submission, creating new
        if (req.body.name && req.body.email && (req.file.filename || req.file.key)) {
          var submission = new SubmissionModel({
              name : req.body.name,
              email : req.body.email,
              image_url : req.file.filename ? req.file.filename : req.file.key,
              verified : false
            });

          return saveSubmission(submission, res);
        }
        else {
          return res.status(500).json({
            message: 'Missing Fields!',
            error: err
          });
        }
      }

      // found a submission, updating the entry
      // only name or verified status is being updated?
      if (req.file === undefined && req.body.name || req.body.verified) {
        submission.name = req.body.name ? req.body.name : submission.name;
        submission.verified = req.body.verified ? req.body.verified : submission.verified;
        return saveSubmission(submission, res);
      }

      // only image is being updated
      if (req.file !== undefined) {
        // delete previous image
        deleteImg(submission.image_url, function (status) {
          console.log("Old file has been deleted", status);
        });

        submission.name = req.body.name ? req.body.name : submission.name; // if name is updated
        submission.verified = req.body.verified ? req.body.verified : submission.verified; // if verified is updated
        submission.image_url = req.file.filename ? req.file.filename : req.file.key; // if new image is uploaded

        return saveSubmission(submission, res);
      }

      // some unknown error
      return res.status(500).json({
        message: 'Error when creating submission',
        error: err
      });
    });
  },

  /**
  * submissionController.update()
  *
  update: function (req, res) {
    var id = req.params.id;

    SubmissionModel.findOne({_id: id}, function (err, submission) {
      if (err) {
        return res.status(500).json({
          message: 'Error when getting submission',
          error: err
        });
      }

      if (!submission) {
        return res.status(404).json({
          message: 'No such submission'
        });
      }

      submission.name = req.body.name ? req.body.name : submission.name;
      submission.email = req.body.email ? req.body.email : submission.email;
      submission.image_url = req.body.image_url ? req.body.image_url : submission.image_url;
      submission.verified = req.body.verified ? req.body.verified : submission.verified;

      submission.save(function (err, submission) {
        if (err) {
          return res.status(500).json({
            message: 'Error when updating submission.',
            error: err
          });
        }

        return res.json(submission);
      });
    });
  },
  */

  /**
  * submissionController.remove()
  *
  remove: function (req, res) {
    var id = req.params.id;

    SubmissionModel.findByIdAndRemove(id, function (err, submission) {
      if (err) {
        return res.status(500).json({
          message: 'Error when deleting the submission.',
          error: err
        });
      }

      return res.status(204).json();
    });
  }
  */
};
