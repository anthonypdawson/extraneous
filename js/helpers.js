
function doShake(elem, opts, duration) {
    var active = document.activeElement;
    elem.effect("shake", opts, duration, fixFocus);
    fixFocus();

    function fixFocus() {
        if (active === elem[0] || $.contains(elem[0], active)) {
            $(active).focus();
        }
    }
}
function nullOrUndefined(obj) {
    return obj == null || obj == undefined;
}

function loadfile(filename, filetype) {
    var fileref = null;
    if (filetype == "js") { //if filename is a external JavaScript file
        fileref = document.createElement('script');
        fileref.setAttribute("type", "text/javascript");
        fileref.setAttribute("src", filename);
    } else if (filetype == "css") { //if filename is an external CSS file
        fileref = document.createElement("link");
        fileref.setAttribute("rel", "stylesheet");
        fileref.setAttribute("type", "text/css");
        fileref.setAttribute("href", filename);
    }
    if (fileref != null)
        document.getElementsByTagName("head")[0].appendChild(fileref);
}

JavascriptReference = function(url, testFn, onLoad) {
    this.Url = url;
    this.TestFn = testFn;
    this.OnloadFn = onLoad;
    this.AttemptCount = 0;
    this.Timer = null;
};

function loadJavascriptRefs(jsRefCol) {
    $.each(jsRefCol, function () {
        if (loadJavascript(this)) {
            if(this.onLoadFn != undefined) this.onLoadFn();
        }
    });
}


function loadJavascript(jsRef) {
    var logFn = console.log;
    var logmsg = "Trying to setup js file " + jsRef.Url;
    
    if (Logger != undefined) logFn = Logger.debug;

    logFn(logmsg);
    if (jsRef.TestFn()) {
        logFn("Javascript detected. Clearing timer");
        window.clearTimeout(jsRef.Timer);
        logFn("timer cleared");
        return true;
    } else {
        logFn("Javascript not available");
        if ((jsRef.AttemptCount++ % 2) == 0) {
            if (!jsRef.TestFn()) {
                logFn("Trying to load js reference");
                loadfile(jsRef.Url);
            } else {
                return true;
            }
        }
        
        jsRef.Timer = window.setTimeout(function () {
            loadJavascriptRefs([jsRef]);
        }, 1000);        
    }
 
}

$().ready(function () {
    $.fn.center = function () {
        this.css({
            'position': 'fixed',
            'left': '50%',
            'top': '50%'
        });
        this.css({
            'margin-left': -this.width() / 2 + 'px',
            'margin-top': -this.height() / 2 + 'px'
        });

        return this;
    };

    $.fn.strFormat = strFormat = function(text, variables) {
        
        for (var i = 0; i < variables.length; i++) {
            text = text.replace("{" + i + "}", variables[i]);
        }
        return text;

    };


});