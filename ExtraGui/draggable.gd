extends Control
class_name draggable, "move_icon.png"

var resizing = false
var moving = false
var renaming = false

export var canResizeX = true
export var canResizeY = true
export var canMoveX = true
export var canMoveY = true
export var canReceiveDrop = true
export var canBeDragged = true
export var canClose = true

export var minWidth = 160
export var minHeight = 50

export (NodePath) var resizeHandle
export (NodePath) var moveHandle

onready var parent = get_parent()

func _ready():			
	resizeHandle = get_node(resizeHandle)	
	if resizeHandle:
		resizeHandle.connect("gui_input", self, "resize")		
	moveHandle = get_node(moveHandle)	
	moveHandle.mouse_filter = MOUSE_FILTER_STOP
	moveHandle.connect("gui_input", self, "click")	
	
	add_to_group("draggable")
	parent.add_user_signal("startMoveResize")
	parent.add_user_signal("endMoveResize")	
	parent.add_user_signal("doRemove")
	parent.connect("doRemove", self, "doRemove")	
	grow_parent_as_needed()	
	
	if canClose:
		var c = Button.new()
		c.set_anchors_and_margins_preset(Control.PRESET_TOP_RIGHT)
		c.text = "x"
		parent.call_deferred("add_child", c)		
		c.call_deferred("connect", "pressed", parent, "emit_signal", ["doRemove"])
		#connect("pressed", self, "doRemove")

func doRemove():	
	parent.get_parent().call_deferred("remove_child", parent)	
	
	

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
		
func resize(event):
	if !canResizeX && !canResizeY:		
		return	
	if event as InputEventMouseButton:		
		if event.button_index == 1 and event.is_pressed():			
			if !get_tree().get_nodes_in_group("selected").has(parent):
				if Input.is_key_pressed(KEY_SHIFT):
					get_tree().call_group("selectable", "doSelect")
				else:
					get_tree().call_group("selectable", "select_one", parent)
			get_tree().call_group("draggable", "startResizing")
			egs.selectionController.interrupt()						
			#g.undo.add({"Type": "Resize", "Who": parent, "Rect": parent.get_rect()})
	if event as InputEventMouseButton:		
		if event.button_index == 1 and !event.is_pressed():			
			get_tree().call_group("draggable", "endResizing")

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
		if resizing:		
			if canResizeX:
				parent.rect_size.x = max(parent.rect_size.x+event.relative.x, minWidth) 
				
			if canResizeY:
				parent.rect_size.y = max(parent.rect_size.y+event.relative.y, minHeight) 
			grow_parent_as_needed()			
		elif moving:
			if canMoveX:
				parent.rect_position.x += event.relative.x				
			if canMoveY:
				parent.rect_position.y += event.relative.y
			grow_parent_as_needed()
			
	if Input.is_key_pressed(KEY_DELETE):
		if parent.is_in_group("selected"):			
			parent.emit_signal("doRemove")
			
			
func grow_parent_as_needed():
	if !parent.get_parent().has_node("draggable"):			
		return
	var par:Control = parent.get_parent()
	var parRect = Rect2(par.rect_global_position, par.rect_size)
	var myRect = Rect2(parent.rect_global_position, parent.rect_size)
	if !parRect.encloses(myRect):
		var newRect = parRect.merge(myRect) #.grow(1)
				
		#if the parent is growing to the left or upward, adjust the childrens position accordingly
		var deltaX = par.rect_global_position.x - newRect.position.x 		
		var deltaY = par.rect_global_position.y - newRect.position.y		
		if deltaY > 0 or deltaX > 0:
			for c in par.get_children():			
				if c.has_node("draggable"):											
					c.rect_global_position.x += (deltaX ) 
					c.rect_global_position.y += (deltaY )					
		par.rect_global_position = newRect.position
		par.rect_size = newRect.size	
		
		
		
		
		
	
