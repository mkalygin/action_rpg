extends Camera2D

onready var top_left = $Limits/TopLeft.position
onready var bottom_right = $Limits/BottomRight.position

func _ready():
	limit_bottom = bottom_right.y
	limit_left = top_left.x
	limit_right = bottom_right.x
	limit_top = top_left.y
