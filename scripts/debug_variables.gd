extends PanelContainer


func update(name: String, value: Variant) -> void:
	
	var label = $Container.find_child(name, false, false)
	
	if label == null:
		label = Label.new()
		label.name = name
		$Container.add_child(label)
	
	label.text = name + ": " + str(value)
