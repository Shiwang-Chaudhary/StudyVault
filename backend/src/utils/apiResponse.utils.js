class ApiError extends Error{
    constructor(statusCode, message, details = null){
        super(message);
        this.statusCode = statusCode;
        this.details = details;
    }
}

const successResponse = (res, statusCode, data = null, meta = {}) =>{
    return res.status(statusCode).json({
        success: true,
        data,
        error: null,
        meta
    });
}

module.exports = {
    ApiError,
    successResponse,
}