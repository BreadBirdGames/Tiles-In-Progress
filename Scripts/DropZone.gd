tool
extends Position2D
class_name DropZone

export var radius := 50.0

func position_inside(at_position: Vector2) -> bool:
	return get_global_transform_with_canvas().get_origin().distance_to(at_position) < radius
