class_name Mask extends NewtonPhysics

var attachedTo = null
var throwVect = Vector2(250,-250)
var scene = preload("res://Character/npc_sprite.tscn")

func _physics_process(delta):
	super._physics_process(delta)
   # Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump from floor
			jump()
		elif not has_double_jumped:
			double_jump()


   # Get the input direction and handle the movement/deceleration.
   # As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")

	if direction.x != 0:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if move_and_slide():
		var collider = get_last_slide_collision().get_collider()
	
		#if collider.get_class():
		#attach(id.get_collider())
		#print("collision ", collider.get_class())
		
func attach(entity):
	print("attach ", entity)
	attachedTo = entity
	var d = scene.instantiate()
	d.global_position = entity.global_position
	add_child(d)
	entity.queue_free()
	
func is_attached():
	return attachedTo != null

func selfThrow():
	print("self throwing")
	velocity = throwVect

func jump():
	print("jump")
	velocity.y = jump_velocity
	
func double_jump():
	print("double jump")
	velocity.y = double_jump_velocity
