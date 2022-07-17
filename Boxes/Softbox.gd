extends Area2D

export var SOFT_PUSH_SPEED = 5

var soft_push = Vector2.ZERO
var entered = {}

func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area):
	var area_soft_push = area.global_position.direction_to(global_position) * SOFT_PUSH_SPEED
	soft_push += area_soft_push
	entered[area.get_path()] = area_soft_push

func _on_area_exited(area):
	var area_soft_push = entered.get(area.get_path(), Vector2.ZERO)
	soft_push -= area_soft_push
	entered[area.get_path()] = null
