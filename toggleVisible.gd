extends Button
class_name toggle_visible_button, "eye_icon.png"
export (NodePath) var who

func _ready():
	who = get_node(who)

func _on_toggleMenu_pressed():
	who.set_process( !who.is_processing() ) 
	who.visible = !who.visible
