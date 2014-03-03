$(document).ready(function () {
    function setup(){
	this.position = [];
	this.mouseDown = false;

	builder = new Builder();
	$("#game_board").live("mousemove", function(e) {
	    if(lineStart != null){	    
		//builder.canvas.drawLine(lineStart, {x: e.clientX, y: e.clientY});
	    }
	    if (mouseDown){
		var pointValue = builder.canvas.drawPoint(e.clientX, e.clientY, 5, 5);
		builder.addPoint(pointValue);
		builder.redrawLevel();
		//log(builder.map);
		//log(pointValue);
	    }
	});

	$("#game_board").live("mousedown", function(e) {
	    if (e.shiftKey) {
		return false;
	    }
	    log("Switching to mouse down");
	    mouseDown = true;
	});

	$("#game_board").on("mouseup", function() {
	    log("Switching to mouse down = false");
	    mouseDown = false;
	});

	$("#game_board").on("click", function(e) {
	    if (!e.shiftKey){
		return false;
	    }
	    builder.setLine(e.clientX, e.clientY);
	});
	$("#redraw").live("click", function() { builder.redrawLevel(); }); 

    }

    function load() {	
	if (typeof Builder == 'undefined' || !(Builder in window)){
	    log("defined");
	    setup(); 


	} else {
	    log("undefined");
	    setTimeout(load, 500);
	} 
    }

    load();
    $("#draw_color").colorPicker();
});
