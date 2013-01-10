function Canvas(map) {
    this.canvas = document.getElementById("game_board");
    this.ctx = this.canvas.getContext("2d");
    debug("Created canvas");
    this.fillStyle = this.ctx.fillStyle;
    this.map = returnDefault(map, {});
}

Canvas.prototype.drawLine = function(startLine, endLine){
    var ctx = this.ctx;
    log(startLine);
    log(endLine);
    ctx.moveTo(startLine.x, startLine.y);
    ctx.lineTo(endLine.x, endLine.y);
    ctx.stroke();
}

Canvas.prototype.drawPoint = function(x, y, w, h, color){
    if (!defined(x) && !defined(y)){
	return false;
    }
    console.log(x + " " + y+ " " + w+ " " + h+ " " + color);
    var point = new Entity();
    point.move(x, y);
    
    var ctx = this.ctx;
    ctx.fillStyle = this.fillStyle

    if (color != null){
	ctx.fillStyle = color;
    }

    ctx.fillStyle = color;
    this.drawEntity(point);

    return {x: x, y: y, width: w, height: h, color: color};
}

Canvas.prototype.drawLevel = function(level){
    canvas = this;
    canvas.ctx.clearRect(0,0,800, 600);
    console.log(level);
    $.each(level, function(k, v) {
	if (!defined(v) || v == null){
	    log("undefined");
	} else {
	    $.each(v, function(){
 		canvas.drawPoint(this.x, this.y, 5, 5, "#FF0000");
	    });
	}
    });
} 

Canvas.prototype.drawEntity = function(entity){
    this.draw({x: entity.position.x, 
	       y: entity.position.y, 
	       height: entity.height, 
	       width: entity.width,
	       shape: entity.shape});	       
}

Canvas.prototype.draw = function(options){
    var x = defaults("x", options);
    var y = defaults("y", options);
    var width = defaults("width", options);
    var height = defaults("height", options);
    var color = defaults("color", options);

    var ctx = this.ctx;
    // Placeholder for fillStyle
    ctx.fillStyle = 'red';
    options.shape.drawFunction(ctx);
}    

function defaults(prop, val){
    if (defined(val[prop]) && val[prop]!=null){
	return val[prop];
    }

    switch(prop){
    case 'x': 
    case 'y': return returnDefault(val[prop], 0);
    case 'w':
    case 'h': return returnDefault(val[prop], 5);
    case 'color': return returnDefault(val[prop], "#FFFFFF");
    }
}

    function returnDefault(val, defaultVal)
    {
	if(!defined(val) || val == null){
	    return defaultVal;
	}
	return val;
    }

