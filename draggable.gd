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

export var minWidth = 160
export var minHeight = 50

onready var parent = get_parent()

export (NodePath) var resizeHandle
export (NodePath) var moveHandle

func _ready():			
	resizeHandle = get_node(resizeHandle)	
	if resizeHandle:
		resizeHandle.connect("gui_input", self, "resize")
	moveHandle = get_node(moveHandle)	
	moveHandle.connect("gui_input", self, "click")

func click(event):
	if event.is_action_released("cam_drag"):		
		moving = false
	if event.is_action_pressed("cam_drag"):		
		if canMoveX || canMoveY:
			moving = true	
			g.undo.add({"Type": "Move", "Who": parent, "Rect": parent.get_rect()})
		return
	
		if canBeDragged:
			parent.mouse_filter = Control.MOUSE_FILTER_IGNORE		
			for c in parent.get_children():
				if c.name == "dropTarget":
					continue			
				if c as Control:
					c.mouse_filter = Control.MOUSE_FILTER_IGNORE					
			g.dragTarget = parent	
			g.emit_signal("dragBegin", parent)
		
func resize(event):
	if !canResizeX && !canResizeY:		
		return
	if event.is_action_pressed("cam_drag"):					
		resizing = true		
		g.undo.add({"Type": "Resize", "Who": parent, "Rect": parent.get_rect()})
	if event.is_action_released("cam_drag"):
		resizing = false			
		
func _input(event):
	if event is InputEventMouseMotion:
		if resizing:		
			if canResizeX:
				parent.rect_size.x = max(parent.rect_size.x+event.relative.x, minWidth) 
			if canResizeY:
				parent.rect_size.y = max(parent.rect_size.y+event.relative.y, minHeight) 
		elif moving:
			if canMoveX:
				parent.rect_position.x += event.relative.x				
			if canMoveY:
				parent.rect_position.y += event.relative.y
					
