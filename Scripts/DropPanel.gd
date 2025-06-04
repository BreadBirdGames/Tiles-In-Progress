extends Control

export(NodePath) var camera = null
var camera_node: Camera2D = null

export(NodePath) var tilemap = null
var tilemap_node: TileMap = null

export(NodePath) var grid = null
var grid_node: Node2D = null

export var dirt_tile_index = 0
export var occupied_tile_index = 2
export(PackedScene) var water_tile = null
export(PackedScene) var enemy = null

func _ready():
	rect_size = Vector2(0,0)
	
	if typeof(get_node(camera)) != typeof(Camera2D):
		printerr("camera_node = is not of type Camera2D")
		return
	camera_node = get_node(camera) as Camera2D
	
	if typeof(get_node(tilemap)) != typeof(TileMap):
		printerr("tilemap_node = is not of type TileMap")
		return
	tilemap_node = get_node(tilemap) as TileMap
	
	if typeof(get_node(grid)) != typeof(Node2D):
		printerr("grid_node = is not of type Node2D")
		return
	grid_node = get_node(grid) as Node2D
	grid_node.hide()

func get_current_tile_pos():
	var global_position = camera_node.get_global_mouse_position()
	return tilemap_node.world_to_map(global_position)

func can_drop_data(_at_position, data):
	if data.type != "DropItem":
		return false
	
	var tilemap_position = get_current_tile_pos()
	
	if data.item_id == DragItem.Items.Water:
		if tilemap_position.y < 0:
			return false
	else:
		if tilemap_position.y > -1:
			return false
	
	if tilemap_node.get_cellv(tilemap_position) == occupied_tile_index:
		return false
	
	return true

func drop_data(_at_position, data):
	var tilemap_position = get_current_tile_pos()
	
	match data.item_id:
		DragItem.Items.Dirt:
			tilemap_node.set_cellv(tilemap_position, dirt_tile_index)
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
		DragItem.Items.None:
			continue
		_:
			continue

func _notification(what):
	if what == NOTIFICATION_DRAG_BEGIN:
		grid_node.show()
	elif what == NOTIFICATION_DRAG_END:
		grid_node.hide()
