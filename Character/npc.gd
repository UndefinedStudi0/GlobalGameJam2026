extends NewtonPhysics

var waypoints = []
var isController = false
var isAttached = false

func _physics_process(delta):
	super._physics_process(delta)
	move_and_slide()
	
func start_attach():
	isAttached = true
	print("I'm attached")
	
