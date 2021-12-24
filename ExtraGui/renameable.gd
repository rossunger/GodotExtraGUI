extends Node
class_name renameable, "edit_icon.png"

export (NodePath) var who
var popupScene = preload("renamePopup.tscn")
var popup
func _ready():
	who = get_node(who)
	who.connect("gui_input", self, "gui_input")

func start_renaming():
	popup = popupScene.instance()
	add_child(popup)
	popup.popup()
	var lineEdit = popup.get_node("NewName")
	lineEdit.connect("text_entered", self, "done_renaming")
	lineEdit.connect("focus_exited", self, "done_renaming_focus_lost", [lineEdit])
	lineEdit.text = who.text
	lineEdit.grab_focus()

func done_renaming(newName):
	who.name = newName
	who.text = newName
	remove_child(popup)
	popup.queue_free()

func done_renaming_focus_lost(lineEdit):
	done_renaming(lineEdit.text)

func gui_input(event):
	if event is InputEventMouseButton && event.button_index == 2:
		start_renaming()
