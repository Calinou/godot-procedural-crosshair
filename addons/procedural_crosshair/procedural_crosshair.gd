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

# All exported variables are set in this dictionary
# This makes them easier to handle in `_set()` and `_get()`
var exports = {
	# Whether to use anti-aliasing when available
	use_antialiasing = true,

	shape = {
		# The shape's size
		size = 10.0,

		# The number of sides to use for the shape
		# Higher values will look closer to a circle
		sides = 64,

		# The width of the shape's stroke
		stroke_width = 1.1,

		# The width of the shape's outline
		outline_width = 1.1,

		# The rotation of the shape (in degrees)
		rotation = 0.0,

		# Whether to fill the shape with a solid color (see `shape/fill_modulate`)
		fill = true,

		# The color to use for the shape's stroke
		stroke_modulate = Color(1.0, 1.0, 1.0, 1.0),

		# The color to use for the shape's fill
		fill_modulate = Color(1.0, 1.0, 1.0, 1.0),

		# The color to use for the shape's outline
		outline_modulate = Color(1.0, 1.0, 1.0, 1.0),
	},

	markers = {
		# The style of markers to use
		style = Marker.LINE,

		# The number of markers
		count = 4,

		# The length of markers
		length = 10.0,

		# The width of markers
		width = 2.0,

		# The width of markers' outlines
		outline_width = 1.0,

		# The markers' offset from the center
		# Higher values look more spread apart
		spread = 0.0,

		# The length of markers' arms
		# Non-zero values will create a T-shape or arrow depending on the arms' slope
		arms_length = 10.0,

		# The slope of markers' arms
		# Higher values will look more "slanted"
		arms_slope = 10.0,

		# How much are markers' arms spread apart
		arms_spread = 0.0,

		# How many degrees should the markers span over
		arc_angle = 360.0,

		# The rotation of each marker (in degrees)
		local_rotation = 0.0,

		# The rotation of all markers (in degrees)
		global_rotation = 0.0,

		# The color to use at the base of markers
		base_modulate = Color(1.0, 1.0, 1.0, 1.0),

		# The color to use at the tip of markers
		tip_modulate = Color(1.0, 1.0, 1.0, 0.0),

		# The color to use for the markers' outlines (at the base)
		base_outline_modulate = Color(0.0, 0.0, 0.0, 0.5),

		# The color to use for the markers' outlines (at the tip)
		tip_outline_modulate = Color(0.0, 0.0, 0.0, 0.0),
	},
}

func _get(property):
	var path = property.split("/")
	print(path[0])

	# Check if there is a matching key in the `exports` dictionary
	if exports.has(path[0]) && exports.path[0].has(path[1]):
		print("get: " + str(property))
		return true

	return false

func _set(property, value):
	var path = property.split("/")
	print(path)

	# Check if there is a matching key in the `exports` dictionary
	if exports.has(path[0]) and exports.path[0].has(path[1]):
		print("set:" + str(property) + " => " +str(value))
		return true

	return false

