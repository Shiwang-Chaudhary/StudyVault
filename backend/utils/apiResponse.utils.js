class ApiError extends Error{
    constructor(statusCode, message, details = null){
        super(message);
        this.statusCode = statusCode;
        this.details = details;
    }
}

const successResponse = (res, statusCode, data = null, meta = {}) =>{
    return res.statusCode(statusCode).json({
        success: true,
        data,
        error: null,
        meta
    });
}

const failureResponse = (res, statusCode, message = "Something went wrong", details = null) =>{
    return res.statusCode(statusCode).json({
        success: false,
        data: null,
        error: { message, details },
    });
}

module.exports = {
    ApiError,
    successResponse,
    failureResponse
}