extends Node
class_name saveable, "save_icon.png"

var parent
func _ready():
	parent = get_parent()
	add_to_group("saveable")
	
func getDataToSave() -> Dictionary:
	var r: Dictionary = {}
	r.name = parent.name
	r.rect_position = parent.rect_position
	r.rect_size = parent.rect_size
	r.path_to_parent = parent.get_parent().get_path()
	r.scene = parent.filename
	return r


