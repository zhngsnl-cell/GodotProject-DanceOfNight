extends Node2D

@onready var detector: Detector = $Detector
@onready var settlement: Control = $Settlement
@onready var label_score: Label = $Settlement/MarginContainer/PanelContainer/VBoxContainer/LabelScore
@onready var character: NightAnim = $Character

func set_color()->void:
	detector.line_whole.self_modulate = SaveLoad.color_line
	detector.outline.self_modulate = SaveLoad.color_outline
	detector.wave_effect_shader_material.set_shader_parameter("top_color",SaveLoad.color_wave)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_color()
	detector.send_final_point.connect(_on_send_final_point)

func _process(_delta: float) -> void:
	if detector.pressing():
		character.pressing = true
		character.play("Dance")
	else:
		character.pressing = false
		character.stop()

func _on_send_final_point(final_score:float)->void:
	if final_score >= 1.0:
		final_score = 1.0
	settlement.visible = true
	label_score.text = str(int(floorf(final_score * 100.0))) + "%"

func _on_button_retry_button_up() -> void:
	get_tree().change_scene_to_file("res://Scene/Level/Main.tscn")


func _on_button_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://Scene/UI/UIMenu.tscn")
