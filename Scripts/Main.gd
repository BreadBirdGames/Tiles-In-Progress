extends Node

onready var play_button: Button = $CanvasLayer/HBoxContainer/Panel/VBoxContainer/PlayButton
onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var spawner_list = get_node("/root/SpawnerList")

func _ready():
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("exit_play_mode"):
		switch_play_mode(true)

func switch_play_mode(newState: bool):
	if animation_player.current_animation != "":
		return
	
	get_tree().paused = newState
	if not newState:
		animation_player.play("HideUI")
		for spawner in spawner_list.spawners:
			spawner.spawn()
	else:
		animation_player.play("ShowUI")
		for spawner in spawner_list.spawners:
			spawner.despawn()

func _on_PlayButton_pressed():
	switch_play_mode(not get_tree().paused)
