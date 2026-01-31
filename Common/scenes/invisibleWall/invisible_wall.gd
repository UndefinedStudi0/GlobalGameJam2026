extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticBody2D.set_collision_layer_value(1, false)
	$StaticBody2D.set_collision_mask_value(1, false)
	
	$StaticBody2D.set_collision_layer_value(8, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
