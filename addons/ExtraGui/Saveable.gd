
class_name Saveable extends Node
@icon("save_icon.png")

#this control makes it's parent's data saveable. 
#To save more data, add a child node that has 
# getDataToSave and processLoadData functions


var parent
func _ready():
	parent = get_parent()
	add_to_group("saveable")

func processLoadData(data:Dictionary):
	for c in get_children():
		if c.has_method("processLoadData"):
			c.processLoadData(data)
	
func getDataToSave() -> Dictionary:
	var r: Dictionary = {}
	r.name = parent.name
	r.position = parent.position
	r.size = parent.size
	r.path_to_parent = parent.get_parent().get_path()
	r.scene = parent.filename
	for c in get_children():
		if c.has_method("getDataToSave"):
			egs.merge(r, c.getDataToSave())
	return r


