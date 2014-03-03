loglevels = {log: 5, debug: 4, error: 3};
loglevel = 4;
log_enabled = true;
function log(message){
    if(log_enabled && loglevel >= loglevels.log){
	console.log("|Log| " + message);
    }
}

function debug(message){
    if(log_enabled && loglevel >= loglevels.debug){
	console.log("|Debug| " + message);
    }
}

function defined(obj){
    return typeof(obj) != 'undefined';
}
