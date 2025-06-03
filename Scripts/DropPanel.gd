extends Control

export(NodePath) var camera = null
var camera_node: Camera2D = null

export(NodePath) var tilemap = null
var tilemap_node: TileMap = null

export var dirt_tile_index = 0
export var water_tile_index = 2

func _ready():
	if typeof(get_node(camera)) != typeof(Camera2D):
		printerr("camera_node = is not of type Camera2D")
		return
	
	camera_node = get_node(camera) as Camera2D
	
	if typeof(get_node(tilemap)) != typeof(TileMap):
		printerr("tilemap_node = is not of type TileMap")
		return
	
	tilemap_node = get_node(tilemap) as TileMap

func can_drop_data(at_position, data):
	return data.type == "DropItem"

func drop_data(at_position, data):
	var global_position = camera_node.get_global_mouse_position()
	var tilemap_position = tilemap_node.world_to_map(global_position)
	
	match data.item_id:
		DragItem.Items.Dirt:
			tilemap_node.set_cell(tilemap_position.x, tilemap_position.y, dirt_tile_index)
			continue
		DragItem.Items.Water:
			tilemap_node.set_cell(tilemap_position.x, tilemap_position.y, water_tile_index)
			continue
		DragItem.Items.Monster:
			tilemap_node.set_cell(tilemap_position.x, tilemap_position.y, water_tile_index)
			continue
		DragItem.Items.None:
			continue
		_:
			continue
