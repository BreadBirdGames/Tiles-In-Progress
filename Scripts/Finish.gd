extends Area2D

var root = null
var spawner = null

func kill():
	queue_free()

func _on_Finish_body_entered(body):
	if body.is_in_group("Player"):
		get_parent()._on_Finish_body_entered(body)
