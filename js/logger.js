
LogLevel = {
    NONE: -1,
    DEBUG: 1,
    INFO: 2,
    WARNING: 3,
    ERROR: 4,
    CRITICAL: 5
};

Logger = null;
function JsLog(logLevel) {
    this.level = 3;
    if (typeof logLevel == "number")
        this.level = logLevel;
    Logger = this;
}


JsLog.prototype.log = function (message, maxLevel) {
    if (Logger == undefined || Logger.log == undefined) {
        Logger = this;
    }
    
    if (Logger.level == null) Logger.level = LogLevel.NONE;
    if (Logger.level == LogLevel.NONE) return;
    if (maxLevel >= Logger.level)
        console.log(message);
};
JsLog.prototype.debug = function (message) {
    if (Logger == undefined || Logger.log == undefined) {
        Logger = this;
    }
    Logger.log(message, LogLevel.DEBUG);
};
JsLog.prototype.info = function (message) {
    if (Logger == undefined || Logger.log == undefined) {
        Logger = this;
    }
    Logger.log(message, LogLevel.INFO);
};
JsLog.prototype.warning = function (message) {
    if (Logger == undefined || Logger.log == undefined) {
        Logger = this;
    }
    Logger.log(message, LogLevel.WARNING);
};
JsLog.prototype.error = function (message) {
    if (Logger == undefined || Logger.log == undefined) {
        Logger = this;
    }
    Logger.log(message, LogLevel.ERROR);
};
JsLog.prototype.critical = function (message) {
    if (Logger == undefined || Logger.log == undefined) {
        Logger = this;
    }
    Logger.log(message, LogLevel.CRITICAL);
};

Logger = new JsLog(LogLevel.NONE);
