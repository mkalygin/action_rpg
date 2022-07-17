extends Area2D

export(float) var HIT_TIMEOUT = 0.7
export(bool) var ANIMATE_HIT = true
export(Vector2) var HIT_CENTER = Vector2.ZERO

var HitEffect = preload("res://Effects/HitEffect.tscn")
var entered = {}

signal hit(area)

func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area):
	var timer = Timer.new()
	entered[area.get_path()] = timer
	add_child(timer)
	inflict_hit(area)

func _on_area_exited(area):
	var timer = entered.get(area.get_path(), null)
	
	if not timer: return
	
	entered[area.get_path()] = null
	remove_child(timer)

func inflict_hit(area):
	var timer = entered.get(area.get_path(), null)
	
	if not timer: return

	emit_signal("hit", area)
	
	if ANIMATE_HIT: create_hit_effect()
	
	timer.set_wait_time(HIT_TIMEOUT)
	timer.set_one_shot(true)
	timer.start()

	yield(timer, "timeout")
	inflict_hit(area)

func create_hit_effect():
	var effect = HitEffect.instance()
	var world = get_tree().current_scene
	
	world.add_child(effect)
	effect.global_position = global_position + HIT_CENTER
