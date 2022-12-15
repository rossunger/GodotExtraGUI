extends Node

# This is a singleton that manages the Input map and overseas the Undo system

var selectionController
var saveController

var undoTimes: Array
var redoTimes: Array

enum test_enum { 
	Enum_Option_A, Enum_Option_B
}

func _ready():
	if !InputMap.has_action("Play"):
		InputMap.add_action("Play")
		var event = InputEventKey.new()				
		event.keycode = OS.find_keycode_from_string("space")
		InputMap.action_add_event("Play", event )
	
	if !InputMap.has_action("Undo"):
		InputMap.add_action("Undo")
		var event = InputEventKey.new()
		event.ctrl_pressed = true				
		event.keycode = OS.find_keycode_from_string("z")
		InputMap.action_add_event("Undo", event )
	
		
	if !InputMap.has_action("Redo"):
		InputMap.add_action("Redo")
		var event = InputEventKey.new()
		event.ctrl_pressed = true
		event.shift_pressed = true
		event.keycode = OS.find_keycode_from_string("z")
		InputMap.action_add_event("Redo", event )
		
	if !InputMap.has_action("Save"):
		InputMap.add_action("Save")
		var event = InputEventKey.new()
		event.ctrl_pressed = true		
		event.keycode = OS.find_keycode_from_string("s")
		InputMap.action_add_event("Save", event )
		
	
	if !InputMap.has_action("SaveAs"):
		InputMap.add_action("SaveAs")
		var event = InputEventKey.new()
		event.ctrl_pressed = true
		event.shift_pressed = true
		event.keycode = OS.find_keycode_from_string("s")
		InputMap.action_add_event("SaveAs", event )
		
	
	if !InputMap.has_action("Load"):
		InputMap.add_action("Load")
		var event = InputEventKey.new()
		event.ctrl_pressed = true		
		event.keycode = OS.find_keycode_from_string("o")
		InputMap.action_add_event("Load", event )
		
	
	if !InputMap.has_action("LoadFrom"):
		InputMap.add_action("LoadFrom")
		var event = InputEventKey.new()
		event.ctrl_pressed = true
		event.shift_pressed = true
		event.keycode = OS.find_keycode_from_string("o")
		InputMap.action_add_event("LoadFrom", event )
		
	if !InputMap.has_action("Fullscreen"):
		InputMap.add_action("Fullscreen")
		var event = InputEventKey.new()
		event.alt_pressed = true
		event.keycode = OS.find_keycode_from_string("enter")
		InputMap.action_add_event("Fullscreen", event )

func _input(event):	
	if event.is_action_pressed("Redo"):
		if redoTimes.size() > 0:
			var r = redoTimes.pop_back()						
			get_tree().call_group("undoable", "doRedo", r)
			undoTimes.push_back(r)

	elif event.is_action_pressed("Undo"):		
		if undoTimes.size() > 0 :			
			var u = undoTimes.pop_back()						
			get_tree().call_group("undoable", "doUndo", u)
			redoTimes.push_back(u)
	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)		
	if not Input.is_mouse_button_pressed(1) && not Input.is_mouse_button_pressed(2):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func addUndo(time):		
	if undoTimes == [] or abs(undoTimes.back() - time) > 1:
		redoTimes.clear()
		undoTimes.push_back(time)
		
#Merge dictionary, B overwrtes A if same
func merge(a:Dictionary, b:Dictionary) -> Dictionary:
	var result = a.duplicate(true)
	for k in b.keys():
		result[k] = b[k]
	return result
	
	
