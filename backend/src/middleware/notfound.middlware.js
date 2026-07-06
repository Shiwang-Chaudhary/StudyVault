const notfound = (req, res, next) => {
    return res.status(404).json({
        success: false,
        data: null,
        error: { message: `Route not found: ${req.method} ${req.originalUrl}` }
    });
}

module.exports = notfound;