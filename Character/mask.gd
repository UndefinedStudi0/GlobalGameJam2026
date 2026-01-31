class_name Mask extends NewtonPhysics

enum THROW_STATE {
	THROW_STARTED,
	THROW_IN_PROGRESS,
	NOT_THROWN
}

@export var crouched_throw_vect = Vector2(100, -80)
@export var normal_throw_vect = Vector2(280, -150)
@export var super_throw_vect = Vector2(80, -350)
	
func _ready() -> void:
	# required so it can be detected by the blue door
	self.set_collision_layer_value(12, true)

var attachedTo = null
var collisionShapeRef = null
@export var lifePoints = 3
var throwState : THROW_STATE = THROW_STATE.NOT_THROWN


func _physics_process(delta):
	super._physics_process(delta)

	#To ignore direction when the mask was just thrown 
	if was_in_air && throwState == THROW_STATE.THROW_STARTED:
		throwState = THROW_STATE.THROW_IN_PROGRESS
	if is_on_floor() && throwState == THROW_STATE.THROW_IN_PROGRESS:
		throwState = THROW_STATE.NOT_THROWN
		hit_floor()
	if is_on_floor() && throwState == THROW_STATE.NOT_THROWN:
		if attachedTo != null:
			move()
		else:
			jiggle()
		
	elif !is_on_floor() && throwState == THROW_STATE.NOT_THROWN:
		if direction.x != 0:
			velocity.x = move_toward(velocity.x, direction.x * air_speed, speed)
	move_and_slide()
	update_facing_direction()

func move():
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

func jiggle():
	velocity.x = move_toward(velocity.x, 0, speed)
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() == 0:
		return
	var npcs = $JiggleArea.get_overlapping_bodies()
	if len(npcs) > 0:
		npcs[0].getJigglyWith(self)

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
	throwState = THROW_STATE.THROW_STARTED
	# Remove NPC collision shape
	collisionShapeRef.queue_free()
	collisionShapeRef = null
	# Allow collisions with NPCs
	set_collision_layer_value(4, false)
	set_collision_layer_value(2, true)
	var throw_coeff = (1 if sprite.flip_h else -1)
	var throw_vect = normal_throw_vect
	if crouched:
		throw_vect = crouched_throw_vect
	elif looking_up:
		throw_vect = super_throw_vect
	velocity = throw_vect * Vector2(throw_coeff, 1)

func hit_floor():
	print("hit floor")
	if !attachedTo:
		updateHp(-1)
	Audio.fadein_safe()

func jump():
	velocity.y = jump_velocity

func double_jump():
	velocity.y = double_jump_velocity

func updateHp(delta: int):
	lifePoints += delta;
	updateHpLabel()

func setHp(value: int):
	lifePoints = value;
	updateHpLabel()

func updateHpLabel():
	$HP.text = "HP: %d" % lifePoints
