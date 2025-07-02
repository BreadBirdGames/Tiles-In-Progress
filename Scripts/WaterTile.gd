extends Area2D

var kill_body

func _on_WaterTile_body_entered(body):
	if body.is_in_group("Drownable"):
		if body.global_position.x < global_position.x:
			$AnimationPlayer.play("KillLeft")
		else:
			$AnimationPlayer.play("KillRight")
		kill_body = body
		body.block()

func _ready():
	kill_body = null
	$AnimationPlayer.play("Idle")


func _on_AnimationPlayer_animation_finished(anim_name):
	if "Kill" in anim_name:
		kill_body.drown()
