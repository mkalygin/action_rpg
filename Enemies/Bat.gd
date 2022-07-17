extends KinematicBody2D

export var MAX_SPEED = 50
export var ACCELERATION = 5
export var FRICTION = 25
export var KNOCKBACK_SPEED = 150
export var KNOCKBACK_FRICTION = 5

enum State {
	IDLE
	WANDER
	CHASE
}

var EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
var state = State.IDLE
var velocity = Vector2.ZERO
var target = null
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var animated_sprite = $AnimatedSprite
onready var softbox = $Softbox
onready var wander_controller = $WanderController

func _process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION)
	knockback = move_and_slide(knockback)
	
	match state:
		State.IDLE: idle()
		State.WANDER: wander()
		State.CHASE: chase()
	
	velocity += softbox.soft_push
	velocity = move_and_slide(velocity)
	animated_sprite.flip_h = velocity.x < 0

func idle():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	if velocity == Vector2.ZERO:
		wander_controller.start()
	
	if not wander_controller.is_waiting and wander_controller.is_active:
		state = State.WANDER

func wander():
	var diff = global_position.direction_to(wander_controller.target_position)
	velocity = velocity.move_toward(diff * MAX_SPEED, ACCELERATION)
	
	# We're stuck and want to change the target position.
	if get_slide_count() > 0:
		wander_controller.update_target_position()
	
	if not wander_controller.is_active or get_slide_count() > 0:
		state = State.IDLE

func chase():
	var diff = (target.global_position - global_position).normalized()
	velocity = velocity.move_toward(diff * MAX_SPEED, ACCELERATION)

func random_state(states):
	return states[randi() % states.size()]

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = (global_position - area.global_position).normalized() * KNOCKBACK_SPEED

func _on_Stats_death():
	var enemy_death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
	queue_free()

func _on_Aggrobox_body_entered(body):
	if state == State.CHASE: return
	
	target = body
	state = State.CHASE

func _on_Aggrobox_body_exited(body):
	if state != State.CHASE: return
	
	target = null
	state = State.IDLE
