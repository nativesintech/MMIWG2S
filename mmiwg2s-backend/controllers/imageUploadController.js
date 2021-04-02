const aws = require('aws-sdk');
const multer = require('multer');
const multerS3 = require('multer-s3');
const fs = require('fs').promises;
const HttpException = require('http-exception');
const HttpStatus = require('http-exception');
var path = require('path');
var crypto = require("crypto");

const localStorage = multer.diskStorage({
  destination: async (req, file, cb) => {
    try {
      const uploadPath = "./public/"+process.env.STORAGE_LOCATION;
      await fs.mkdir(uploadPath, {
        recursive: true,
      });
      cb(null, uploadPath);
    } catch (error) {
      cb(new HttpException(`Could not create save directory`, HttpStatus.BAD_REQUEST), false);
    }
  },
  filename: (req, file, cb) => {
    try {
      var id = crypto.randomBytes(10).toString('hex');
      cb(null, `${id}${path.extname(file.originalname)}`);
    } catch (error) {
      cb(new HttpException(`Could not save file`, HttpStatus.BAD_REQUEST), false);
    }
  },
});

const s3 = new aws.S3({
  endpoint: process.env.STORAGE_LOCATION,
  accessKeyId: process.env.ACCESS_KEY,
  secretAccessKey: process.env.SECRET_KEY
});

const spacesStorage = multerS3({
  s3: s3,
  bucket: process.env.BUCKET || "sf",
  contentType: multerS3.AUTO_CONTENT_TYPE,
  acl: 'public-read',
  key: function (request, file, cb) {
    try {
      var id = crypto.randomBytes(10).toString('hex');
      cb(null, `${id}${path.extname(file.originalname)}`);
    } catch (error) {
      cb(new HttpException(`Could not save file`, HttpStatus.BAD_REQUEST), false);
    }
  }
})

function getDestination () {
  if(process.env.STORAGE_LOCATION.toString().includes("digitaloceanspaces")) return spacesStorage;
  else return localStorage;
}

const uploadImg = multer({
  limits: {
    fileSize: process.env.MAX_FILE_SIZE || 5000000, // 5 mb per file default or change in env
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.match(/\/(jpg|jpeg|png|webp)$/)) { // reject everything except images
      cb(null, true);
    } else {
      cb(new HttpException(`Unsupported file type ${path.extname(file.originalname)}`, HttpStatus.BAD_REQUEST), false);
    }
  },
  storage: getDestination()
});

const deleteImg = function (file_name, cb) {
  // not handling deleting local images
  // as storage is not a big deal locally
  var params = {
    Bucket: process.env.BUCKET || "sf",
    Key: file_name
  };
  s3.deleteObject(params, function(err, data) {
    if (err) {
      cb(false);
    } else {
      cb(true);
    }
  });
}

exports.uploadImg = uploadImg;
exports.deleteImg = deleteImg;
