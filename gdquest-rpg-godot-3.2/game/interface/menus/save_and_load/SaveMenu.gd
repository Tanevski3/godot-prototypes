extends "res://game/interface/menus/Menu.gd"

onready var save_button = $Panel/Column/SaveButton
onready var load_button = $Panel/Column/LoadButton

func open(args=[]):
	.open()
	save_button.grab_focus()
