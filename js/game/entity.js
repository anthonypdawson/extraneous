function Entity() {
    this.position = {x: 0, y: 0};
    this.color = '#FFFFFF';
    this.shape = typeof(this);
}

Entity.prototype.move = function(x, y){
    this.position.x = x;
    this.position.y = y;
}

Entity.prototype.setArea = function(h, w) {
    this.height = h;
    this.width = w;
}
Entity.prototype.drawFunction = function(ctx){
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height);
}
 
function Shape(){
    Entity.call(this);
    this.name = "Shape";
    this.shape = typeof(this);
}

Shape.prototype = new Entity();

function Point() {
    Shape.call(this);
    this.name = "Point";
    this.setArea(0,0);
    this.shape = typeof(this);
}

Point.prototype = new Shape();

Point.prototype.drawFunction = function(ctx){
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height);
}

function Line(){
    Shape.call(this);
    var startPoint;
    var endPoint;
    this.name = "Line";
    this.shape = typeof(this);
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
    Shape.call(this);
    this.name = "Square";
    this.shape = typeof(this);
}

Square.prototype = new Point();
