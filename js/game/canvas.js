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
    if (!defined(color)) {
	color = this.getColor();
    }
    log(x + " " + y+ " " + w+ " " + h+ " " + color);
    var point = new Point();
    point.setArea(15, 15);
    point.move(x, y);
    point.color = color;
    var ctx = this.ctx;
    
    if (point.color != 'undefined'){
	ctx.fillStyle = point.color;
    } else {
	ctx.fillStyle = this.fillStyle;
    }
    this.drawEntity(point);

    return point;
}

Canvas.prototype.getColor = function() {
    if (defined(jQuery)) {
	el = $(".colorPicker-picker");
	if (defined(el)) { return el.css("background-color"); }
    }
}

Canvas.prototype.drawLevel = function(level){
    canvas = this;
    canvas.ctx.clearRect(0,0,800, 600);
    color = this.getColor();
    $.each(level, function(k, v) {
	if (!defined(v) || v == null){
	    log("undefined");
	} else {
	    $.each(v, function(){
		if (defined(this.color)) { color = this.color }
 		canvas.drawPoint(this.x, this.y, 5, 5, color);
	    });
	}
    });
} 

Canvas.prototype.drawEntity = function(entity){
    this.draw({x: entity.position.x, 
	       y: entity.position.y, 
	       height: entity.height, 
	       width: entity.width,
	       shape: entity});	       
}

Canvas.prototype.draw = function(options){
    var x = defaults("x", options);
    var y = defaults("y", options);
    var width = defaults("width", options);
    var height = defaults("height", options);
    var color = defaults("color", options);    
    if (defined(options.shape) && defined(options.shape.color)) {
	color = options.shape.color;     
    }

    var ctx = this.ctx;
    // Placeholder for fillStyle
    //ctx.fillStyle = 'red';
    if (typeof options.shape != 'undefined'){ 
      ctx.fillStyle = color;
      options.shape.drawFunction(ctx);
      ctx.stroke();
    }
}    

function defaults(prop, val){
    if (typeof val != 'undefined'){	
	if (defined(val[prop]) && val[prop]!=null){
	    return val[prop];
	}
    } else {
	switch(prop){
	    case "color": return "#FFFFFF";
        }
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