func _get_property_list():
	return [
		{
			name = "shape/size",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,1000.0",
		},
		{
			name = "shape/sides",
			type = TYPE_INT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "3,64",
		},
		{
			name = "shape/stroke_width",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,50.0",
		},
		{
			name = "shape/outline_width",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,50.0",
		},
		{
			name = "shape/rotation",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "-360.0,360.0",
		},
		{
			name = "shape/fill",
			type = TYPE_BOOL,
		},
		{
			name = "shape/stroke_modulate",
			type = TYPE_COLOR,
		},
		{
			name = "shape/fill_modulate",
			type = TYPE_COLOR,
		},
		{
			name = "shape/outline_modulate",
			type = TYPE_COLOR,
		},
		{
			name = "markers/style",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "Line,Triangle",
		},
		{
			name = "markers/count",
			type = TYPE_INT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,32",
		},
		{
			name = "markers/length",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,100.0",
		},
		{
			name = "markers/width",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,50.0",
		},
		{
			name = "markers/outline_width",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,50.0",
		},
		{
			name = "markers/spread",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,1000.0",
		},
		{
			name = "markers/arms_length",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,100.0",
		},
		{
			name = "markers/arms_slope",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "-100.0,100.0",
		},
		{
			name = "markers/arms_spread",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "-100.0,100.0",
		},
		{
			name = "markers/arc_angle",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0,360.0",
		},
		{
			name = "markers/local_rotation",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "-360.0,360.0",
		},
		{
			name = "markers/global_rotation",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "-360.0,360.0",
		},
		{
			name = "markers/base_modulate",
			type = TYPE_COLOR,
		},
		{
			name = "markers/tip_modulate",
			type = TYPE_COLOR,
		},
		{
			name = "markers/base_outline_modulate",
			type = TYPE_COLOR,
		},
		{
			name = "markers/tip_outline_modulate",
			type = TYPE_COLOR,
		},
	]

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
	for point in range(0, exports.shape.sides):
		shape_points.append(Vector2(0, -exports.shape.size).rotated(float(point)/exports.shape.sides*TAU + deg2rad(exports.shape.rotation)))

	# Add the last point to close the shape
	shape_points.append(shape_points[0])

	# draw_polygon() expects a PoolColorArray
	for _point in shape_points:
		shape_colors.append(exports.shape.fill_modulate)

	# Draw the shape's stroke and outline
	# The outline must be drawn before so that it appears behind the stroke
	draw_polyline(
			shape_points,
			exports.shape.outline_modulate,
			exports.shape.stroke_width + exports.shape.outline_width,
			exports.use_antialiasing
	)
	draw_polyline(
			shape_points,
			exports.shape.stroke_modulate,
			exports.shape.stroke_width,
			exports.use_antialiasing
	)

	if exports.shape.fill:
		# Draw the shape's fill
		# Drawn last, so it appears above the stroke and outline
		draw_polygon(shape_points, shape_colors, [], null, null, exports.use_antialiasing)

	# Compute markers
	for marker in range(0, exports.markers.count):
		var rot_global = \
				float(marker)/exports.markers.count*deg2rad(exports.markers.arc_angle) \
				+ deg2rad(exports.markers.global_rotation)
		var rot_local = rot_global + deg2rad(exports.markers.local_rotation)

		if exports.markers.style == Marker.LINE:
			# We need different point sets for the fill and outline, because
			# draw_polyline() does not support any kind of line caps
			# The primary marker line is also shortened by `exports.markers.width/2` to
			# avoid overlapping with the marker arms
			if exports.markers.length > 0.0:
				lines = 1

				marker_points.append([
					[
						Vector2(0, -exports.markers.length/2 + exports.markers.width/2) \
								.rotated(rot_local)
						+ Vector2(0, -exports.markers.spread) \
								.rotated(rot_global),
						Vector2(0, exports.markers.length/2 + exports.markers.width/2) \
								.rotated(rot_local)
						+ Vector2(0, -exports.markers.spread) \
								.rotated(rot_global),
					],
					[
						Vector2(0, -exports.markers.length/2 + exports.markers.width/2 + exports.markers.outline_width/2) \
								.rotated(rot_local) \
						+ Vector2(0, -exports.markers.spread) \
								.rotated(rot_global),
						Vector2(0, exports.markers.length/2 + exports.markers.width/2 + exports.markers.outline_width/2) \
								.rotated(rot_local)
						+ Vector2(0, -exports.markers.spread) \
								.rotated(rot_global),
					],
				])

			if exports.markers.arms_length > 0.0 or exports.markers.arms_slope != 0.0:
				lines = 3

				for side in [-1, 1]:
					# Left side/right side
					marker_points.append([
						[
							Vector2(exports.markers.arms_spread*side, -exports.markers.length/2) \
									.rotated(rot_local)
							+ Vector2(0, -exports.markers.spread) \
									.rotated(rot_global),
							Vector2((exports.markers.arms_spread + exports.markers.arms_length)*side, -exports.markers.length/2 - exports.markers.arms_slope) \
									.rotated(rot_local)
							+ Vector2(0, -exports.markers.spread) \
									.rotated(rot_global),
						],
						[
							Vector2(exports.markers.arms_spread*side, -exports.markers.length/2) \
									.rotated(rot_local)
							+ Vector2(0, -exports.markers.spread) \
									.rotated(rot_global),
							Vector2((exports.markers.arms_spread + exports.markers.arms_length)*side - exports.markers.outline_width*side/2, -exports.markers.length/2 - exports.markers.arms_slope) \
									.rotated(rot_local)
							+ Vector2(0, -exports.markers.spread) \
									.rotated(rot_global),
						],
					])

			for i in range(0, lines):
				marker_colors.append([
					[
						# Fill color
						exports.markers.base_modulate,
						exports.markers.tip_modulate,
					],
					[
						# Outline color
						exports.markers.base_outline_modulate,
						exports.markers.tip_outline_modulate,
					],
				])

		elif exports.markers.style == Marker.TRIANGLE:
			marker_points.append([
				Vector2(-exports.markers.width, -exports.markers.length) \
						.rotated(rot_local)
				+ Vector2(0, -exports.markers.spread) \
						.rotated(rot_global),
				Vector2(exports.markers.width, -exports.markers.length) \
						.rotated(rot_local)
				+ Vector2(0, -exports.markers.spread) \
						.rotated(rot_global),
				Vector2(0, 0) \
						.rotated(rot_local)
				+ Vector2(0, -exports.markers.spread) \
						.rotated(rot_global),
			])

			marker_colors.append([
				[
					# Fill color
					exports.markers.base_modulate,
					exports.markers.base_modulate,
					exports.markers.tip_modulate,
				],
				[
					# Outline color
					exports.markers.base_outline_modulate,
					exports.markers.base_outline_modulate,
					exports.markers.tip_outline_modulate,
				],
			])

	# Draw markers
	for index in range(0, marker_points.size()):
		if exports.markers.style == Marker.LINE:
			if exports.markers.outline_width > 0.0:
				draw_polyline_colors(
						marker_points[index][1],
						marker_colors[index][1],
						exports.markers.width + exports.markers.outline_width,
						exports.use_antialiasing
				)

			draw_polyline_colors(
					marker_points[index][0],
					marker_colors[index][0],
					exports.markers.width,
					exports.use_antialiasing
			)

		elif exports.markers.style == Marker.TRIANGLE:
			# Outline rendering disabled as it looks broken
			"""
			if exports.markers.outline_width > 0:
				pass
				draw_polyline_colors(
						marker_points[index],
						marker_colors[index][1],
						exports.markers.width + exports.markers.outline_width,
						use_antialiasing
				)
			"""
			draw_polygon(
					marker_points[index],
					marker_colors[index][0],
					[],
					null,
					null,
					exports.use_antialiasing
			)
