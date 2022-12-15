
class_name Renameable extends Node
@icon("edit_icon.png")

#this component allows you to rename it's parent (and change a corresponding label's text). 
#on right-click, it creates a popup asking for text input

@export_node_path(Label) var who #the label whose text will be changed
var popupScene = preload("renamePopup.tscn")
var popup

var parent #the control to be renamed
var lineEdit = LineEdit.new()

func _ready():
	parent = get_parent()
	who = get_node(who)
	who.connect("gui_input", gui_input) #adding code for the Label's Gui_event
	who.text = parent.name
	parent.add_user_signal("doneRenaming")

# called from Draggable via by get_tree().call_group()
func start_renaming():	
	parent.remove_child(who)
	parent.add_child(lineEdit)
	lineEdit.connect("text_submitted", done_renaming)
	lineEdit.connect("focus_exited", done_renaming)
	lineEdit.grab_focus()
	lineEdit.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	lineEdit.custom_minimum_size.y = 20
#	
#	popup = popupScene.instantiate()
#	add_child(popup)
#	popup.popup()
#	var lineEdit = popup.get_node("NewName")	
#	if not lineEdit.is_connected("text_submitted", done_renaming):
#		lineEdit.connect("text_submitted", done_renaming)
#	if not lineEdit.is_connected("focus_exited", done_renaming_focus_lost):
#		lineEdit.connect("focus_exited", done_renaming_focus_lost.bind(lineEdit))
#	lineEdit.text = who.text
#	lineEdit.grab_focus()	

func done_renaming(newName):
	if parent.name != newName:	
		# You can add a "validate_name" function to the parent if you wish to make sure 
		# the name doesn't exist yet, or use some special criterea for validation
		if !parent.has_method("validate_name") || parent.validate_name(newName):
			parent.emit_signal("doneRenaming", who, parent.name)
			parent.name = newName	
			who.text = newName
			parent.add_child(who)
			lineEdit.disconnect("text_changed", done_renaming)
			lineEdit.disconnect("focus_exited", done_renaming)
			parent.remove_child(lineEdit)
		else:			
			return

func done_renaming_focus_lost(lineEdit):
	done_renaming(lineEdit.text)	

func gui_input(event):
	#on right-click. Change this if you want a different action to trigger renaming
	if event is InputEventMouseButton && event.button_index == 2:
		start_renaming()
