extends Control
class_name remote_hide, "eye_icon.png"

export (NodePath) var who
func _ready():
	who = get_node(who)
	connect("tree_exiting", self, "doHide")
	connect("tree_entered", self, "doShow")

func doHide():
	who.visible = false
	
func doShow():
	who.visible = true
