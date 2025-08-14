extends "res://Scripts/Spawner.gd"
class_name FinishSpawner

func finishEntered():
	var root = get_node(root_path) as Main
	root._on_Finish_body_entered()
