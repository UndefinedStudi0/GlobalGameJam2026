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

var detached_music = AudioStreamPlayer2D.new()
var attached_music = AudioStreamPlayer2D.new()
var throw_sfx = AudioStreamPlayer2D.new()
var catch_sfx = AudioStreamPlayer2D.new()
var fall_sfx = AudioStreamPlayer2D.new()

var jiggle_callback = null

var glass1res = preload("res://Assets/glass audio/glass 1.mp3")
var glass2res = preload("res://Assets/glass audio/glass 2.mp3")
var glass3res = preload("res://Assets/glass audio/glass 3.mp3")
var glass4res = preload("res://Assets/glass audio/glass 4.mp3")
var glass5res = preload("res://Assets/glass audio/glass 5.mp3")

# can be triggered while running animations etc
var are_movements_disabled = false
var positioncamerabase = Vector2(0,-11)

func _ready() -> void:
	# required so it can be detected by the blue door
	self.set_collision_layer_value(12, true)
	
	self.add_to_group("player")
	
	# add this interaction group by default so other elements can just add the "player" key
	# so we don't have to also add it to the player. (useful for EventTrigger as an example)
	InteractionGroups.addInteractionGroup(self, "player")

	print("camera position ", $Camera2D.position)	

	detached_music.stream = load("res://Assets/MASK sombre v2.mp3")
	attached_music.stream = load("res://Assets/MASK puzzle v2.mp3")
	throw_sfx.stream = load("res://Assets/MASK_lance.mp3")
	catch_sfx.stream = load("res://Assets/MASK_mis.mp3")
	fall_sfx.stream = load("res://Assets/MASK_degats.mp3")
	add_child(detached_music)
	add_child(attached_music)
	add_child(throw_sfx)
	add_child(catch_sfx)
	add_child(fall_sfx)
	
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
			
	if !are_movements_disabled:
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
		move_camera()
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		move_camera(true)
	


func move_camera(vertical = false):
	var tween = get_tree().create_tween()
	
	if !vertical:
		if direction.x > 0:
			positioncamerabase = Vector2(112,-11)
			tween.tween_property($Camera2D, "offset", positioncamerabase,1).set_ease(Tween.EASE_IN)
		elif direction.x < 0:
			positioncamerabase = Vector2(-112,-11)
			tween.tween_property($Camera2D, "offset", positioncamerabase,1).set_ease(Tween.EASE_IN)
		
	if vertical:
		match stand_state:
			StandState.STANDING: tween.tween_property($Camera2D, "offset", positioncamerabase+Vector2(0,0),1).set_ease(Tween.EASE_IN)
			StandState.LOOKUP: tween.tween_property($Camera2D, "offset", positioncamerabase+Vector2(0,-50),1).set_ease(Tween.EASE_IN)
			StandState.CROUCH: tween.tween_property($Camera2D, "offset", positioncamerabase+Vector2(0,50),1).set_ease(Tween.EASE_IN)
	

func jiggle():
	velocity.x = move_toward(velocity.x, 0, speed)
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() == 0:
		return
	$AnimationPlayer.play("jiggle")
	var npcs = $JiggleArea.get_overlapping_bodies()
	for npc in npcs:
		npc.getJigglyWith(self)

	detached_music.play()
	#sfx_player.play()
	
	if jiggle_callback != null :
		jiggle_callback.call()

func attach(entity, collisionShape):
	if attachedTo:
		#Cannot attach to multiple NPCs
		return false
	detached_music.stop()
	catch_sfx.play()
	if throwState == THROW_STATE.NOT_THROWN:
		attached_music.play()
		detached_music.stop()
	$AnimationPlayer.play("RESET")
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
	move_child(self, -1)
	move_child(entity, 0)
	return true

func selfThrow():
	print("self throwing")
	attachedTo = null
	throwState = THROW_STATE.THROW_STARTED
	throw_sfx.play()
	# Remove NPC collision shape
	collisionShapeRef.queue_free()
	collisionShapeRef = null
	# Allow collisions with NPCs
	set_collision_layer_value(4, false)
	set_collision_layer_value(2, true)
	# invisible wall
	set_collision_mask_value(8, false)
	var throw_coeff = (1 if sprite.flip_h else -1)
	var throw_vect
	match stand_state:
		StandState.STANDING: throw_vect = normal_throw_vect
		StandState.LOOKUP: throw_vect = super_throw_vect
		StandState.CROUCH: throw_vect = crouched_throw_vect
	velocity = throw_vect * Vector2(throw_coeff, 1)

func hit_floor():
	print("hit floor")
	if !attachedTo:
		hp_bar.decrement()
		detached_music.play()
		attached_music.stop()
		fall_sfx.play()

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

func addInteractionGroup(group: String):
	if group:
		InteractionGroups.addInteractionGroup(self, group)
	else:
		print("group missing")
