extends KinematicBody2D

export var MAX_SPEED = 100
export var ROLL_SPEED = 125
export var ACCELERATION = 10
export var FRICTION = 10

const Animation = {
	"IDLE": "Idle",
	"RUN": "Run",
	"ROLL": "Roll",
	"ATTACK": "Attack"
}

enum State {
	MOVE
	ROLL
	ATTACK
}

var state = State.MOVE
var velocity = Vector2.ZERO
var diff = Vector2.ZERO
var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")

func _ready():
	stats.connect("death", self, "_on_PlayerStats_death")
	animation_tree.active = true

func _process(_delta):
	match state:
		State.MOVE: move()
		State.ATTACK: attack()
		State.ROLL: roll()

func move():
	diff = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if diff != Vector2.ZERO:
		animation_tree.set("parameters/%s/blend_position" % Animation.IDLE, diff)
		animation_tree.set("parameters/%s/blend_position" % Animation.RUN, diff)
		animation_tree.set("parameters/%s/blend_position" % Animation.ROLL, diff)
		animation_tree.set("parameters/%s/blend_position" % Animation.ATTACK, diff)
		animation_state.travel(Animation.RUN)
		velocity = velocity.move_toward(diff * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel(Animation.IDLE)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK
	
	if Input.is_action_just_pressed("roll"):
		state = State.ROLL

func roll():
	velocity = diff * ROLL_SPEED
	velocity = move_and_slide(velocity)
	animation_state.travel(Animation.ROLL)

func attack():
	velocity = Vector2.ZERO
	animation_state.travel(Animation.ATTACK)

func roll_animation_finished():
	velocity = velocity.normalized() * MAX_SPEED
	state = State.MOVE

func attack_animation_finished():
	state = State.MOVE

func _on_Hurtbox_hit(area):
	stats.health -= area.damage

func _on_PlayerStats_death():
	queue_free()
