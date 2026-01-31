class_name Mask extends NewtonPhysics

var throwVect = Vector2(250,-250)

func _ready() -> void:
	# required so it can be detected by the blue door
	self.set_collision_layer_value(12, true)

var attachedTo = null
var collisionShapeRef = null
var was_thrown = false
@export var lifePoints = 3

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

	#To ignore direction when the mask was just thrown
	if was_in_air && was_thrown:
		was_thrown = false
	if attachedTo != null && !attachedTo.is_in_attach_grace_period() && is_on_floor():
		detach()
	if is_on_floor() && !was_thrown:
		if direction.x != 0:
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	update_facing_direction()

func attach(entity, collisionShape):
	if attachedTo:
		#Cannot attach to multiple NPCs
		return false
	#Avoid collisions with NPCs while mask is attached
	set_collision_layer_value(4, true)
	set_collision_layer_value(2, false)
	#Move mask above NPC
	global_position = entity.global_position + Vector2(0,-25)
	#Keep reference to attached entity
	attachedTo = entity
	#Copy attached entity collision shape to keep global hitbox
	collisionShapeRef = collisionShape.duplicate()
	add_child(collisionShapeRef)
	collisionShapeRef.global_position = collisionShape.global_position
	#Add NPC as child
	entity.reparent(self)
	# Play music
	Audio.fadein_danger()

	return true

func selfThrow():
	print("self throwing")
	attachedTo = null
	was_thrown = true
	# Remove NPC collision shape
	collisionShapeRef.queue_free()
	collisionShapeRef = null
	# Allow collisions with NPCs
	set_collision_layer_value(4, false)
	set_collision_layer_value(2, true)
	velocity = throwVect * Vector2(1 if sprite.flip_h else -1, 1)

func detach():
	print("hit floor")
	attachedTo = null
	lifePoints -= 1
	Audio.fadein_safe()

func jump():
	velocity.y = jump_velocity

func double_jump():
	velocity.y = double_jump_velocity
