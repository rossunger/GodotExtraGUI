extends Node
class_name Saveable, "save_icon.png"

#this control makes it's parent's data saveable. Override the getDataToSave function to save other data... you'll have to modify save controller too to tell it what to do with this data

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


