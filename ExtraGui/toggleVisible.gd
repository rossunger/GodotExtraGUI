extends Button
class_name toggle_visible_button, "res://ExtraGui/eye_icon.png"
export (NodePath) var who

func _ready():
	who = get_node(who)
	connect("pressed", self, "_on_toggleMenu_pressed")

func _on_toggleMenu_pressed():
	who.set_process( !who.is_processing() ) 
	who.visible = !who.visible
