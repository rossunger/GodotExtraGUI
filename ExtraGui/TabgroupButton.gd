extends Button
class_name tabgroup_button, "tab_icon.png"

export var tabgroup = "" #the name you choose for this tabgroup
export (NodePath) var tab  #the control that you will be showing when this button is clicked
var tab_parent
export var selected = false 

func _ready():	
	tab = get_node(tab)		
	add_to_group(tabgroup)		
	connect("pressed", self, "_on_Button_pressed")
	tab_parent = tab.get_parent()	
	#Init the tabggroup... hide the unselected ones
	if selected:
		changeTab(tab.name, self)
	else:
		changeTab("", self)

func _on_Button_pressed():
	get_tree().call_group(tabgroup, "changeTab", tab.name, self)
	
func changeTab(tabname, tabbutton):
	if tab.name == tabname:
		if !tab.get_parent() == tab_parent:
			tab_parent.call_deferred("add_child", tab)
		tab.visible = true 
		#tab.set_process(true) 
		modulate.a = 1		
		selected = true
	else:
		if tab.get_parent():
			tab_parent = tab.get_parent()
			tab_parent.call_deferred("remove_child", tab)
		#tab.visible = false
		#tab.set_process(false) 
		modulate.a = 0.35			
		selected = false
