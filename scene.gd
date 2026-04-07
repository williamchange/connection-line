extends GraphEdit

func _ready() -> void:
	get_window().content_scale_factor = 2.0
	get_window().size *= 2.0 
	get_window().move_to_center()
	connect_node("A", 0, "B", 0)
	connection_lines_thickness = 5.0

func _get_connection_line(from: Vector2, to: Vector2) -> PackedVector2Array:
	var points : PackedVector2Array
	var off:= 20.0 * zoom

	var start := from
	var end := to
	from.x += off
	to.x -= off

	var mid := (from + to) * 0.5
	var diff := mid - from

	var from_a := mid - Vector2(diff.y, diff.y)
	var mid_b := mid + Vector2(diff.x, diff.x)
	var corner_from := Vector2(from.x, mid.y)
	var corner_to := Vector2(to.x, mid.y)

	points.append(start)
	if from.y < to.y:
		if from.x > to.x:
			var max_off := absf(diff.y) * 0.5
			if (corner_from.x - max_off) - (corner_to.x + max_off) < 0.0:
				max_off = clampf(diff.x * 0.5, -diff.x, diff.y)
			points.append(from)
			points.append(Vector2(corner_from.x, corner_from.y - max_off))
			points.append(Vector2(corner_from.x - max_off, corner_from.y))
			points.append(mid)
			points.append(Vector2(corner_to.x + max_off, corner_to.y))
			points.append(Vector2(corner_to.x, corner_to.y + max_off))
			points.append(to)
		else:
			if from_a.x < from.x:
				from_a = mid - Vector2(diff.x, diff.x)
			else:
				mid_b = mid + Vector2(diff.y, diff.y)
			points.append_array([from, from_a, mid, mid_b, to])
	elif from.y > to.y:
		if from.x > to.x:
			diff.y = mid.y - to.y
			var max_off := absf(diff.y) * 0.5
			if (corner_from.x - max_off) - (corner_to.x + max_off) < 0.0:
				max_off = clamp(diff.x * 0.5, -diff.x, diff.y)
			points.append(from)
			points.append(Vector2(corner_from.x, corner_from.y + max_off))
			points.append(Vector2(corner_from.x - max_off, corner_from.y))
			points.append(mid)
			points.append(Vector2(corner_to.x + max_off, corner_to.y))
			points.append(Vector2(corner_to.x, corner_to.y - max_off))
			points.append(to)
		else:
			from_a = mid + Vector2(diff.y, -diff.y)
			mid_b = mid + Vector2(-diff.y, diff.y)
			if from_a.x < from.x:
				mid_b = mid + Vector2(diff.x, -diff.x)
				from_a = mid - Vector2(diff.x, -diff.x)
			points.append_array([from, from_a, mid, mid_b, to])
	points.append(end)

	return PackedVector2Array(points)
