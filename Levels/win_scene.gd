extends Control

var victory = AudioStreamPlayer2D.new()
var asset = preload("res://Assets/MASK_success_!.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	victory.stream = asset
	add_child(victory)
	victory.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Credits.tscn")
