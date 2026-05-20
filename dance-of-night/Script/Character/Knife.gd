extends Area2D

var speed:float = 100.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.x += speed * delta
