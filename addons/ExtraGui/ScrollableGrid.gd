extends Control
class_name ScrollableGrid, "grid_icon.png"

export var cell_size = 50
var zoom = Vector2(1,1)
var scroll = Vector2(0,0)
export var color = Color(0,0,0,0.2)
var parent
func _ready():
	parent = get_parent()	
	parent.connect("zoom", self, "zoom")
	parent.connect("scroll", self, "scroll")
	rect_size = Vector2(0,0)
	
	
func _draw():
	var window_size = OS.window_size
	
	for x in window_size.x / cell_size * zoom.x:		
		var offset = fmod(scroll.x + window_size.x, cell_size) + ( x * cell_size  )
		draw_line( Vector2( offset * zoom.x, 0),  Vector2(offset  * zoom.x, window_size.y), color, 1)
	
	for y in window_size.y /  cell_size * zoom.y:
		var offset = fmod(scroll.y + window_size.y, cell_size) + ( y * cell_size  )
		draw_line( Vector2( 0, offset * zoom.y),  Vector2(window_size.x, offset * zoom.y), color, 1)
		
func zoom(delta):
	if delta.x == 0:
		print("delta: 0")
	print("zooming scrollable: ", zoom.x)
	zoom *= delta 
	scroll *= delta 
	update()
	
func scroll(delta):
	scroll += delta / zoom
	update()
