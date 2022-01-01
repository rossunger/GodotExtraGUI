extends Control
class_name ScrollableGrid, "grid_icon.png"

export var cell_size = 30
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
		
	var multiplyer = 0
	var lineCount = window_size.y / cell_size + 1
		
	var remainder = fmod(scroll.y, cell_size) 
	
	var lineCountOffset = floor(fmod((scroll.y - remainder) / cell_size, lineCount) * zoom.y)  # int(floor((scroll.y + sign(scroll.y)) / cell_size)) % 10
	
	print(lineCountOffset)
	#if lineCountOffset<0:
	#	lineCountOffset +=1		
	for i in lineCount:		
		var y=i+1
		var offset = y * cell_size #* pow(5,multiplyer) #/ zoom.y								
		offset += remainder
		offset *= pow(5,multiplyer)		
		offset *= zoom.y				

		if y != 0:
			while abs(offset) <= y * cell_size/2:
				#print(offset)
				offset *= 2		
			
		var thickness = 1				
		#if int(y - floor(lineCountOffset/2)) % 5 == 0 :
		#	thickness += 2
		if int(y - lineCountOffset) % 10 == 0 :
			thickness += 2		
		draw_line( Vector2( 0, offset),  Vector2(window_size.x, offset), color, thickness)		
		
		#DEBUG draw the line number
		var totalLineCount = floor(  y - scroll.y / cell_size  * zoom.y)
		draw_string(get_font("normal"), Vector2( 0, offset), str(totalLineCount))
	#Debug draw how far we scrolled
	draw_string(get_font("normal"), Vector2( 200, 30), str(scroll.y))
	
func zoom(delta):	
	zoom *= delta 
	scroll *= delta 
	update()
	
func scroll(delta):
	scroll += delta
	update()
