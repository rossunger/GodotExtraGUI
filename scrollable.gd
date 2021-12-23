extends Control
class_name scrollable, "move_icon.png"

export var canScrollX = true
export var canScrollY = true
export var canZoomX = true
export var canZoomY = true
export var requireMouseOver = true

var x = 0
var y = 0
var w = 1
var h = 1
export var scroll_speed = 20
export var zoom_speed = 0.1
var parent

func _ready():
	parent = get_parent()		
	if !parent as Control:
		queue_free()

func doScroll(delta):
	x += delta.x
	y += delta.y
	for c in parent.get_children():
		if c as Control:
			c.rect_position += delta


#Recursively zoom the children, but only if they have a "draggable" node
#This allows you to zoom without affecting the size of labels, etc. 
func doZoom(par, delta):
	for c in par.get_children():		
		if c is Control && c.visible && c.has_node("draggable"):									
			c.rect_size *= delta * Vector2(canZoomX, canScrollY)
			c.rect_position *=delta												
						
			#recursive zoom all the children
			doZoom(c, delta)			
	
func _input(event):		
	#TO DO: make scrolling only work when mouse is over the object
	if requireMouseOver:			
		if !parent.get_rect().has_point(parent.get_parent().get_local_mouse_position()):
			return	

	#mousehweel = scroll
	#Control + mousewheel = zoom		
	if event is InputEventMouseButton:		
		if Input.is_key_pressed(KEY_CONTROL):
			if event.button_index == BUTTON_WHEEL_UP && canZoomX:
				doZoom(parent, 1 + zoom_speed)
			if event.button_index == BUTTON_WHEEL_DOWN && canZoomX:
				doZoom(parent, 1 - zoom_speed)
		else:
			if event.button_index == BUTTON_WHEEL_RIGHT && canScrollX:
				doScroll(Vector2(0-scroll_speed,0))			
			if event.button_index == BUTTON_WHEEL_LEFT && canScrollX:
				doScroll(Vector2(scroll_speed,0))		
			if event.button_index == BUTTON_WHEEL_UP && canScrollY:
				doScroll(Vector2(0,scroll_speed))			
			if event.button_index == BUTTON_WHEEL_DOWN && canScrollY:
				doScroll(Vector2(0,0-scroll_speed))	
		
