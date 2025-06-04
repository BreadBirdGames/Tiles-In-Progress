extends Node2D

export(PackedScene) var entity = null
export var offset: Vector2 = Vector2(0, 0)
onready var spawner_list = get_node("/root/SpawnerList")
onready var sprite: Sprite = $Sprite
var spawned

func _ready():
	spawner_list.spawners.append(self)

func spawn():
	spawned = entity.instance()
	spawned.global_position = global_position + offset
	
	
	get_parent().add_child(spawned)
	sprite.visible = false

func despawn():
	sprite.visible = true
	spawned.kill()
	#spawned.queue_free()
