# Godot Procedural Crosshair: Main script
#
# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

tool
extends Node2D

enum Marker {
	LINE,
	TRIANGLE,
	# TODO: Not yet implemented
	ARC,
}

# The shape's size
export(float, 0.0, 1000.0) var shape_size = 1.0 setget _shape_size_changed

# The number of sides to use for the shape
# Higher values will look closer to a circle
export(int, 3, 64) var shape_sides = 64

# The width of the shape's stroke
export(float, 0.0, 50.0) var shape_stroke_width = 1.1

# The width of the shape's outline
export(float, 0.0, 50.0) var shape_outline_width = 1.1

# The rotation of the shape (in degrees)
export(float, -360.0, 360.0) var shape_rotation = 0.0

# Whether to fill the shape with a solid color (see `shape_fill_modulate`)
export var fill_shape = true

# The color to use for the shape's stroke
export(Color, RGBA) var shape_stroke_modulate = Color(1.0, 1.0, 1.0, 1.0)

# The color to use for the shape's fill
export(Color, RGBA) var shape_fill_modulate = Color(1.0, 1.0, 1.0, 1.0)

# The color to use for the shape's outline
export(Color, RGBA) var shape_outline_modulate = Color(0.0, 0.0, 0.0, 0.5)

# The style of markers to use
export(Marker) var marker_style = Marker.LINE

# The markers' offset from the center
# Higher values look more spread apart
export(float, 0.0, 1000.0) var markers_spread = 0.0 setget _markers_spread_changed

# The number of markers
export(int, 0, 32) var markers_count = 4

# The length of markers
export(float, 0.0, 100.0) var marker_length = 10.0

# The length of markers' arms
# Non-zero values will create a T-shape or arrow depending on the arms' slope
export(float, 0.0, 100.0) var marker_arms_length = 10.0

# The slope of markers' arms
# Higher values will look more "slanted"
export(float, -100.0, 100.0) var marker_arms_slope = 0.0

# The width of markers
export(float, 0.0, 50.0) var marker_width = 2.0

# The width of markers' outlines
export(float, 0.0, 50.0) var marker_outline_width = 1.0

# The rotation of each marker (in degrees)
# TODO: Not yet implemented
export(float, -360.0, 360.0) var marker_local_rotation = 0.0

# The rotation of all markers (in degrees)
export(float, -360.0, 360.0) var marker_global_rotation = 0.0

# The color to use at the base of markers
export(Color, RGBA) var marker_modulate_base = Color(1.0, 1.0, 1.0, 1.0)

# The color to use at the tip of markers
export(Color, RGBA) var marker_modulate_tip = Color(1.0, 1.0, 1.0, 0.0)

# The color to use for the markers' outlines (at the base)
export(Color, RGBA) var marker_modulate_outline_base = Color(0.0, 0.0, 0.0, 0.5)

# The color to use for the markers' outlines (at the tip)
export(Color, RGBA) var marker_modulate_outline_tip = Color(0.0, 0.0, 0.0, 0.0)

# Whether to use anti-aliasing when available
export var use_antialiasing = true

func _shape_size_changed(size):
	shape_size = size
	update()

func _markers_spread_changed(spread):
	markers_spread = spread
	update()

func _enter_tree():
	update()

