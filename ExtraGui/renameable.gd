extends Node
class_name renameable, "edit_icon.png"

export (NodePath) var who
var popupScene = preload("renamePopup.tscn")
var popup

var parent

func _ready():
	parent = get_parent()
	who = get_node(who)
	who.connect("gui_input", self, "gui_input")
	who.text = parent.name
	parent.add_user_signal("doneRenaming")

func start_renaming():	
	popup = popupScene.instance()
	add_child(popup)
	popup.popup()
	var lineEdit = popup.get_node("NewName")
	lineEdit.connect("text_entered", self, "done_renaming")
	lineEdit.connect("focus_exited", self, "done_renaming_focus_lost", [lineEdit])
	lineEdit.text = who.text
	lineEdit.grab_focus()
	popup.get_node("TextEdit").connect("focus_entered", lineEdit, "grab_focus")

func done_renaming(newName):
	if parent.name != newName:	
		if !parent.has_method("validate_name") || parent.validate_name(newName):
			parent.emit_signal("doneRenaming", who, parent.name)
			parent.name = newName	
			who.text = newName
		else:
			popup.get_node("error").visible = true
			return
	if is_instance_valid(popup):
		popup.queue_free()

func done_renaming_focus_lost(lineEdit):
	done_renaming(lineEdit.text)
	#if is_instance_valid(popup):
	#	popup.get_node("NewName").grab_click_focus()

func gui_input(event):
	if event is InputEventMouseButton && event.button_index == 2:
		start_renaming()
