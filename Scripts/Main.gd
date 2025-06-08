extends Node2D
class_name Main

onready var play_button: Button = $CanvasLayer/MarginContainer/Editor/HBoxContainer/VBoxContainer/PanelContainer/HBoxContainer/PlayButton
onready var animation_player: AnimationPlayer = $CanvasLayer/MarginContainer/Editor/AnimationPlayer
onready var camera: CustomCamera = $CameraTarget/Camera

onready var dialogue: Popup = $CanvasLayer/Popup
onready var player_spawner = $PlayerSpawner

var button_states = {
	"Left": false,
	"Right": false
}

func _ready():
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("exit_play_mode"):
		if not get_tree().paused:
			switch_play_mode(true)

func switch_play_mode(newState: bool):
	if animation_player.current_animation != "":
		return
	
	if newState:
		animation_player.play("ShowUI")
		animation_player.seek(0.0, true)
		camera.change_follow(Vector2.ZERO, Vector2.ONE * 5)
		button_states["Right"] = false
		button_states["Left"] = false
		for spawner in get_tree().get_nodes_in_group("Spawner"):
			spawner.despawn()
	else:
		animation_player.play("HideUI")
		animation_player.seek(0.0, true)
		for spawner in get_tree().get_nodes_in_group("Spawner"):
			var temp_spawned = spawner.spawn()
			if not is_instance_valid(temp_spawned):
				spawner.spawned = temp_spawned
		
		camera.change_follow(player_spawner.spawned, Vector2.ONE * 4)
	
	get_tree().paused = newState

func _process(delta):
	if button_states["Left"] == true:
		camera.move_x(-1)
	elif button_states["Right"] == true:
		camera.move_x(1)

func _on_PlayButton_pressed():
	switch_play_mode(not get_tree().paused)

func _on_LeftButton_button_down():
	button_states["Left"] = true

func _on_LeftButton_button_up():
	button_states["Left"] = false

func _on_RightButton_button_down():
	button_states["Right"] = true

func _on_RightButton_button_up():
	button_states["Right"] = false

func _on_Finish_body_entered(body):
	if body.is_in_group("Player"):
		dialogue.popup_centered()
		switch_play_mode(true)

func _on_OKButton_pressed():
	dialogue.hide()
