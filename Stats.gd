extends Node

export(int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

signal death
signal max_health_changed(value)
signal health_changed(value)

func set_max_health(value):
	max_health = max(value, 1)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health == 0: emit_signal("death")
