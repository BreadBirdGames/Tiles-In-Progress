extends Camera2D
class_name CustomCamera

onready var limit_left_node = get_parent().get_node("LimitLeft")
onready var limit_right_node = get_parent().get_node("LimitRight")
onready var limit_up_node = get_parent().get_node("LimitUp")
onready var limit_down_node = get_parent().get_node("LimitDown")

func _ready():
	limit_left = limit_left_node.position.x
	limit_right = limit_right_node.position.x
	limit_top = limit_up_node.position.y
	limit_bottom = limit_down_node.position.y

export var FOLLOW_SPEED: float  = 4.0
export var ZOOM_SPEED: float  = 0.1
onready var target = null
var target_zoom = Vector2.ONE * 5

func change_follow(target, target_zoom: Vector2):
	self.target = target
	self.target_zoom = target_zoom

func _physics_process(delta):
	if is_instance_valid(target):
		global_position = global_position.linear_interpolate(target.global_position, delta * FOLLOW_SPEED)
	elif target == null:
		position = position.linear_interpolate(Vector2.ZERO, delta * FOLLOW_SPEED)
	
	zoom = zoom.linear_interpolate(target_zoom, delta * ZOOM_SPEED)
