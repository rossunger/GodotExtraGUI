extends Button
class_name tabgroup_button, "tab_icon.png"

var tabGroup
var tabController
export (NodePath) var tab  #the control that you will be showing when this button is clicked
var tab_parent
export var closeable = true
export var selected = false 
var closeButton
	
func _ready():	
	tab = get_node(tab)			
	connect("pressed", self, "_on_Button_pressed")
	tab_parent = tab.get_parent()	
	
	#Init the tabggroup... hide the unselected ones
	if selected:
		changeTab(tab.name)
	else:
		changeTab("")

	if closeable:
		closeButton = Button.new()
		add_child(closeButton)
		closeButton.anchor_right =1
		closeButton.anchor_left =1		
		closeButton.margin_left = - 20	
		closeButton.margin_right =0
		closeButton.text = "x"
		closeButton.visible = false		
		connect("mouse_entered", self, "showCloseButton", [true])
		closeButton.connect("mouse_entered", self, "showCloseButton", [true])
		connect("mouse_exited", self, "showCloseButton", [false])
		closeButton.connect("mouse_exited", self, "showCloseButton", [false])
		closeButton.connect("pressed", tabController, "closeTab", [self])
		

func closeTab():
	tab.queue_free()	
	queue_free()	
	
func showCloseButton(show):
	closeButton.visible = show

func _on_Button_pressed():
	get_tree().call_group(tabGroup, "changeTab", tab.name)
	
func changeTab(tabname):
	if tab.name == tabname:
		tab.visible = true 		
		tab.set_process(true)
		modulate.a = 1		
		selected = true
	else:
		tab.visible = false		
		tab.set_process(false)		
		modulate.a = 0.35			
		selected = false


