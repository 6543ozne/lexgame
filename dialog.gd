extends Node2D

signal yeah

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("testbutton"):
		get_tree().reload_current_scene()
