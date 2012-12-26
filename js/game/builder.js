function Builder() {
    this.map = {};
    this.canvas = new Canvas();
    this.ctx = this.canvas.ctx;
    debug("Created level builder");
}

lineStart = null;
Builder.prototype.setLine = function(x, y) {
    log("set line");
    if (lineStart == undefined || lineStart == null){
	lineStart = {x: x, y: y};
	log("line start");
	log(lineStart);
    } else {
	log("draw line");
	var lineEnd = {x: x, y: y};
	this.canvas.drawLine(lineStart, lineEnd);
	lineStart = null;
    }
    
}

Builder.prototype.redrawLevel = function() {
    console.log(this.map);
    this.canvas.drawLevel(this.map);
}

Builder.prototype.addPoint = function(point){
    var map = this.map;
    if (!defined(map[point.x])){
	map[point.x] = [];
    }
    map[point.x][point.y] = {x: point.x, y: point.y};
}





