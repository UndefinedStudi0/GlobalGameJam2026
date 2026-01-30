extends NewtonPhysics

var attachedTo = null;

func attach(entityID):
	var entity = get_tree().current_scene.find_child(entityID)
	print("attaching to ", entityID)
	entity.reparent(self)
	entity.start_attach()

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
	move_and_slide()

func jump():
	attach("Npc")
	velocity.y = jump_velocity
	
func double_jump():
	velocity.y = double_jump_velocity
