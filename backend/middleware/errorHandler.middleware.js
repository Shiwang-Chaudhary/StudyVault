const { ApiError } = require('../utils/apiResponse.utils');

// Centralized error handler — every thrown/rejected error from controllers
// (via asyncHandler) ends up here so responses stay consistent.
// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, next) => {
  console.error(err);

  if (err instanceof ApiError) {
    return res.status(err.statusCode).json({
      success: false,
      data: null,
      error: { message: err.message, details: err.details },
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

const notFound = (req, res, next) => {
  res.status(404).json({
    success: false,
    data: null,
    error: { message: `Route not found: ${req.method} ${req.originalUrl}` },
  });
};

module.exports = { errorHandler, notFound };
