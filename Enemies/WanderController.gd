extends Node2D

export(float) var DISTANCE_RANGE = 32.0
export(float) var TIMEOUT_RANGE = 3.0
export(float) var DISTANCE_DELTA = 1.0

var is_active = false
var is_waiting = false
onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func _process(_delta):
	is_active = global_position.distance_to(target_position) > DISTANCE_DELTA

func start():
	if is_active: return
	
	is_waiting = true

	update_target_position()
	timer.start(rand_range(0, TIMEOUT_RANGE))

func update_target_position():
	target_position = start_position - Vector2(
		rand_range(-DISTANCE_RANGE, DISTANCE_RANGE),
		rand_range(-DISTANCE_RANGE, DISTANCE_RANGE)
	)

func _on_Timer_timeout():
	is_waiting = false
