extends Node

signal finished

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

## Transitions camera, lets you customize what it's a child of. 
## Largely depricated and replaced by transition_to(), and not used anymore.
func old_transition_to(newcam:Camera3D, time:float = 0.5, make_cam_child_of:Node3D = null) -> void:
	var timer := get_tree().create_timer(time)
	var oldcam := get_viewport().get_camera_3d()
	var transcam := Camera3D.new()
	
	transcam.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if make_cam_child_of == null:
		get_tree().current_scene.add_child(transcam)
	else:
		make_cam_child_of.add_child(transcam)
	
	transcam.global_position = oldcam.global_position
	transcam.global_basis = oldcam.global_basis
	transcam.fov = oldcam.fov
	transcam.make_current()
	
	var tweenpos := transcam.create_tween()
	var tweenbasis := transcam.create_tween()
	var tweenfov := transcam.create_tween()
	
	tweenpos.tween_property(transcam, "global_position", newcam.global_position, time)
	tweenbasis.tween_property(transcam, "global_basis", newcam.global_basis, time)
	tweenfov.tween_property(transcam, "fov", newcam.fov, time)
	
	await timer.timeout
	finished.emit()
	if newcam:
		newcam.make_current()
	if transcam:
		transcam.queue_free()

## Transitions a 3D camera locally, making it a child of the target camera and inherit its transform as a result.
## The preferred 3D camera transition method going forward.
func transition_to(newcam:Camera3D, time:float = 0.5, easing:Tween.TransitionType = Tween.TRANS_LINEAR, cull_options:int = newcam.cull_mask) -> void:
	var timer := get_tree().create_timer(time)
	var oldcam := get_viewport().get_camera_3d()
	var transcam := Camera3D.new()
	
	transcam.process_mode = Node.PROCESS_MODE_ALWAYS
	transcam.cull_mask = cull_options
	
	newcam.add_child(transcam)
	
	transcam.global_position = oldcam.global_position
	transcam.global_basis = oldcam.global_basis
	transcam.fov = oldcam.fov
	transcam.make_current()
	
	var tweenpos := transcam.create_tween()
	var tweenbasis := transcam.create_tween()
	var tweenfov := transcam.create_tween()
	
	tweenpos.set_trans(easing)
	tweenbasis.set_trans(easing)
	tweenfov.set_trans(easing)
	
	tweenpos.tween_property(transcam, "position", Vector3.ZERO, time)
	tweenbasis.tween_property(transcam, "basis", Basis.IDENTITY, time)
	tweenfov.tween_property(transcam, "fov", newcam.fov, time)
	
	await timer.timeout
	finished.emit()
	if transcam: 
		if newcam and transcam.current:
			newcam.make_current()
		transcam.queue_free()