func _draw():
	# Shape point array to be drawn
	var shape_points = []
	# Shape color array to be drawn
	var shape_colors = []
	# Number of lines to be drawn
	var lines = 0
	# Stores marker point arrays to be drawn
	var marker_points = []
	# Stores marker color arrays to be drawn
	var marker_colors = []

	# Compute the shape
	for point in range(0, shape_sides):
		shape_points.append(Vector2(0, -shape_size).rotated(float(point)/shape_sides*TAU + deg2rad(shape_rotation)))

	# Add the last point to close the shape
	shape_points.append(shape_points[0])

	# draw_polygon() expects a PoolColorArray
	for _point in shape_points:
		shape_colors.append(shape_fill_modulate)

	# Draw the shape's stroke and outline
	# The outline must be drawn before so that it appears behind the stroke
	draw_polyline(
			shape_points,
			shape_outline_modulate,
			shape_stroke_width + shape_outline_width,
			use_antialiasing
	)
	draw_polyline(
			shape_points,
			shape_stroke_modulate,
			shape_stroke_width,
			use_antialiasing
	)

	if fill_shape:
		# Draw the shape's fill
		# Drawn last, so it appears above the stroke and outline
		draw_polygon(shape_points, shape_colors, [], null, null, use_antialiasing)

	# Compute markers
	for marker in range(0, markers_count):
		var rot = float(marker)/markers_count*TAU + deg2rad(marker_global_rotation)

		if marker_style == Marker.LINE:
			# We need different point sets for the fill and outline, because
			# draw_polyline() does not support any kind of line caps
			# The primary marker line is also shortened by `marker_width/2` to
			# avoid overlapping with the marker arms
			if marker_length > 0.0:
				marker_points.append([
					[
						Vector2(0, min(0, -markers_spread - marker_length + marker_width/2)).rotated(rot),
						Vector2(0, min(0, -markers_spread)).rotated(rot),
					],
					[
						Vector2(0, min(0, -markers_spread - marker_length + marker_width/2 - marker_outline_width)).rotated(rot),
						Vector2(0, min(0, -markers_spread + marker_outline_width)).rotated(rot),
					],
				])

			lines = 1

			if marker_arms_length > 0.0:
				marker_points.append([
					[
						Vector2(0, min(0, -markers_spread - marker_length)).rotated(rot),
						Vector2(-marker_arms_length, min(0, -markers_spread - marker_length - marker_arms_slope)).rotated(rot),
					],
					[
						Vector2(0, min(0, -markers_spread - marker_length)).rotated(rot),
						Vector2(-marker_arms_length - marker_outline_width, min(0, -markers_spread - marker_length - marker_arms_slope)).rotated(rot),
					],
				])

				marker_points.append([
					[
						Vector2(0, min(0, -markers_spread - marker_length)).rotated(rot),
						Vector2(marker_arms_length, min(0, -markers_spread - marker_length - marker_arms_slope)).rotated(rot),
					],
					[
						Vector2(0, min(0, -markers_spread - marker_length)).rotated(rot),
						Vector2(marker_arms_length + marker_outline_width, min(0, -markers_spread - marker_length - marker_arms_slope)).rotated(rot),
					],
				])

				lines = 3

			for i in range(0, lines):
				marker_colors.append([
					[
						# Fill color
						marker_modulate_base,
						marker_modulate_tip,
					],
					[
						# Outline color
						marker_modulate_outline_base,
						marker_modulate_outline_tip,
					],
				])

		elif marker_style == Marker.TRIANGLE:
			marker_points.append([
				Vector2(-marker_width, min(0, -markers_spread - marker_length)).rotated(rot),
				Vector2(marker_width, min(0, -markers_spread - marker_length)).rotated(rot),
				Vector2(0, min(0, -markers_spread)).rotated(rot),
			])

			marker_colors.append([
				[
					# Fill color
					marker_modulate_base,
					marker_modulate_base,
					marker_modulate_tip,
				],
				[
					# Outline color
					marker_modulate_outline_base,
					marker_modulate_outline_base,
					marker_modulate_outline_tip,
				],
			])

	# Draw markers
	for index in range(0, marker_points.size()):
		if marker_style == Marker.LINE:
			if marker_outline_width > 0.0:
				draw_polyline_colors(marker_points[index][1], marker_colors[index][1], marker_width + marker_outline_width, use_antialiasing)
			draw_polyline_colors(marker_points[index][0], marker_colors[index][0], marker_width, use_antialiasing)
		elif marker_style == Marker.TRIANGLE:
			# Outline rendering disabled as it looks broken
			"""
			if marker_outline_width > 0:
				pass
				draw_polyline_colors(marker_points[index], marker_colors[index][1], marker_width + marker_outline_width, use_antialiasing)
			"""
			draw_polygon(marker_points[index], marker_colors[index][0], [], null, null, use_antialiasing)
