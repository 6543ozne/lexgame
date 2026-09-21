extends Node2D

signal yeah

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("testbutton"):
		dialog_test(null)

func dialog_test(cue) -> void:
	DialogueManager.show_example_dialogue_balloon(load("res://dialog/test.dialogue"),"start")
	return
