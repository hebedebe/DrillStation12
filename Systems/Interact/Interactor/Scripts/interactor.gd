extends Node3D

var target: Interactable

func _input(event):
	if event is InputEventMouseButton: 
		if event.pressed:
			var _target = raycast_from_camera(event.position)
			if _target is Interactable:
				target = _target
				target.interact()
		else:
			if target:
				target.stop_interact()
				target = null

func raycast_from_camera(screen_pos: Vector2) -> CollisionObject3D:
	var camera = get_viewport().get_camera_3d()
	var space_state = get_world_3d().direct_space_state
	
	# Get ray origin and direction from camera
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_direction = camera.project_ray_normal(screen_pos)
	var ray_end = ray_origin + ray_direction * 1000  # Ray length
	
	# Create ray query
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = space_state.intersect_ray(query)
	
	if result:
		print("Hit: ", result.collider.name)
		print("Position: ", result.position)
		print("Normal: ", result.normal)
		print("")
		return result.collider
	return null
