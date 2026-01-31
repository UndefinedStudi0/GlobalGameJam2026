extends NewtonPhysics

var waypoints = []
var maskref = null
var isAttached = false

func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_just_pressed("throw") && isAttached:
		print("throwing")
		throw()
	if !isAttached && move_and_slide():
		var entity = get_last_slide_collision()
		var m = entity.get_collider()
		if m.get("name") == "Mask":
			var currentPos = global_position + Vector2(0,-25)
			print("current global pos ", currentPos)
			m.global_position = currentPos
			self.reparent(m)
			maskref = m
			isAttached=true	
			
	

func throw():
	isAttached = false
	self.reparent(get_tree().current_scene)
	maskref.selfThrow()
