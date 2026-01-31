extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mask/Camera2D.zoom = Vector2(4,4)
	$Mask/Camera2D.position = Vector2.ZERO
	$Mask/Camera2D.offset = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
