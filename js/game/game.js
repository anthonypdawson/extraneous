function Game() = {
    this.canvas = new Canvas();
    this.lines: [],
    this.entities: []};
}

Game.prototype.createEntity = function(x, y, w, h){
    this.entities.push({X: x, Y:y, width: w, height: h});
};

Game.prototype.drawLine = function(start, end) {
    var canvas = this.canvas;
    canvas.drawLine(start, end);
};

Game.prototype.drawDot = function(x, y, w, h, color) {
    if(w == null){
	w = 5;
    }
    if(h == null){
	h = 5;
    }
    this.canvas.drawPoint(x, y, w, h);
};
Game.prototype.draw = function() {
    var game = this;
	    $(game.lines).each(function() {
		game.drawLine(this.start, this.end);
	    });
	    $(game.entities).each(function() {
		console.log(this);
		game.drawDot(this.X, this.Y, this.width,  this.height);
	    });
	};

})
