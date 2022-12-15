extends LineEdit
class_name SearchBox

var searchResults
var allItems

func _ready():
	connect("text_changed", search)

func search():
	var searchResult
	for i in allItems:
		if i is String:
			if i.find(text) != -1:
				searchResult.push_back(i)
		else:
			if i.name.find(text) != -1:
				searchResult.push_back(i)
		

