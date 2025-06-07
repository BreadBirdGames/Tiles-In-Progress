extends Camera2D
class_name CustomCamera

export(float) var speed: float = 10.0
export(float) var limit_left_pos: float = 0.0
export(float) var limit_right_pos: float = 0.0

onready var limit_left_node = get_parent().get_node("LimitLeft")
onready var limit_right_node = get_parent().get_node("LimitRight")
onready var limit_up_node = get_parent().get_node("LimitUp")
onready var limit_down_node = get_parent().get_node("LimitDown")

func _ready():
	limit_left = limit_left_node.position.x
	limit_right = limit_right_node.position.x
	limit_top = limit_up_node.position.y
	limit_bottom = limit_down_node.position.y
	position = Vector2.ZERO

export var FOLLOW_SPEED: float  = 4.0
export var ZOOM_SPEED: float  = 0.1
onready var target = Vector2.ZERO
var target_zoom = Vector2.ONE * 5

func change_follow(target, target_zoom: Vector2):
	self.target = target
	self.target_zoom = target_zoom

func _physics_process(delta):
	#print(target)
	#print(is_instance_valid(target))
	
	if is_instance_valid(target):
		global_position = global_position.linear_interpolate(target.global_position, delta * FOLLOW_SPEED)
	elif target is Vector2:
		position = position.linear_interpolate(target, delta * FOLLOW_SPEED)
	
	zoom = zoom.linear_interpolate(target_zoom, delta * ZOOM_SPEED)

func move_x(direction: int):
	if target is Vector2:
		# Move and clamp target.x
		position.x += speed * direction
		position.x = clamp(position.x, limit_left_pos, limit_right_pos)
		target.x += speed * direction
		target.x = clamp(target.x, limit_left_pos, limit_right_pos)

