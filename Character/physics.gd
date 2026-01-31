class_name NewtonPhysics extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -250.0
@export var double_jump_velocity : float = -250

@onready var sprite = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
@export var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		
		was_in_air = false
	
func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
