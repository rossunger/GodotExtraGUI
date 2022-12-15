class_name Scrollable extends Control
@icon("move_icon.png")

# This component makes the parent a scrollbox, allowing you to scroll it's children, and zoom in and out

@export var canScrollX = true
@export var canScrollY = true
@export var canZoomX = true
@export var canZoomY = true
@export var onlyDraggables = true 

var bounds: Rect2
var x = 0
var y = 0
var w = 1
var h = 1
@export var scroll_speed = 20
@export var zoom_speed = 0.1

var parent #the actual Control that will be scrolled 

func _ready():	
	parent = get_parent()			
	if not parent is Control:
		queue_free()
	
func doScroll(delta):
	x += delta.x
	y += delta.y
	for c in parent.get_children():
		if onlyDraggables && !c.has_node("Draggable"):
			continue
		if c is Control:
			c.position += delta


#Recursively zoom the children, but only if they have a "draggable" node
#This allows you to zoom without affecting the size of labels, etc. 
func doZoom(par, delta):	
	if onlyDraggables:
		for c in par.get_children():		
			if c is Control && c.visible && c.has_node("Draggable"):			
				if canZoomX:
					c.size.x *= delta 
					c.position.x *=delta				
				if canZoomY:
					c.size.y *= delta 
					c.position.y *=delta				
																	
				#recursive zoom all the children
				doZoom(c, delta)			
	else:		
		parent.scale *= delta

func _input(event):		
	if !is_visible_in_tree():
		return
		
	#Frame all draggables so you can see them (i.e. zoom out/in and scroll as needed so that the bounding box of all the draggales combines is equal to the screen size)
	if Input.is_key_pressed(KEY_F) && Input.is_key_pressed(KEY_ALT):
		
		#Step 1: get the biggest bounding box of all this "scrollables" children combined
		bounds = getBounds()
		
		#Step 2: calculate how much we need to zoom
		var delta = bounds.size		
		var d = min(parent.size.x/delta.x, parent.size.y/ delta.y)
		
		#Step 3: Zoom and Pan
		doScroll(-bounds.position + Vector2(1,1))		
		doZoom(parent, d)		
		
	#mousehweel = scroll
	#Control + mousewheel = zoom		
	if event is InputEventMouseButton:		
		if Input.is_key_pressed(KEY_CTRL):
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && canZoomX:							
				doZoom(parent, 1 + zoom_speed)				
				doScroll( ( -event.position) / scroll_speed )
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && canZoomX:				
				doZoom(parent, 1 - zoom_speed)
				doScroll( ( event.position) / scroll_speed )
		else:
			if event.button_index == MOUSE_BUTTON_WHEEL_RIGHT && canScrollX:
				doScroll(Vector2(0-scroll_speed,0))			
			if event.button_index == MOUSE_BUTTON_WHEEL_LEFT && canScrollX:
				doScroll(Vector2(scroll_speed,0))		
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && canScrollY:
				doScroll(Vector2(0,scroll_speed))			
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && canScrollY:
				doScroll(Vector2(0,0-scroll_speed))	

#Gets the biggeset bounding box of all the parent's children
func getBounds() -> Rect2:
	var topleft
	var bottomright
	for c in parent.get_children():
		if c.has_node("Draggable"):
			if !topleft:
				topleft = c.global_position
			if !bottomright:
				bottomright = c.global_position + c.size
			topleft.x = min(topleft.x, c.global_position.x)
			topleft.y = min(topleft.y, c.global_position.y)				
			bottomright.x = max(bottomright.x, c.global_position.x + c.size.x )
			bottomright.y = max(bottomright.y, c.global_position.y + c.size.y )			
	return Rect2(topleft, bottomright-topleft)
		
