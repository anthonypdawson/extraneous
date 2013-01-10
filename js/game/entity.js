function Entity() {
    this.position = {x: 0, y: 0};
}

Entity.prototype.move = function(x, y){
    this.position.x = x;
    this.position.y = y;
}

function Shape(){
    Shape.call(this);
    this.name = "Shape";
}

Shape.prototype = new Entity();

function Point() {
    Point.call(this);
    this.height = 0;
    this.width = 0;
    this.name = "Point";
}

Point.prototype = new Shape();

Point.prototype.drawFunction = function(ctx){
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height);
}

function Line(){
    Line.call(this);
    var startPoint;
    var endPoint;
    this.name = "Line";
}

Line.prototype = new Shape();

Line.prototype.drawFunction = function(ctx){
    ctx.moveTo(this.startPoint.x, this.startPoint.y);
    ctx.lineTo(this.endPoint.x, this.endPoint.y);
}

Line.prototype.drawFunction = function(ctx) {
    $.each(this.points, function(i, p){
	if (i == 0){
	    ctx.moveTo(p.x, p.y);
	} else {
	    ctx.lineTo(p.x, p.y);
	    ctx.stroke();
	    ctx.moveTo(p.x, p.y);
	}
    });
}

function Square(){
    Square.call(this);
    this.name = "Square";
}

Square.prototype = new Point();
