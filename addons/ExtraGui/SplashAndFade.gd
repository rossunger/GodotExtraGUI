extends Control
class_name SplashAndFade
@export var duration = 2
var tween

func _ready():
	tween = Tween.new()
	tween.interpolate_property(self, "modulate", Color(1,1,1,2), Color(1,1,1,0), duration, Tween.TRANS_QUAD)	
	tween.start()
	position = get_viewport().get_visible_rect().size / 2 + Vector2(offset_left, offset_top)
	tween.connect("tween_all_completed", self, "endSplash")

func endSplash():
	get_parent().remove_child(self)
	queue_free()
