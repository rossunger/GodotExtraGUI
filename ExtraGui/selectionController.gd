extends Node
class_name selection_controller, "select_icon.png"

signal resizing
signal moving

var parent
var selectBox
export var color = Color.cornflower
var interrupted = false
onready var timer = Timer.new()
var startPosition

func _ready():
	parent = get_parent()
	add_to_group("draggable")
	add_child(timer)
	timer.connect("timeout", self, "startSelection")	
	#register ourselves as the only selection controller singleton in the EGS (extra gui singleton)
	if !egs.selectionController:
		egs.selectionController = self
	else:
		queue_free()

func startResizing():
	pass

func endResizing():
	pass
		

func _input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		timer.start(0.01)			
		startPosition = event.position
	
	if event is InputEventMouseButton && event.button_index == 1 && !event.pressed:
		interrupted = false
		
func startSelection():
	timer.stop()
	selectBox = select_box.new()
	selectBox.color = color
	selectBox.start = startPosition
	selectBox.end = startPosition
	add_child(selectBox)		
	
func interrupt():
	if !timer.is_stopped():
		timer.stop()
	elif !interrupted:
		selectBox.get_parent().remove_child(selectBox)
		selectBox.queue_free()
		interrupted = true
		
		
		
		
		
		
		
		
		
