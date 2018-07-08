# Godot Procedural Crosshair: Main script
#
# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

tool
extends Node2D

enum Marker {
	LINE,
	T_SHAPE,
	CARET,
	TRIANGLE,
	ARROW,
	ARC,
}

# The spread value used by the crosshair
# A value of 1 will make a crosshair placed at the middle of the window
# as large as the window's height
export(float, 0, 1.0) var spread = 0.0

# The number of sides to use for the shape
# Higher values will look closer to a circle
export(int, 3, 64) var shape_points = 12

# Whether to fill the shape with a solid color (see `shape_fill_modulate`)
export var shape_filled = false

# The color to use for the shape's stroke
export(Color, RGBA) var shape_stroke_modulate = Color(1.0, 1.0, 1.0, 1.0)

# The color to use for the shape's fill
export(Color, RGBA) var shape_fill_modulate = Color(1.0, 1.0, 1.0, 0.2)

# The offset between the shape and markers
# Useful to make the shape appear "inside" or "outside" of the markers
export(float, -1.0, 1.0) var shape_offset = 0.0

# The style of markers to use
export(Marker) var marker = Marker.LINE

# The number of markers
export(int, 0, 32) var markers = 4

# The length of markers
export(float, 0.0, 100.0) var marker_length = 10.0

# The width of markers
export(float, 0.0, 50.0) var marker_width = 2.0

# The rotation of each marker
export(float, 0.0, 360.0) var marker_rotation_local = 0.0

# The rotation of all markers
export(float, 0.0, 360.0) var marker_rotation_global = 0.0

# The color to use for markers
export(Color, RGBA) var marker_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _enter_tree():
	update()

func _draw():
	pass
