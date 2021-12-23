extends Button
class_name tabgroup_button, "tab_icon.png"
export var tabgroup = "" #the name you choose for this tabgroup
export (NodePath) var tab  #the control that you will be showing when this button is clicked
export var selected = false 

func _ready():	
	tab = get_node(tab)	
	add_to_group(tabgroup)	
	
	#Init the tabggroup... hide the unselected ones
	if selected:
		tab.visible = true
		tab.set_process(true) 
		modulate.a = 1		
		selected = true
	else:
		tab.visible = false
		tab.set_process(false) 
		modulate.a = 0.35			
		selected = false

func _on_Button_pressed():
	get_tree().call_group(tabgroup, "changeTab", tab.name, self)
	
func changeTab(tabname, tabbutton):
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
