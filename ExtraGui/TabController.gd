extends Control
class_name TabController, "tab_icon.png"

var parent 
var tabs: Dictionary = {}
var currentTab
export var tabGroup = "tabgroup1"
export (NodePath) var tabParent

func _ready():
	parent = get_parent()		
	tabParent = get_node(tabParent)	
	var c = parent.get_children()	
	for tabButton in c:				
		if tabButton is TabgroupButton:
			tabs[tabButton.name] = tabButton.tab
			tabButton.tabGroup = "tabgroup_" + tabGroup
			tabButton.add_to_group(tabButton.tabGroup)
			tabButton.tabController = self
			
	add_to_group("tab_controllers")

func openTab(tabGroupName, sceneToOpen = null, tabName = tabs.values()[0].name ):	
	if tabGroup != tabGroupName:
		return
		
	#If the tab doesn't exist yet, create it
	if !tabs.keys().has(tabName):		
		if sceneToOpen == null:
			print("ERROR: trying to open a tab, but scene to open is NULL" )
		var tab = sceneToOpen.instance()
		tab.name = tabName
		tabParent.add_child(tab)
		
		var tabButton = TabgroupButton.new()
		tabButton.name = tabName
		tabButton.text = tabName
		tabButton.tab = tab.get_path()
		tabButton.tabGroup = "tabgroup_" + tabGroupName
		tabButton.tabController = self
		tabButton.add_to_group("tabgroup_" + tabGroup)		
		parent.add_child(tabButton)			
						
		
		tabs[tabName] = tab
		
	get_tree().call_group("tabgroup_" + tabGroup, "changeTab", tabs[tabName].name)	
	
func closeTab(tabButton):
	tabButton.closeTab()
	tabs.erase(tabButton.tab.name)
	get_tree().call_group("tabgroup_" + tabGroup, "changeTab", tabs.values()[0].name)
