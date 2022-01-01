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
	
	var offset = -scroll.y / zoom.y;
	var size = window_size.y / zoom.y;
	var snap = 100
	var from = floor(offset / snap)
	var length = floor(size / snap) + 1

	var grid_minor = 1
	var grid_major = 3
	var thickness
	for y in length - from:
		var i = y + from
		if int(abs(i)) % 10 == 0:
			thickness = grid_major;
		else:
			thickness = grid_minor;
				
		var base_ofs = i * snap * zoom.y - offset * zoom.y
		draw_line(Vector2(0, base_ofs), Vector2(window_size.x, base_ofs), Color(1,1,1,0.2), thickness)	
	
	"""
	var thickness = 1
	var offset	
	var lineCount = (window_size.y / cell_size)	
	var multiplyer = 2
	print(zoom.y)
	for y in lineCount * multiplyer / zoom.y: 				
		offset = y * cell_size / multiplyer * zoom.y + scroll.y
		#offset /= 2
		while offset > window_size.y * zoom.y * multiplyer:
			offset = offset - window_size.y # + fmod(window_size.y, cell_size)
		while offset < 0 :
			offset = offset + window_size.y #+ fmod(window_size.y, cell_size)
		offset = offset * zoom.y
		draw_line( Vector2( 0, offset),  Vector2(window_size.x, offset), color, thickness)		
	
	
	
	var lineCount = window_size.x / cell_size / zoom.x
	var multiplyer = 0
	
	while lineCount > window_size.x / cell_size * 5: 
		lineCount /= 5
		multiplyer += 1
	for x in lineCount:		
		var offset = fmod(scroll.x + window_size.x, cell_size)  + ( x * cell_size  ) * pow(5, multiplyer)
		var thickness = 1
		if (x - int(offset)) % 5 == 0:
			thickness += 1
		if (x - int(offset)) % 10 == 0:
			thickness += 1
		
		draw_line( Vector2( offset * zoom.x, 0),  Vector2(offset  * zoom.x, window_size.y), color, thickness)
	
	multiplyer = 0
	lineCount = window_size.y / cell_size * zoom.y
	while lineCount > window_size.y / cell_size : 
		lineCount /= 5
		multiplyer += 1
	while lineCount < window_size.y / cell_size : 
		lineCount *= 5
		multiplyer -= 1
		
	var remainder = 0 #abs(fmod(scroll.y, cell_size) * zoom.y)
	
	var lineCountOffset = floor((scroll.y + sign(scroll.y)) /cell_size * pow(5,multiplyer))
	
	if lineCountOffset<0:
		lineCountOffset +=1	
	print (remainder / zoom.y)
	for y in lineCount:		
		var offset = (remainder) + ( y * cell_size  ) * pow(5,multiplyer) / zoom.y
		var thickness = 1				
		if int(y - (lineCountOffset/zoom.y)) % 5 == 0 :
			thickness += 3
		#if int(y) % 10 == 0 + fmod(scroll.y + window_size.y, cell_size) + ( y * cell_size  ):
		#	thickness += 1
		draw_line( Vector2( 0, offset),  Vector2(window_size.x, offset), color, thickness)		
	"""
	
func zoom(delta):	
	zoom *= delta 
	scroll *= delta 
	update()
	
func scroll(delta):
	scroll += delta / zoom
	update()
