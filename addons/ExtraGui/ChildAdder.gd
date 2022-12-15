class_name ChildAdder extends Control
@icon("add_icon.png")

@export_file("*.tscn") var who
		
var parent

func _ready():	
	who = load(who)	
	parent = get_parent()
	parent.connect("gui_input", gui_input)
	parent.add_user_signal("created")
	parent.add_user_signal("removing")
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	size = Vector2(0,0)
	
func gui_input(event):		
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed && Input.is_key_pressed(KEY_CTRL):
		var child = who.instantiate()
		child.position = event.position	
		parent.add_child(child)
		parent.emit_signal("created", child)		
