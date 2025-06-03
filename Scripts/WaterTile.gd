extends Area2D

func _on_WaterTile_body_entered(body):
	if body.is_in_group("Drownable"):
		body.drown()
