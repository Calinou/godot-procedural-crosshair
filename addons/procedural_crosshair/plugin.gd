# Godot Procedural Crosshair: Plugin registration
#
# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"Crosshair",
		"Node2D",
		preload("procedural_crosshair.gd"),
		preload("icon.png")
	)

func _exit_tree():
	remove_custom_type("Crosshair")
