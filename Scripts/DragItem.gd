extends Panel
class_name DragItem

enum Items {
	None,
	Dirt,
	Water,
	Monster,
	SpeedUp,
	JumpUp
}

export(Items) var item_type
export var texture: Texture = null
export(NodePath) var texture_rect = null
var texture_node: TextureRect = null

func _ready():
	if typeof(get_node(texture_rect)) != typeof(TextureRect):
		printerr("texture_node is not of type TextureRect")
		return
	texture_node = get_node(texture_rect) as TextureRect
	
	texture_node.texture = texture

func get_drag_data(position):
	var icon = TextureRect.new()
	var preview = Control.new()
	icon.expand = true
	icon.rect_min_size = Vector2(100, 100)
	icon.texture = texture
	#icon.rect_position = icon.texture.get_size() * -0.5
	preview.add_child(icon)
	preview.rect_min_size = Vector2(100, 100)
	#preview.z_index = 60
	set_drag_preview(preview)
	return { type = "DropItem", item_id = item_type }

func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	print(data)
