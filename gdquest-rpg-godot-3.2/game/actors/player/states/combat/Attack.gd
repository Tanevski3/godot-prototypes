"""
The stagger state end with the stagger animation from the AnimationPlayer
The animation only affects the Body Sprite"s modulate property so 
it could stack with other animations if we had two AnimationPlayer nodes
"""
extends "res://game/utils/state/State.gd"

func enter():
	owner.get_node("AnimationPlayer").play("idle")
	owner.weapon.attack()

func _on_Sword_combo_finished():
	emit_signal("finished", "previous")