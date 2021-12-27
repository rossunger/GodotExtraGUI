# GodotExtraGUI

# Video demo
https://www.youtube.com/watch?v=Lm_o7H0sF00

# Install
Add the ExtraGui folder to the res://addons folder of your godot project. 
Enable the ExtraGui plugin in your project settings OR just add "ExtraGuiSingleton" as "egs" to your autoloads. Restart editor for icons to update properly  

# USAGE
Draggable  makes the control resizable, and click to drag it around. 

Scrollable  makes the object a scroll container, meaning you can use mousewheel to scroll it's children up/down/left right , and ctrl + mousewheel to Zoom. the "F" key zooms and scrolls so that all the draggables are visible. It is recommended for the parent of the scrollable to be a blank panel

TabController  manages a set of tabs. Add some "TabButton"s and specify the name of the tabGroup name and the parent of the actual tabs (not the buttons), and it handles the rest. 

TabButton  is a button that works like a TabContainer. Choose which Control (aka tab) this button will show/hide. Optionally, can be "close-able".

ToggleVisibleButton is a button that shows/hides a control which you choose

Renameable  makes an object renameable. Specify the label to edit, and it will make a popup to handle the rest

Selectable   makes an object selectable

Select_Box_Controller  creates a select box when you click

SelectBox      automatically created, draw a select box as you drag the mouse, and adds all "selectables" to a group called "selected" when you release the mouse button

ChildAdder    lets you instance scenes on the parent using ctrl+click 

RemoteHide     set "WHO" to the control that you want to hide remotely. when this control's visibility is changed, it will hide/hide the WHO that you've selected.

Saveable        add this to any control who's data you want to save. override the "getDataToSave" function to change what data it sends to the saveController. Make sure the object to be saved is it's own packed scene (.tscn)

SaveController      A singleton for managing Saving and loading. Saves data to .JSON file. 

ExtraGuiSingleton       add this to your Autoloads. This stores a reference to all the singletons, and manages the Undo system

Undoable    add this as a sibling to any draggables which you would like to work with the undo system. Works with moving, resizing, renaming, creating/deleting, 


NOTE: Do note rename the nodes "Draggable, Scrollable, Renameable, Selectable, ChildAdder, Saveable, Undoable
