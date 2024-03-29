class_name SaveController extends Node
@icon("save_icon.png")
# SaveController is a singleton that handles saving and loading

var saveFilePath
var saveFile
var dialog: FileDialog
var resultDialog: AcceptDialog
var autosaveFilePath = "res://autosave.json"
var autosaveFile
var dialogCanvasLayer: CanvasLayer

func _ready():
	#register this singleton in the ExtraGui singleton
	if !egs.saveController:
		egs.saveController = self
	else:
		queue_free()
	
	#Init the dialogs. Put them on a canavs layer so they float about all the other GUI
	#resultDialog is an alert expresses how the save/open went, and if there are any error. 
	dialog = FileDialog.new()
	
	dialogCanvasLayer = CanvasLayer.new()		
	dialogCanvasLayer.layer =100
	add_child(dialogCanvasLayer)	
	dialogCanvasLayer.add_child(dialog)		
	#dialog.set_anchors_and_offsets_preset(Container.PRESET_FULL_RECT)
	#dialog.size -=  Vector2i(15,30)
	
	#dialog.popup_exclusive = true
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.filters.push_back("*.json")	
	
	resultDialog = AcceptDialog.new()	
	#resultDialog.set_anchors_and_offset_preset(Container.PRESET_CENTER)
	dialogCanvasLayer.add_child(resultDialog)
	
		
func _input(event):	
	if !dialog.is_inside_tree():
		if event.is_action_pressed("SaveAs"):		
			doSaveAs()					
		elif event.is_action_pressed("Save"):
			doSave()		
		elif event.is_action_pressed("LoadFrom"):
			doLoadFrom()
		elif event.is_action_pressed("Load"):		
			doLoad()
		
	
func doLoadFrom():
	if resultDialog.is_connected("confirmed", doLoadFrom):
		resultDialog.disconnect("confirmed", doLoadFrom)
	
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.invalidate() #refresh the file system
	dialog.popup()
	if !dialog.is_connected("file_selected", doLoad):
		dialog.connect("file_selected", doLoad)
	
func doLoad(filepath:String = autosaveFilePath):	
	if !filepath.ends_with(".json"):
		resultDialog.dialog_text = "Please select a .json save file"
		resultDialog.popup()
		if !resultDialog.is_connected("confirmed", doLoadFrom):
			resultDialog.connect("confirmed", doLoadFrom)
		dialog.popup()
		if !dialog.is_connected("file_selected", doLoad):
			dialog.connect("file_selected", doLoad)
	
	for c in get_tree().get_nodes_in_group("saveable"):
		c.parent.get_parent().remove_child(c.parent)
		c.parent.queue_free()
	
	saveFilePath = filepath
	saveFile = FileAccess.open(saveFilePath, FileAccess.READ)		
	var data = JSON.parse_string(saveFile.get_as_text()).result			
	var errors = false
	for d in data:
		if !is_instance_valid( get_node_or_null( d.path_to_parent )):			
			#This should never happen, because we sort the nodes by heirarchy first
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
		child.position = str_to_var("Vector2" + d.position)
		child.size = str_to_var("Vector2" + d.size)
	
		#If you have other data to load, this is where you should do that		
		var saveable = child.get_node("Saveable")
		if saveable.has_method("processLoadData"):
			saveable.processLoadData(d)

	if errors:
		resultDialog.dialog_text = "Some objects didn't have scenes to load. they have been replaced with Panels"		
		resultDialog.popup()
	autosaveFile.close() 	 
	
	if dialog.is_connected("file_selected", doLoad):
		dialog.disconnect("file_selected", doLoad)	

func doSaveAs():
	if resultDialog.is_connected("confirmed", doSaveAs):
		resultDialog.disconnect("confirmed", doSaveAs)
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.invalidate()
	dialog.popup()
	if !dialog.is_connected("file_selected", doSave):
		dialog.connect("file_selected", doSave)

static func SortByHeirarchy(a, b):
	var apath = a.get_path() as String
	var bpath = b.get_path() as String
	if apath.find(bpath) != -1:	 
		return false
	return true

func doSave(filepath:String = autosaveFilePath):
	if !filepath.ends_with(".json"):		
		if filepath.ends_with("/") or filepath.ends_with("\\"):		
			resultDialog.dialog_text = "Please choose a filename"
			resultDialog.popup()
			if dialog.is_connected("file_selected", doSave):
				dialog.disconnect("file_selected", doSave)
			if !resultDialog.is_connected("confirmed", doSaveAs):
				resultDialog.connect("confirmed", doSaveAs)			
			return
		filepath += ".json"
	saveFilePath = filepath		
	
	var saveData: Array
	var sortedSaveables = get_tree().get_nodes_in_group("saveable")
	sortedSaveables.sort_custom(SortByHeirarchy)
	
	for s in sortedSaveables:
		saveData.push_back( s.getDataToSave() )			
		
	saveFile = FileAccess.open(saveFilePath, FileAccess.WRITE)
	saveFile.store_string(JSON.stringify(saveData))
	saveFile.close() 	 	
	if dialog.is_connected("file_selected",doSave):
		dialog.disconnect("file_selected", doSave)	
	


