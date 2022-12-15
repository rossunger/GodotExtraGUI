class_name Draggable extends Control
@icon("move_icon.png")

# This component makes it's parent draggable, resizeable, and deleteable

var resizing = false
var moving = false
var renaming = false

@export var canResizeX = true
@export var canResizeY = true
@export var canMoveX = true
@export var canMoveY = true
@export var canReceiveDrop = true
@export var canBeDragged = true
@export var canClose = true

@export var minWidth = 20
@export var minHeight = 60

@export_node_path(Node) var resizeHandle
@export_node_path(Node) var moveHandle

var parent
var closeButton:Button

var small = false

var snap = Vector2(20,20)

func _ready():			
	parent = get_parent()

	if has_node(resizeHandle):
		resizeHandle = get_node(resizeHandle)	
		resizeHandle.connect("gui_input", resize)	
		
		
	if has_node(moveHandle):
		moveHandle = get_node(moveHandle)	
		moveHandle.mouse_filter = MOUSE_FILTER_STOP
		moveHandle.connect("gui_input", click)		
		
				
	add_to_group("draggable")	
	
	parent.add_user_signal("startMoveResize")
	parent.add_user_signal("endMoveResize")	
	parent.add_user_signal("doRemove")
	
	parent.connect("resized", validate_size)
	parent.connect("doRemove", doRemove)	
	
	grow_parent_as_needed()	
	
	#Create a close button
	if canClose && !closeButton:
		closeButton = Button.new()			
		closeButton.text = "X"		
		closeButton.scale = Vector2(0.75, 0.65)	
		closeButton.visible = false		
		parent.add_child.call_deferred(closeButton)		
		closeButton.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
		closeButton.custom_minimum_size = Vector2(20,20)
		closeButton.connect("pressed", parent.emit_signal.bind("doRemove"))
		closeButton.z_index = 10
		#connect("pressed", self, "doRemove")
		#Show [X] (close button) only when the mouse is over the move handle
		moveHandle.connect("mouse_entered", showCloseButton)
		moveHandle.connect("mouse_exited", showCloseButton)

#called automatically via signals / groups
func doRemove():	
	parent.get_parent().remove_child.call_deferred(parent)	
	closeButton.visible = false
	
func showCloseButton():	
	if Rect2(moveHandle.global_position, moveHandle.size).has_point(get_global_mouse_position()):
		closeButton.visible = true		
	else:
		closeButton.visible = false

#called when you click on the move handle
func click(event:InputEvent):		
	if event as InputEventMouseButton:				
		if event.button_index == 1 and !event.is_pressed():
			if moving:
				get_tree().call_group("draggable", "endMove")				
		if event.button_index == 1 and event.is_pressed():						
			egs.selectionController.interrupt()		
			if !get_tree().get_nodes_in_group("selected").has(parent):
				if Input.is_key_pressed(KEY_SHIFT):
					get_tree().call_group("selectable", "doSelect")
				else:
					get_tree().call_group("selectable", "select_one", parent)
			get_tree().call_group("draggable", "startMove")			
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		
#called when you click on the resize handle
func resize(event):
	if !canResizeX && !canResizeY:		
		return	
	if event as InputEventMouseButton && event.button_index == 1:		
		#on Mouse Down...
		if event.is_pressed():			
			if !get_tree().get_nodes_in_group("selected").has(parent):
				if Input.is_key_pressed(KEY_SHIFT):
					get_tree().call_group("selectable", "doSelect")
				else:
					get_tree().call_group("selectable", "select_one", parent)
			get_tree().call_group("draggable", "startResizing")
			egs.selectionController.interrupt()	#interrupt the selection controller because we're actually resizing, not selecting
		#on Mouse Up...	
		else:
			get_tree().call_group("draggable", "endResizing")

#startResizing, endResizing, startMove, and endMove are all called via get_tree().call_group() from elsewhere
func startResizing():	
	if parent.is_in_group("selected"):
		parent.emit_signal("startMoveResize", parent.get_rect())		
		resizing = true
		
func endResizing():
	parent.emit_signal("endMoveResize")
	resizing = false


func startMove():
	if parent.is_in_group("selected"):
		if canMoveX || canMoveY:
			parent.emit_signal("startMoveResize", parent.get_rect())		
			moving = true							
			#g.undo.add({"Type": "Move", "Who": parent, "Rect": parent.get_rect()})
	
func endMove():
	moving = false
	parent.emit_signal("endMoveResize")

func _input(event):
	if event is InputEventMouseMotion:
		#hacky snapping
		event.relative *= 0.3
		if event.relative.x > 2:
			event.relative.x = min( ceil(event.relative.x / snap.x) *snap.x , 70)
		if event.relative.x < -2:
			event.relative.x = max( floor(event.relative.x / snap.x) *snap.x, -70)
			
		if event.relative.y > 1.2:
			event.relative.y = min(ceil(event.relative.y / snap.y) *snap.y , 30)
		elif event.relative.y < -1.2:
			event.relative.y = max(floor(event.relative.y / snap.y) *snap.y, -30)
		
		if event.relative.length_squared() < 2: 
			return		
		
		if resizing:		
			if canResizeX:
				parent.size.x = max(parent.size.x+event.relative.x, minWidth) 				
			if canResizeY:
				parent.size.y = max(parent.size.y+event.relative.y, minHeight) 
			grow_parent_as_needed()		
			validate_size()	
		elif moving:
			if canMoveX:
				parent.position.x += event.relative.x				
			if canMoveY:
				parent.position.y += event.relative.y
			grow_parent_as_needed()
			
	if Input.is_key_pressed(KEY_DELETE):
		if parent.is_in_group("selected"):			
			parent.emit_signal("doRemove")
			
# As we move/resize, adjust the parent so that we are always completely inside our parent 
# ie. push the parent's boundaries as needed
# p.s. parent = this component's parent, and par is technically the grandparent
func grow_parent_as_needed():
	#return  #TO DO check that this works for nested draggables
	if !parent.get_parent().has_node("Draggable"):			
		return
	var par:Control = parent.get_parent()
	var parRect = Rect2(par.global_position, par.size)
	var myRect = Rect2(parent.global_position, parent.size)
	if !parRect.encloses(myRect):
		var newRect = parRect.merge(myRect) #.grow(1)
				
		#if the parent is growing to the left or upward, adjust the childrens position accordingly
		var deltaX = par.global_position.x - newRect.position.x 		
		var deltaY = par.global_position.y - newRect.position.y		
		if deltaY > 0 or deltaX > 0:
			for c in par.get_children():			
				if c.has_node("Draggable"):											
					c.global_position.x += (deltaX ) 
					c.global_position.y += (deltaY )					
		par.global_position = newRect.position
		par.size = newRect.size	

# Hide the children if we're too small
func validate_size():
	#TO DO fix becoming small feature
	return	
	if parent.size.x < minWidth or parent.size.y < minHeight:
		becomeSmall()
	else:
		becomeBig()
		
func becomeSmall():
	if !small:
		for c in parent.get_children():
			if c as Control:
				c.visible = false
		moveHandle.visible = true
		small = true

func becomeBig():
	if small:
		for c in parent.get_children():
			if c as Control:
				c.visible = true		
		small = false
		
		
	
