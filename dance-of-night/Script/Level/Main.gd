extends Node2D

@onready var detector: Detector = $Detector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector.send_final_point.connect(_on_send_final_point)

func _on_send_final_point(final_score:float)->void:
	print(final_score)
