function Entity() {
    this.position = {x: 0, y: 0};
    this.height = 0;
    this.width = 0;
    this.shape = null;    
}

Entity.prototype.move = function(x, y){
    this.position.x = x;
    this.position.y = y;
}

function Shape(){

}

Shape.prototype.drawFunction = function(ctx){
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height);
}

function Point = Shape.prototype;

Point.prototype.drawFunction = function(ctx){
    ctx.fillRect(this.position.x, this.position.y, 10, 10);
}

