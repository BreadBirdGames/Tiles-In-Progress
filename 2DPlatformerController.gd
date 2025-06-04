extends KinematicBody2D

onready var jump_press_timer = $Timers/JumpPressTimer
onready var ground_timer = $Timers/GroundedTimer
onready var sprite_mat: Material = $Sprite.material

#Motion Variables
export(float) var speed = 25.0
export(float) var max_speed = 250.0
export(float, 0.0, 1.0, 0.01) var damping = 0.88
export(float) var gravity = 18.0
export(float) var min_jump_speed = -10
export(float) var jump_speed = -500
export(float) var death_speed = 0.4
var jumped : bool = false
var motion := Vector2.ZERO

#Scale Variables
var current_direction : int = 1

var dying: bool = false
var t: float = 0.0

func kill():
	dying = true
	t = 0.0

func _physics_process(delta):
	if dying:
		t += delta * death_speed
		sprite_mat.set_shader_param("progress", t)
		
		if t > 1:
			queue_free()
		
		return
	
	#Input----------------------------------------------
	if Input.is_action_just_pressed("mo_jump"):
		jump_press_timer.start()
	
	#Motion-------------------------------------------
	
	#Horizontal
	var xaxis = int(Input.is_action_pressed("mo_right")) - int(Input.is_action_pressed("mo_left"))
	motion.x = clamp(motion.x + (xaxis * speed), -max_speed, max_speed)
	
	#Changing Body
	if xaxis != 0:
		#Changing Direction
		current_direction = xaxis
		$Sprite.scale.x = xaxis
	
	#Vertical
	if is_on_floor():
		#Set Grounded Timer
		$Timers/GroundedTimer.start()
		
		#Reset Jumped
		jumped = false
	else:
		#Falling
		motion.y += gravity
	
	#Jumping
	if !jump_press_timer.is_stopped() && !ground_timer.is_stopped():
		#Set Motion
		motion.y = jump_speed
		jumped = true
		
		#Stop Timers
		jump_press_timer.stop()
		ground_timer.stop()
	
	#Min Jump Speed
	if Input.is_action_just_released("mo_jump") && jumped:
		motion.y = max(min_jump_speed, motion.y)
	
	#Move
	motion = move_and_slide(motion, Vector2.UP)
	
	#Damping
	if xaxis == 0: motion.x *= damping
