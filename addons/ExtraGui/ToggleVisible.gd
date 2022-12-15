
class_name ToggleVisible extends Button
@icon("eye_icon.png")
@export_node_path(Node) var who

func _ready():
	who = get_node(who)
	connect("pressed", _on_toggleMenu_pressed)

func _on_toggleMenu_pressed():
	who.set_process( !who.is_processing() ) 
	who.visible = !who.visible
