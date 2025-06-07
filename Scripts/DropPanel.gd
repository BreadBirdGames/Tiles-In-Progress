extends Control

export(NodePath) var camera = null
var camera_node: Camera2D = null

export(NodePath) var tilemap = null
var tilemap_node: TileMap = null

export(NodePath) var top_grid = null
var top_grid_node: Node2D = null

export(NodePath) var bottom_grid = null
var bottom_grid_node: Node2D = null

export(NodePath) var player_drop_zone = null
var player_drop_zone_node: DropZone = null

export(Array, NodePath) var drop_sprites = []
var drop_sprite_nodes = []

export var dirt_tile_index = 0
export var grass_tile_index = 1
export var occupied_tile_index = 2
export(PackedScene) var water_tile = null
export(PackedScene) var enemy = null

onready var global_data = get_node("/root/GlobalData")

func _ready():
	camera_node = get_node(camera) as Camera2D
	tilemap_node = get_node(tilemap) as TileMap
	
	top_grid_node = get_node(top_grid) as Node2D
	top_grid_node.hide()
	
	bottom_grid_node = get_node(bottom_grid) as Node2D
	bottom_grid_node.hide()
	
	player_drop_zone_node = get_node(player_drop_zone) as DropZone
	
	var index = 0
	for sprite in drop_sprites:
		drop_sprite_nodes.append(get_node(sprite) as Sprite)
		drop_sprite_nodes[index].hide()
		index += 1

func get_current_tile_pos():
	var global_position = camera_node.get_global_mouse_position()
	return tilemap_node.world_to_map(global_position)

func can_drop_data(at_position, data):
	if data.type != "DropItem":
		return false
	
	var tilemap_position = get_current_tile_pos()
	
	match data.item_id:
		DragItem.Items.Water:
			bottom_grid_node.show()
			
			if tilemap_position.y < 0:
				bottom_grid_node.modulate = data.modulation[1]
				return false
			else:
				bottom_grid_node.modulate = data.modulation[0]
		DragItem.Items.Dirt, DragItem.Items.Monster:
			top_grid_node.show()
			
			if tilemap_position.y > -1:
				top_grid_node.modulate = data.modulation[1]
				return false
			else:
				top_grid_node.modulate = data.modulation[0]
			
		DragItem.Items.JumpUp, DragItem.Items.SpeedUp:
			for sprite in drop_sprite_nodes:
					sprite.show()
					sprite.modulate = data.modulation[0]
			
			if not player_drop_zone_node.position_inside(get_global_mouse_position()):
				return false
	
	if tilemap_node.get_cellv(tilemap_position) == occupied_tile_index:
		return false
	
	return true

func drop_data(_at_position, data):
	var tilemap_position = get_current_tile_pos()
	
	match data.item_id:
		DragItem.Items.Dirt:
			tilemap_node.set_cellv(tilemap_position, dirt_tile_index)
			
			if tilemap_node.get_cellv(tilemap_position + Vector2(0, 1)) == grass_tile_index:
				tilemap_node.set_cellv(tilemap_position + Vector2(0, 1), dirt_tile_index)
			
			tilemap_node.update_dirty_quadrants()
			continue
		DragItem.Items.Water:
			var tile = water_tile.instance()
			tile.global_position = tilemap_node.map_to_world(tilemap_position)
			tilemap_node.set_cellv(tilemap_position, -1)
			tilemap_node.add_child(tile)
			continue
		DragItem.Items.Monster:
			var tile = enemy.instance()
			tile.global_position = tilemap_node.map_to_world(tilemap_position)
			tilemap_node.set_cellv(tilemap_position, occupied_tile_index)
			tilemap_node.add_child(tile)
			continue
		DragItem.Items.JumpUp:
			global_data.stats.DispJumpMult += 1
			global_data.stats.JumpMult += 0.5
			continue
		DragItem.Items.SpeedUp:
			global_data.stats.SpeedMult += 1
			continue
		DragItem.Items.None:
			continue
		_:
			continue

func _notification(what):
	#if what == NOTIFICATION_DRAG_BEGIN:
	if what == NOTIFICATION_DRAG_END:
		top_grid_node.hide()
		bottom_grid_node.hide()
		
		for sprite in drop_sprite_nodes:
			sprite.hide()
