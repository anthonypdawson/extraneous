loglevels = {log: 5, debug: 4, error: 3};
loglevel = 4;
function log(message){
    if(loglevel >= loglevels.log){
	console.log("|Log| " + message);
    }
}

function debug(message){
    if(loglevel >= loglevels.debug){
	console.log("|Debug| " + message);
    }
}

function defined(obj){
    return typeof(obj) != 'undefined';
}
