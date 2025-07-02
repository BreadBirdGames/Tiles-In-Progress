extends Control

onready var global_data = get_node("/root/GlobalData")

onready var jump_label = $VBoxContainer/Jump/Label
onready var speed_label = $VBoxContainer/Speed/Label
onready var time_progress = $CenterContainer/TextureProgress

func _ready():
	stats_changed()

func stats_changed():
	jump_label.text = str(global_data.stats.DispJumpMult)
	speed_label.text = str(global_data.stats.SpeedMult)

func progress_changed(new_status):
	time_progress.value = new_status
