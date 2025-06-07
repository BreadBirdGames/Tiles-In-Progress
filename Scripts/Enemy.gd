extends KinematicBody2D

export(NodePath) var left_raycast = null
export(NodePath) var right_raycast = null
export(int) var run_speed = 100
export(int) var gravity = 1200
export(float) var death_speed = 0.4

export(NodePath) var sprite = null

var left: RayCast2D = null
var right: RayCast2D = null
var sprite_node: Sprite = null

var spawner = null

var direction = -1
var velocity = Vector2()

var dying: bool = false
var t: float = 0.0

func _ready():
	if typeof(get_node(left_raycast)) != typeof(RayCast2D):
		printerr("left_raycast is not of type RayCast2D")
		return
	left = get_node(left_raycast) as RayCast2D
	
	if typeof(get_node(right_raycast)) != typeof(RayCast2D):
		printerr("right_raycast is not of type RayCast2D")
		return
	right = get_node(right_raycast) as RayCast2D
	
	if typeof(get_node(sprite)) != typeof(Sprite):
		printerr("sprite_node is not of type Sprite")
		return
	sprite_node = get_node(sprite) as Sprite
	
	sprite_node.material.set_shader_param("progress", 0.0)

func check_if_colliding(raycast: RayCast2D):
	var body = raycast.get_collider()
	if body == null:
		return
	
	if body.is_in_group("Player"):
		body.damage()
		return
	
	direction = -1 if direction == 1 else 1
	sprite_node.flip_h = true if direction == 1 else false

func kill():
	dying = true
	t = 0.0

func _physics_process(delta):
	if dying:
		t += delta * death_speed
		sprite_node.material.set_shader_param("progress", t)
		
		if t > 1:
			spawner.kill()
			#queue_free()
		
		return

	velocity.x = 0
	
	check_if_colliding(right)
	check_if_colliding(left)
	
	velocity.x += run_speed * direction
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func drown():
	kill()
