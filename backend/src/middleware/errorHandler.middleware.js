const { ApiError } = require('../utils/apiResponse.utils');


const errorHandler = (err, req, res, next) => {
  console.error(err);

  if (err instanceof ApiError) {
    return res.status(err.statusCode).json({
      success: false,
      data: null,
      error: { message: err.message, details: err.details },
    });
  }
  //File limit exceed error
  if(err.code === 'LIMIT_FILE_SIZE'){
    return res.status(400).json({
      success: false,
      data: null,
      error: { message: 'File size limit exceeded', details: err.message },
    });
  }
  // Mongoose validation error
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      data: null,
      error: { message: 'Validation failed', details: err.errors },
    });
  }

  // Mongoose duplicate key error (e.g. duplicate like/rating)
  if (err.code === 11000) {
    return res.status(409).json({
      success: false,
      data: null,
      error: { message: 'Duplicate entry', details: err.keyValue },
    });
  }

  return res.status(500).json({
    success: false,
    data: null,
    error: { message: err.message || 'Internal server error' },
  });
};

module.exports =  errorHandler;
