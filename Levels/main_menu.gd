extends Control

var game_tracks: Dictionary[String, String] = {
	"attached": "res://Assets/MASK puzzle v2.mp3",
	"detached": "res://Assets/MASK sombre v2.mp3"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio._setup_tracks(game_tracks)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level1.tscn")
	
func on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Credits.tscn")
