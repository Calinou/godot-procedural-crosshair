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

# The spread value used by the crosshair (in pixels)
export(float, 0.0, 500.0) var spread = 0.0 setget _spread_changed

# The number of sides to use for the shape
# Higher values will look closer to a circle
export(int, 3, 64) var shape_sides = 64

# The width of the shape's stroke
export(float, 0.0, 50.0) var shape_stroke_width = 1.1

# Whether to fill the shape with a solid color (see `shape_fill_modulate`)
export var fill_shape = false

# The color to use for the shape's stroke
export(Color, RGBA) var shape_stroke_modulate = Color(1.0, 1.0, 1.0, 1.0)

# The color to use for the shape's fill
export(Color, RGBA) var shape_fill_modulate = Color(1.0, 1.0, 1.0, 0.2)

# The style of markers to use
export(Marker) var marker_style = Marker.LINE

# The number of markers
export(int, 0, 32) var markers_count = 4

# The length of markers
export(float, 0.0, 100.0) var marker_length = 10.0

# The width of markers
export(float, 0.0, 50.0) var marker_width = 2.0

# The offset between the shape and markers
# Useful to make the markers appear "outside" (positive value) or "inside"
# (negative value) of the markers
export(float, -50.0, 50.0) var marker_offset = 0.0

# The rotation of each marker
# TODO: Not yet implemented
export(float, -360.0, 360.0) var marker_local_rotation = 0.0

# The rotation of all markers
export(float, -360.0, 360.0) var marker_global_rotation = 0.0

# The color to use at the base of markers
export(Color, RGBA) var marker_modulate_base = Color(1.0, 1.0, 1.0, 1.0)

# The color to use at the tip of markers
export(Color, RGBA) var marker_modulate_tip = Color(1.0, 1.0, 1.0, 0.0)

# Whether to use anti-aliasing when available
export var use_antialiasing = true

var shape_points
var shape_colors
var marker_points
var marker_colors
var marker_point
var marker_color

func _spread_changed(spr):
	spread = spr
	update()

func _enter_tree():
	update()

func _draw():
	# Shape point array to be drawn
	shape_points = []
	# Shape color array to be drawn
	shape_colors = []
	# Stores marker point arrays to be drawn
	marker_points = []
	# Stores marker color arrays to be drawn
	marker_colors = []
	# Array of points for a single marker
	marker_point = []
	# Array of colors for a single marker
	marker_color = []

	# Shape
	for point in range(0, shape_sides):
		shape_points.append(Vector2(0, -spread).rotated(float(point)/shape_sides*TAU))

	# Add the last point to close the shape
	shape_points.append(shape_points[0])

	# draw_polygon() expects a PoolColorArray
	for _point in shape_points:
		shape_colors.append(shape_fill_modulate)

	# Markers
	for marker in range(0, markers_count):
		# Line
		marker_point.append([
			Vector2(0, min(0, -marker_offset - spread)).rotated(float(marker)/markers_count*TAU + deg2rad(marker_global_rotation)),
			Vector2(0, min(0, -marker_offset - spread - marker_length)).rotated(float(marker)/markers_count*TAU + deg2rad(marker_global_rotation)),
		])

		marker_color.append([
			marker_modulate_base,
			marker_modulate_tip,
		])

		marker_points.append(marker_point)
		marker_colors.append(marker_color)

	# Draw the shape's stroke
	draw_polyline(shape_points, shape_stroke_modulate, shape_stroke_width, use_antialiasing)

	if fill_shape:
		# Draw the shape's fill
		draw_polygon(shape_points, shape_colors, [], null, null, use_antialiasing)

	# Draw markers
	for index in range(0, marker_points.size()):
		draw_polyline_colors(marker_point[index], marker_color[index], marker_width, use_antialiasing)
