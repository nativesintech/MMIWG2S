var SubmissionModel = require('../models/submissionModel.js');

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

/**
* submissionController.js
*
* @description :: Server-side logic for managing submissions.
*/
module.exports = {

  /**
  * submissionController.list()
  */
  list: function (req, res) {
    const count = parseInt(req.params.number);
    SubmissionModel.aggregate([{$sample: {size: count}}], function(err, submissions) {
      if (err) {
        console.log(err);
        return res.status(500).json({
          message: 'Error when getting submission.',
          error: err
        });
      }

      return res.json(submissions);
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

      return res.json(submission);
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
        var submission = new SubmissionModel({
            name : req.body.name,
            email : req.body.email,
            image_url : req.body.image_url,
            verified : req.body.verified
          });
        return saveSubmission(submission, res);
      }

      // found a submission, updating the entry with new image
      submission.name = req.body.name ? req.body.name : submission.name;
      submission.image_url = req.body.image_url ? req.body.image_url : submission.image_url;
      submission.verified = req.body.verified ? req.body.verified : submission.verified;

      return saveSubmission(submission, res);
    });
  },
  //   var submission = new SubmissionModel({
  //     name : req.body.name,
  //     email : req.body.email,
  //     image_url : req.body.image_url,
  //     verified : req.body.verified
  //   });
  //
  //   submission.save(function (err, submission) {
  //     if (err) {
  //       return res.status(500).json({
  //         message: 'Error when creating submission',
  //         error: err
  //       });
  //     }
  //
  //     return res.status(201).json(submission);
  //   });
  // },

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
