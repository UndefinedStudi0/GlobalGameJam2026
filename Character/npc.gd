extends NewtonPhysics

@export var waypoints: Array[Marker2D] = []
@export var color_id: String = "none"

@onready var collisionShape = $CollisionShape2D

var current_waypoint = 0
var maskref = null
var isAttached = false
var stop_distance = 10
var throw_time = 0
var jiggling = false

func _ready() -> void:
	add_to_group("npc")
	InteractionGroups.addInteractionGroup(self, color_id)
	if color_id != "none":
		InteractionGroups.addInteractionGroup(self, "none")
		
	self.set_collision_layer_value(12, true)

func _physics_process(delta):
	super._physics_process(delta)

	if !is_in_attach_grace_period():
		set_collision_mask_value(2, true)
		# invisible wall
		set_collision_mask_value(8, true)

	if Input.is_action_just_pressed("throw") && isAttached:
		print("throwing")
		throw()
	if waypoints.is_empty() || isAttached:
		if isAttached:
			direction = maskref.direction
		else:
			velocity.x = move_toward(velocity.x, 0.0, delta)
		check_for_mask()
		return
	
	var target = waypoints[current_waypoint].global_position

	var dist = global_position.distance_to(target)

	if jiggling && maskref.attachedTo != null:
		reach_waypoint()

	# Check if reached patrol point
	if dist < stop_distance:
		reach_waypoint()
		return

	# Calculate target velocityada
	direction = (target - global_position).normalized()
	var target_velocity = direction.x * speed

	velocity.x = target_velocity
	check_for_mask()


func check_for_mask():
	if !isAttached && move_and_slide():
		var entity = get_last_slide_collision()
		var mask = entity.get_collider()
		if mask.get("name") == "Mask" && !is_in_attach_grace_period():
			isAttached = mask.attach(self, collisionShape)
			if isAttached:
				if jiggling:
					clear_jiggle()
				maskref = mask

	update_facing_direction()

func reach_waypoint():
	if jiggling:
		clear_jiggle()
	else:
		current_waypoint = (current_waypoint+1) % waypoints.size()
	print("reached next waypoint")

func is_in_attach_grace_period():
	return (Time.get_ticks_msec() - throw_time) < 500

func throw():
	isAttached = false
	throw_time = Time.get_ticks_msec()
	set_collision_mask_value(2, false)
	# invisible wall
	self.set_collision_mask_value(8, false)
	reparent(get_tree().current_scene)
	maskref.selfThrow()
	maskref = null
	
func getJigglyWith(mask):
	if jiggling:
		return
	jiggling = true
	$AnimationPlayer.play("jiggled")
	maskref = mask
	var maskWayPoint = Marker2D.new()
	maskWayPoint.global_position = self.to_local(mask.global_position)
	add_child(maskWayPoint)
	waypoints.insert(0, maskWayPoint)
	current_waypoint = 0
	
func clear_jiggle():
	waypoints.remove_at(0)
	$AnimationPlayer.play("RESET")
	jiggling = false
