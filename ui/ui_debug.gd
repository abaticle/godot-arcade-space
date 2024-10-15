extends Control

@onready var container: VBoxContainer = $"Panel/MarginContainer/Container"

var setting_slider = preload("res://ui/components/setting_slider.tscn")


var settings = [
	"GRAVITY_CONSTANT"
]

var ranges = {
	"GRAVITY_CONSTANT": [1, 15, 1, GlobalVariables.GRAVITY_CONSTANT]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for setting in settings: 
		var slider = setting_slider.instantiate()
		slider.name = setting
		container.add_child(slider)
		slider.get_node("Slider").min_value = ranges[setting][0]
		slider.get_node("Slider").max_value = ranges[setting][1]
		slider.get_node("Slider").step = ranges[setting][2]
		slider.get_node("Slider").value = ranges[setting][3]
		slider.get_node("Label").text = setting
		slider.get_node("Value").text = str(ranges[setting][3])
		slider.get_node("Slider").value_changed.connect(_on_value_changed.bind(slider))		
	
func _on_value_changed(value, node):
	GlobalVariables[node.name] = value
	node.get_node("Value").text = str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
