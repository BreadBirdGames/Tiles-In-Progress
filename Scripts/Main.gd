extends Node2D

onready var play_button: Button = $CanvasLayer/MarginContainer/Panel/HBoxContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayButton
onready var animation_player: AnimationPlayer = $CanvasLayer/MarginContainer/Panel/AnimationPlayer
onready var camera: CustomCamera = $CameraTarget/Camera

onready var spawner_list = get_node("/root/GlobalData")

func _ready():
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("exit_play_mode"):
		if not get_tree().paused:
			switch_play_mode(true)

func switch_play_mode(newState: bool):
	if animation_player.current_animation != "":
		return
	
	get_tree().paused = newState
	
	if not newState:
		animation_player.play("HideUI")
		animation_player.seek(0.0, true)
		for spawner in spawner_list.spawners:
			spawner.spawn()
		
		camera.change_follow(get_node("Player"), Vector2.ONE * 4)
	else:
		animation_player.play("ShowUI")
		animation_player.seek(0.0, true)
		camera.change_follow(null, Vector2.ONE * 5)
		for spawner in spawner_list.spawners:
			spawner.despawn()

func _on_PlayButton_pressed():
	switch_play_mode(not get_tree().paused)
