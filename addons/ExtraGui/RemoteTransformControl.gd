class_name RemoteTransformControl extends Node
@icon("move_icon.png")

@export_node_path(Control) var target
@export var x = true
@export var y = true
@export var w = false
@export var h = false
var who
@onready var parent = get_parent()

var originalX
var originalY
var originalW
var originalH

func _ready():
	originalX = parent.position.x
	originalY = parent.position.y
	originalW = parent.scale.x
	originalH = parent.scale.y
	who = get_node(target)

func _process(delta):
	parent.position.x = who.position.x + originalX
	parent.position.y = who.position.y + originalY
	parent.scale.x = who.scale.x + originalW
	parent.scale.y = who.scale.y + originalH
	
	
