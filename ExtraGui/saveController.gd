extends Node
class_name SaveController, "save_icon.png"

var saveFilePath
var saveFile = File.new()
var dialog: FileDialog
var resultDialog: AcceptDialog
var autosaveFilePath = "res://autosave.json"
var autosaveFile = File.new()
var dialogCanvasLayer: CanvasLayer

func _ready():
	if !egs.saveController:
		egs.saveController = self
	else:
		queue_free()
	
	#Init the dialogs
	dialog = FileDialog.new()
	dialog.set_anchors_and_margins_preset(Control.PRESET_WIDE)
	dialogCanvasLayer = CanvasLayer.new()		
	dialogCanvasLayer.layer =100
	add_child(dialogCanvasLayer)
	dialogCanvasLayer.add_child(dialog)		
	
	dialog.popup_exclusive = true
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.filters.push_back("*.json")	
	
	resultDialog = AcceptDialog.new()	
	resultDialog.set_anchors_and_margins_preset(Control.PRESET_CENTER)
	dialogCanvasLayer.add_child(resultDialog)
	
		
func _input(event):	
	if !dialog.is_visible_in_tree():
		if event.is_action_pressed("SaveAs"):		
			doSaveAs()					
		elif event.is_action_pressed("Save"):
			doSave()		
		elif event.is_action_pressed("LoadFrom"):
			doLoadFrom()
		elif event.is_action_pressed("Load"):		
			doLoad()
		
	
func doLoadFrom():
	if resultDialog.is_connected("confirmed", self, "doLoadFrom"):
		resultDialog.disconnect("confirmed", self, "doLoadFrom")
		
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.popup()
	if !dialog.is_connected("file_selected", self, "doLoad"):
		dialog.connect("file_selected", self, "doLoad")
	
func doLoad(filepath:String = autosaveFilePath):
	if !filepath.ends_with(".json"):
		resultDialog.dialog_text = "Please select a .json save file"
		resultDialog.popup()
		if !resultDialog.is_connected("confirmed", self, "doLoadFrom"):
			resultDialog.connect("confirmed", self, "doLoadFrom")
		dialog.popup()
		if !dialog.is_connected("file_selected", self, "doLoad"):
			dialog.connect("file_selected", self, "doLoad")
	
	for c in get_tree().get_nodes_in_group("saveable"):
		c.parent.get_parent().remove_child(c.parent)
		c.parent.queue_free()
	
	saveFilePath = filepath
	saveFile.open(saveFilePath, File.READ)	
	var data = JSON.parse(saveFile.get_as_text()).result			
	var errors = false
	for d in data:
		if !is_instance_valid( get_node_or_null( d.path_to_parent )):			
			print("Error! trying to load a node who's parent doesn't exist yet")	
				
		var scene = load(d.scene)
		var child
		
		if scene is PackedScene:
			child = scene.instance()		
		else:
			child = Panel.new()
			errors = true
		var parent = get_node(d.path_to_parent)
		child.name = d.name
		parent.add_child(child)
		child.rect_position = str2var("Vector2" + d.rect_position)
		child.rect_size = str2var("Vector2" + d.rect_size)
	
	if errors:
		resultDialog.dialog_text = "Some objects didn't have scenes to load. they have been replaced with Panels"		
		resultDialog.popup()
	autosaveFile.close() 	 

func doSaveAs():
	if resultDialog.is_connected("confirmed", self, "doSaveAs"):
		resultDialog.disconnect("confirmed", self, "doSaveAs")
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.popup()
	if !dialog.is_connected("file_selected", self, "doSave"):
		dialog.connect("file_selected", self, "doSave")

static func SortByHeirarchy(a, b):
	var apath = a.get_path() as String
	var bpath = b.get_path() as String
	if apath.find(bpath) != -1:	 
		return false
	return false

func doSave(filepath:String = autosaveFilePath):
	if !filepath.ends_with(".json"):		
		if filepath.ends_with("/") or filepath.ends_with("\\"):		
			resultDialog.dialog_text = "Please choose a filename"
			resultDialog.popup()
			if dialog.is_connected("file_selected", self, "doSave"):
				dialog.disconnect("file_selected", self, "doSave")
			if !resultDialog.is_connected("confirmed", self, "doSaveAs"):
				resultDialog.connect("confirmed", self, "doSaveAs")			
			return
		filepath += ".json"
	saveFilePath = filepath		
	saveFile.open(saveFilePath, File.READ)	
	var saveData: Array
	var sortedSaveables = get_tree().get_nodes_in_group("saveable")
	sortedSaveables.sort_custom(self, "SortByHeirarchy")
	
	for s in sortedSaveables:
		saveData.push_back( s.getDataToSave() )			
		
	saveFile.open(saveFilePath, File.WRITE)
	saveFile.store_string(JSON.print(saveData))
	saveFile.close() 	 	
	if dialog.is_connected("file_selected", self, "doSave"):
		dialog.disconnect("file_selected", self, "doSave")	
	


