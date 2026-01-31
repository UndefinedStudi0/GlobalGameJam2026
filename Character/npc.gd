extends NewtonPhysics

@export var waypoints: Array[Marker2D] = []
var current_waypoint = 0
var maskref = null
var collisionShapeRef = null
var isAttached = false
var stop_distance = 10
var throw_time = 0

func _ready() -> void:
	# only this npc can interact with the blue door because of this line
	InteractionGroups.addInteractionGroup(self, "blue_door")
	# required so it can be detected by the blue door
	self.set_collision_layer_value(12, true)

func _physics_process(delta):
	super._physics_process(delta)
	
	if !is_in_attach_grace_period():
		set_collision_mask_value(2, true)
		
	
	if Input.is_action_just_pressed("throw") && isAttached:
		print("throwing")
		throw()
	if waypoints.is_empty():
		velocity.x = move_toward(velocity.x, 0.0, delta)
		check_for_mask()
		return
		
	var target = waypoints[current_waypoint].global_position
	
	var dist = global_position.distance_to(target)
	print("distance to next waypoint: ", dist)
	
	# Check if reached patrol point
	if dist < stop_distance:
		reach_waypoint()
		return
	
	# Calculate target velocity
	var direction = (target - global_position).normalized()
	var target_velocity = direction.x * speed
	
	velocity.x = target_velocity
	check_for_mask()
			
			
func check_for_mask():
	if !isAttached && move_and_slide():
		var entity = get_last_slide_collision()
		var m = entity.get_collider()
		if m.get("name") == "Mask" && !is_in_attach_grace_period():	
			var currentPos = global_position + Vector2(0,-25)
			print("current global pos ", currentPos)
			m.global_position = currentPos
			collisionShapeRef = $CollisionShape2D.duplicate()
			m.add_child(collisionShapeRef)
			collisionShapeRef.global_position = $CollisionShape2D.global_position
			self.reparent(m)
			maskref = m
			isAttached=true	

func reach_waypoint():
	current_waypoint = (current_waypoint+1) % waypoints.size()
	print("reached next waypoint")
	
func is_in_attach_grace_period():
	return (Time.get_ticks_msec() - throw_time) < 500

func throw():
	isAttached = false
	throw_time = Time.get_ticks_msec()
	collisionShapeRef.queue_free()
	collisionShapeRef = null
	set_collision_mask_value(2, false)
	reparent(get_tree().current_scene)
	maskref.selfThrow()
	maskref = null
