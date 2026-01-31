class_name Mask extends NewtonPhysics

enum THROW_STATE {
	THROW_STARTED,
	THROW_IN_PROGRESS,
	NOT_THROWN
}

@export var crouched_throw_vect = Vector2(100, -80)
@export var normal_throw_vect = Vector2(280, -150)
@export var super_throw_vect = Vector2(80, -350)
@export var hp_bar: HPBar = null

var sfx_player = AudioStreamPlayer2D.new()

var jiggle_callback = null

var glass1res = preload("res://Assets/glass audio/glass 1.mp3")
var glass2res = preload("res://Assets/glass audio/glass 2.mp3")
var glass3res = preload("res://Assets/glass audio/glass 3.mp3")
var glass4res = preload("res://Assets/glass audio/glass 4.mp3")
var glass5res = preload("res://Assets/glass audio/glass 5.mp3")

func _ready() -> void:
	# required so it can be detected by the blue door
	self.set_collision_layer_value(12, true)
	

	var randomizer = AudioStreamRandomizer.new()
	randomizer.add_stream(0, glass1res)
	randomizer.add_stream(1, glass2res)
	randomizer.add_stream(2, glass3res)
	randomizer.add_stream(3, glass4res)
	randomizer.add_stream(4, glass5res)
	randomizer.playback_mode = AudioStreamRandomizer.PLAYBACK_RANDOM_NO_REPEATS
	sfx_player.stream = randomizer  # ← Assign randomizer directly, no instantiate_playback()
	sfx_player.volume_db = 0
	add_child(sfx_player)
	
var attachedTo = null
var collisionShapeRef = null
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
	$AnimationPlayer.play("jiggle")
	var npcs = $JiggleArea.get_overlapping_bodies()
	for npc in npcs:
		npc.getJigglyWith(self)

	sfx_player.play()
	
	if jiggle_callback != null :
		jiggle_callback.call()

func attach(entity, collisionShape):
	if attachedTo:
		#Cannot attach to multiple NPCs
		return false
	#Avoid collisions with NPCs while mask is attached
	set_collision_layer_value(4, true)
	set_collision_layer_value(2, false)
	# invisible wall
	set_collision_mask_value(8, true)
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
	# invisible wall
	set_collision_mask_value(8, false)
	var throw_coeff = (1 if sprite.flip_h else -1)
	var throw_vect = normal_throw_vect
	if crouched:
		throw_vect = crouched_throw_vect
	elif looking_up:
		throw_vect = super_throw_vect
	print(throw_vect)
	velocity = throw_vect * Vector2(throw_coeff, 1)

func hit_floor():
	print("hit floor")
	if !attachedTo:
		hp_bar.decrement()
	Audio.fadein_safe()

func jump():
	velocity.y = jump_velocity

func double_jump():
	velocity.y = double_jump_velocity


func showChatBox(message: String, message_id: String, auto_close_delay_in_s: int = 0):
	if !message:
		print("message missing")
		return

	if (!message_id):
		print("message_id missing")
		return;

	$ChatBox.chat_box_id = message_id

	if auto_close_delay_in_s == 0:
		$ChatBox.write_message(message)
	else:
		$ChatBox.write_message_with_delay(message, auto_close_delay_in_s)
