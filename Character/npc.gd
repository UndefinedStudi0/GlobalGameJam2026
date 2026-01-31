extends NewtonPhysics

var waypoints = []
var isController = false
var isAttached = false

func _physics_process(delta):
	super._physics_process(delta)
	if move_and_slide():
		var entity = get_last_slide_collision()
		var m = entity.get_collider()
		if m.get("name") == "Mask":
			self.reparent(m)
			isAttached=true
	
