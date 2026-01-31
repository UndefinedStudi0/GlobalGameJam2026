extends Node2D

@export var door_colorid: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match door_colorid:
		1:
			$KeypassGreen.visible = true
			$KeypassYellow.visible = false
		2:
			$KeypassGreen.visible = false
			$KeypassYellow.visible = true
		_:
			$KeypassGreen.visible = false
			$KeypassYellow.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
