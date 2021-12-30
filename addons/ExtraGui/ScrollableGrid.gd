extends Control
class_name ScrollableGrid, "grid_icon.png"

export var cell_size = 50
var zoom = Vector2(1,1)
var scroll = Vector2(0,0)
export var color = Color(0,0,0,0.2)
var parent
func _ready():
	parent = get_parent()
	
	rect_size = Vector2(0,0)
	pass # Replace with function body.
	
func _draw():
	var window_size = OS.window_size
	
	for x in window_size.x / zoom.x:		
		var offset = fmod(scroll.x,zoom.x) + ( x * cell_size / zoom.x )
		draw_line( Vector2( offset , 0),  Vector2(offset, window_size.y), color, 1)
	
	for y in window_size.y / zoom.y:
		var offset = fmod(scroll.y, zoom.y) + ( y * cell_size / zoom.y )
		draw_line( Vector2( 0, offset),  Vector2(window_size.x, offset), color, 1)
		
