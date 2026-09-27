@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton("TransCam3D", "res://addons/TransCam3D/transcam.gd")


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("TransCam3D")
