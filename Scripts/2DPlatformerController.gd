extends KinematicBody2D

onready var global_data = get_node("/root/GlobalData")

onready var jump_press_timer = $Timers/JumpPressTimer
onready var ground_timer = $Timers/GroundedTimer
onready var sprite: Sprite = $Sprite

#Motion Variables
export(float) var speed = 25.0
export(float) var max_speed = 250.0
export(float) var damping = 0.88
export(float) var gravity = 18.0
export(float) var min_jump_speed = -10
export(float) var jump_speed = -500
export(float) var death_speed = 0.4
var jumped : bool = false
var motion := Vector2.ZERO
var root: Main = null
var spawner = null

#Scale Variables
var current_direction : int = 1

var dying: bool = false
var t: float = 0.0

var start_ground_time = 0
var start_jump_time = 0
var o_damping = 0.0
var o_max_speed = 0.0
var o_speed = 0.0
var o_jump_speed = 0
var o_gravity = 0

func _ready():
	sprite.material.set_shader_param("progress", 0.0)
	
	start_ground_time = ground_timer.wait_time
	start_jump_time = jump_press_timer.wait_time
	o_damping = damping
	o_max_speed = max_speed
	o_speed = speed
	o_gravity = gravity
	stats_changed()

func stats_changed():
	#speed = o_speed * global_data.stats.SpeedMult
	max_speed = o_max_speed * global_data.stats.SpeedMult
	#damping = o_damping * global_data.stats.SpeedMult
	gravity = o_gravity * global_data.stats.SpeedMult
	ground_timer.wait_time = start_ground_time * global_data.stats.JumpMult
	jump_press_timer.wait_time = start_jump_time * global_data.stats.JumpMult
	#jump_speed = o_jump_speed * global_data.stats.JumpMult

func drown():
	root.switch_play_mode(true)
	kill()

func kill():
	dying = true
	t = 0.0

func _physics_process(delta):
	if dying:
		t += delta * death_speed
		sprite.material.set_shader_param("progress", t)
		
		if t > 1:
			spawner.kill()
			#queue_free()
		
		return
	
	#Input----------------------------------------------
	if Input.is_action_just_pressed("mo_jump"):
		jump_press_timer.start()
	
	#Motion-------------------------------------------
	
	#Horizontal
	var xaxis = int(Input.is_action_pressed("mo_right")) - int(Input.is_action_pressed("mo_left"))
	motion.x = clamp(motion.x + (xaxis * speed * global_data.stats.SpeedMult), -max_speed, max_speed)
	
	#Changing Body
	if xaxis != 0:
		#Changing Direction
		current_direction = xaxis
		sprite.scale.x = xaxis
	
	#Vertical
	if is_on_floor():
		#Set Grounded Timer
		ground_timer.start()
		
		#Reset Jumped
		jumped = false
	else:
		#Falling
		motion.y += gravity
	
	#Jumping
	if !jump_press_timer.is_stopped() && !ground_timer.is_stopped():
		#Set Motion
		motion.y = jump_speed * global_data.stats.JumpMult
		jumped = true
		
		#Stop Timers
		jump_press_timer.stop()
		ground_timer.stop()
	
	#Min Jump Speed
	if Input.is_action_just_released("mo_jump") && jumped:
		motion.y = max(min_jump_speed * global_data.stats.JumpMult, motion.y)
	
	#Move
	motion = move_and_slide(motion, Vector2.UP)
	
	#Damping
	if xaxis == 0: motion.x *= damping
