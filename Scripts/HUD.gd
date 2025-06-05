extends Control

onready var global_data = get_node("/root/GlobalData")

onready var jump_label = $VBoxContainer/Jump/Label
onready var speed_label = $VBoxContainer/Speed/Label

func _ready():
	stats_changed()

func stats_changed():
	jump_label.text = str(global_data.stats.DispJumpMult)
	speed_label.text = str(global_data.stats.SpeedMult)
