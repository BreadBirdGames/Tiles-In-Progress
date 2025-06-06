extends Control

export var end_position: Vector2 = Vector2(140,0)
export var input_width: float = 10
export var input_color: Color = Color.white
export var input_dash_length: float = 5

func _process(_delta):
	update()

func _draw():
	draw_set_transform_matrix(get_transform().inverse())
	draw_dashed_line(
		rect_position + rect_pivot_offset, 
		rect_position + end_position + rect_pivot_offset, 
		input_color, 
		input_width, 
		input_dash_length, 
		false)

func draw_capsule_segment(start: Vector2, end: Vector2, color: Color, width: float):
	var direction = end - start
	var length = direction.length()
	if length == 0:
		return
	
	var normal = direction.normalized()
	var perpendicular = Vector2(-normal.y, normal.x) * (width / 2.0)
	
	var p1 = start + perpendicular
	var p2 = start - perpendicular
	var p3 = end - perpendicular
	var p4 = end + perpendicular
	
	# Draw capsule body (rectangle)
	draw_polygon([p1, p2, p3, p4], [color])
	
	# Draw rounded ends (circles)
	draw_circle(start, width / 2.0, color)
	draw_circle(end, width / 2.0, color)


func draw_dashed_line(from, to, color, width, dash_length = 5, cap_end = false, antialiased = false):
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * dash_length
	
	if length < dash_length: #not long enough to dash
		draw_capsule_segment(from, to, color, width)
		#draw_line(from, to, color, width, antialiased)
		return

	else:
		var draw_flag = true
		var segment_start = from
		var steps = length/dash_length
		for _start_length in range(0, steps + 1):
			var segment_end = segment_start + dash_step
			if draw_flag:
				draw_capsule_segment(segment_start, segment_end, color, width)
				#draw_line(segment_start, segment_end, color, width, antialiased)
			
			segment_start = segment_end
			draw_flag = !draw_flag
		
		if cap_end:
			draw_capsule_segment(segment_start, to, color, width)
			#draw_line(segment_start, to, color, width, antialiased)
