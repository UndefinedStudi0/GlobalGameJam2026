extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_custom_tooltip(for_text):
	var label = Label.new()
	var new_settings = LabelSettings.new()
	new_settings.font_size = 45

	label.text = for_text
	label.label_settings = new_settings
	return label
