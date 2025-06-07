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
export(PackedScene) var drag_preview = null
var modulation = []

func _ready():
	texture_node = get_node(texture_rect) as TextureRect
	
	texture_node.texture = texture
	
	match item_type:
		Items.JumpUp:
			modulation.append(Color.yellow)
		Items.SpeedUp:
			modulation.append(Color.lightblue)
		Items.Water, Items.Dirt, Items.Monster:
			modulation.append(Color.white)
			modulation.append(Color.red)

func get_drag_data(_position):
	var preview = drag_preview.instance()
	preview.prep()
	
	preview.texture_rect.texture = texture
	
	#var icon = TextureRect.new()
	#var preview = Control.new()
	#icon.expand = true
	#icon.rect_min_size = Vector2(100, 100)
	#icon.texture = texture
	#preview.add_child(icon)
	#preview.rect_min_size = Vector2(100, 100)
	set_drag_preview(preview)
	
	return { type = "DropItem", item_id = item_type, modulation = modulation }
