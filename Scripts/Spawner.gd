extends Node2D

export(PackedScene) var entity = null
export var offset: Vector2 = Vector2(0, 0)
onready var sprite: Sprite = $Sprite
export(String) var entity_name: String = ""
var spawned

export(NodePath) var root_path = null

func spawn():
	if is_instance_valid(spawned):
		spawned.queue_free()
		yield(spawned, "tree_exited")
	
	spawned = entity.instance()
	spawned.global_position = global_position + offset
	
	if entity_name != "":
		spawned.name = entity_name
	
	if root_path != null:
		spawned.root = get_node(root_path) as Main
	
	spawned.spawner = self
	get_parent().add_child(spawned)
	sprite.visible = false
	
	return spawned

func kill():
	spawned.queue_free()
	yield(spawned, "tree_exited")
	spawned = null

func despawn():
	sprite.visible = true
	if spawned != null:
		spawned.kill()
