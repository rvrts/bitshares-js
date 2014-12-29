###* Adds nested exceptions.  

This would be used to indicate programmer error and 
not be reported to the end user.

https://www.joyent.com/developers/node/design/errors
###
class ErrorWithCause
    
    constructor: (message, cause)->
        ErrorWithCause.throw message, cause

    ErrorWithCause.throw = (message, cause)->
        error = new Error()
        error.message = message
        if cause
            error.message += "\tcaused by:\n\t#{cause.stack}" 
        throw error
    
###*
Localization separates values from the error message key.

Errors that may be reported to the end user.
###
class LocalizedException
    
    constructor: (key, key_params, cause)->
        LocalizedException.throw key, key_params, cause
        
    LocalizedException.throw = (key, key_params=[], cause)->
        error = new Error()
        error.key = key
        error.message = key
        error.key_params = key_params
        if cause 
            error.message += "\tcaused by:\n\t#{cause.stack}" 
        throw error
        
exports.LocalizedException = LocalizedException
exports.ErrorWithCause = ErrorWithCause