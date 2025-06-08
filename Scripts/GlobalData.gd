extends Node

var stats = {
	"DispJumpMult": 1,
	"JumpMult": 1,
	"SpeedMult": 1
} setget set_stats

func set_stats(value):
	get_tree().call_group("StatChangeListeners", "stats_changed")
	stats = value
