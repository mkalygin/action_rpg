extends Control

export var HEART_SIZE = 15

var stats = PlayerStats
onready var empty_hearts_ui = $EmptyHeartsUI
onready var full_hearts_ui = $FullHeartsUI

func _ready():
	on_max_health_changed(stats.max_health)
	on_health_changed(stats.health)
	stats.connect("max_health_changed", self, "on_max_health_changed")
	stats.connect("health_changed", self, "on_health_changed")

func on_max_health_changed(value):
	empty_hearts_ui.rect_size.x = value * HEART_SIZE

func on_health_changed(value):
	full_hearts_ui.rect_size.x = value * HEART_SIZE
