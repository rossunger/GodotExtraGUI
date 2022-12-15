
class_name RemoteHide extends Control
@icon("eye_icon.png")

@export_node_path(Node) var who
func _ready():
	who = get_node(who)
	connect("visibility_changed", visibilityChanged)
	#connect("tree_entered", doShow)

func visibilityChanged():
	if who:
		who.visible = is_visible_in_tree()
