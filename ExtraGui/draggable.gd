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

signal undoStateChanged

export (NodePath) var resizeHandle
export (NodePath) var moveHandle

func _ready():			
	resizeHandle = get_node(resizeHandle)	
	if resizeHandle:
		resizeHandle.connect("gui_input", self, "resize")
	moveHandle = get_node(moveHandle)	
	moveHandle.connect("gui_input", self, "click")

func click(event:InputEvent):
	if event as InputEventMouseButton:				
		if event.button_index == 1 and !event.is_pressed():
			moving = false
		if event.button_index == 1 and event.is_pressed():
			if canMoveX || canMoveY:
				moving = true					
				#g.undo.add({"Type": "Move", "Who": parent, "Rect": parent.get_rect()})
			return		
		
func resize(event):
	if !canResizeX && !canResizeY:		
		return	
	if event as InputEventMouseButton:		
		if event.button_index == 1 and event.is_pressed():
			resizing = true	
			#g.undo.add({"Type": "Resize", "Who": parent, "Rect": parent.get_rect()})
	if event as InputEventMouseButton:		
		if event.button_index == 1 and !event.is_pressed():
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
