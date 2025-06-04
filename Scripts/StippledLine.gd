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


func draw_dashed_line(from, to, color, width, dash_length = 5, cap_end = false, antialiased = false):
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * dash_length
	
	if length < dash_length: #not long enough to dash
		draw_line(from, to, color, width, antialiased)
		return

	else:
		var draw_flag = true
		var segment_start = from
		var steps = length/dash_length
		for _start_length in range(0, steps + 1):
			var segment_end = segment_start + dash_step
			if draw_flag:
				draw_line(segment_start, segment_end, color, width, antialiased)

			segment_start = segment_end
			draw_flag = !draw_flag
		
		if cap_end:
			draw_line(segment_start, to, color, width, antialiased)
