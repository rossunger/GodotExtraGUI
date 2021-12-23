extends Node2D
export (NodePath) var roomRoot
export (NodePath) var characterRoot
export (NodePath) var eventRoot
export (NodePath) var periodRoot

var autosaveTimer

func _ready():
	g.roomRoot = get_node(roomRoot)	
	g.characterRoot = get_node(characterRoot)	
	g.eventRoot = get_node(eventRoot)	
	g.periodRoot = get_node(periodRoot)	
	
	autosaveTimer = Timer.new()
	add_child(autosaveTimer)	
	autosaveTimer.wait_time = 120
	autosaveTimer.start()
	autosaveTimer.connect("timeout", g, "doAutosave")	
	autosaveTimer.connect("timeout", self, "autosaveTimerStart")
	
	g.loadFromFile(g.autosaveFilePath)	


func _input(event):
	if event.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("Redo"):
		g.undo.doRedo()
	elif event.is_action_pressed("Undo"):
		g.undo.doUndo()	
	
	if event.is_action_pressed("ui_1") :
		g.roomRoot.visible = true		
		g.characterRoot.visible = false
	elif event.is_action_pressed("ui_2"):
		g.roomRoot.visible = false
		g.characterRoot.visible = true		
	
	if event.is_action_released("cam_drag"):
		if !g.dragTarget:
			return
		g.dragTarget.moving = false
		g.dragTarget.mouse_filter = Control.MOUSE_FILTER_STOP		
		
		for c in g.dragTarget.get_children():
			if c as Control:
				c.mouse_filter = Control.MOUSE_FILTER_STOP		
	
		g.emit_signal("roomDragEnd", g.dragTarget)
		g.dragTarget = null
		

func autosaveTimerStart(): 
	autosaveTimer.start()

func _on_Load_pressed():
	g.loadFromFile(g.autosaveFilePath)

func _on_Save_pressed():
	g.doAutosave()
