extends Panel
class_name Minimap

#this class allows you to scroll a scrollable, and to see how zoomed in/out you are
# MUST be child of a scrollabe

var parent #the scrollable component
var grandparent # the panel that is scollable
var viewPanel
var ratio
var baseSize
var scrolling=false

func _ready():
	parent = get_parent()
	grandparent = parent.get_parent()
	if !parent is Scrollable:
		queue_free()
	viewPanel = ColorRect.new()
	add_child(viewPanel)
	call_deferred("setAspectRatio")
	viewPanel.color = Color(0,0,0.5,0.4)
	
	#rect_clip_content = true
	
	parent.connect("scroll", self, "scroll")
	parent.connect("zoom", self, "zoom")
	grandparent.connect("resized", self, "setAspectRatio")
	call_deferred("endMove") #

	add_to_group("draggable") #listen to draggable calls so that we can hook into them
	
	viewPanel.connect("gui_input", self, "gui_input")
	
func scroll(delta:Vector2):	
	viewPanel.rect_position.x = clamp(viewPanel.rect_position.x - (delta.x * ratio * float(parent.canScrollX)), -1, rect_size.x-viewPanel.rect_size.x)
	viewPanel.rect_position.y = clamp(viewPanel.rect_position.y - (delta.y * ratio * float(parent.canScrollY)), -1, rect_size.y-viewPanel.rect_size.y)
	update()
	
func zoom(delta):	
	var newsize = baseSize
	if parent.canZoomX:		
		newsize.x /= parent.w
		#viewPanel.rect_size.x /= delta 	/2
		#viewPanel.rect_position.x *= delta * ratio
	if parent.canZoomY:
		newsize.y /= parent.h
		#viewPanel.rect_size.y /= delta /2
		#viewPanel.rect_position.y *= delta * ratio
	#viewPanel.rect_position *= 0
	viewPanel.rect_size = newsize
	update()
	

func endMove():
	setAspectRatio()
	ratio = viewPanel.rect_size.x / grandparent.rect_size.x
	update()
	
func gui_input(event):
	if event as InputEventMouseButton:
		if event.button_index == 1:			
			if event.is_pressed():
				egs.selectionController.call_deferred("interrupt")
				scrolling = true
			else:
				scrolling = false
	if event is InputEventMouseMotion && scrolling:
		if canScroll(-event.relative/ratio):
			parent.doScroll(-event.relative/ratio)

func setAspectRatio():	
	var smallerDimension = min(rect_size.x, rect_size.y)	
	baseSize = Vector2(1,1) * smallerDimension * grandparent.rect_size.normalized()

func _draw():
	if !ratio:
		return
	for child in grandparent.get_children():
		if child.has_node("Draggable"):			
			draw_rect(Rect2(child.rect_position * ratio, child.rect_size * ratio) , Color.brown)
	draw_rect(Rect2(parent.getBounds().position * ratio, parent.getBounds().size * ratio), Color.bisque)
	
func canScroll(delta):
	var valueX = viewPanel.rect_position.x - (delta.x * ratio * float(parent.canScrollX))
	var valueY = viewPanel.rect_position.y - (delta.y * ratio * float(parent.canScrollY))
	if valueX < -1 or valueY < 1 or valueX > rect_size.x-viewPanel.rect_size.x or valueY > rect_size.y-viewPanel.rect_size.y:
		return false
	else:
		return true
	pass
