extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.fadein_safe()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level1.tscn")
	LevelProgress.restart()
	
func on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Credits.tscn")
	LevelProgress.restart()
