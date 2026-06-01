extends Node2D

@onready var detector: Detector = $Detector
@onready var settlement: Control = $Settlement
@onready var label_score: Label = $Settlement/MarginContainer/PanelContainer/VBoxContainer/LabelScore
@onready var character: NightAnim = $Character
@onready var background: TextureRect = $Background

@onready var sound_hover: AudioStreamPlayer = $Sounds/SoundHover
@onready var sound_select: AudioStreamPlayer = $Sounds/SoundSelect
@onready var sound_applaud: AudioStreamPlayer = $Sounds/SoundApplaud

func set_color()->void:
	detector.line_whole.self_modulate = SaveLoad.ref_color_line.color
	detector.line_playing.self_modulate = SaveLoad.ref_color_line_playing.color
	detector.outline.self_modulate = SaveLoad.ref_color_outline.color
	detector.wave_effect_shader_material.set_shader_parameter("top_color",SaveLoad.ref_color_wave.color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	set_color()
	detector.auto_mode = Global.auto_mode
	background.texture = Global.background_list[Global.level_index - 1]
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
	sound_applaud.play()

func _on_button_retry_button_up() -> void:
	sound_select.play()
	await sound_select.finished
	get_tree().reload_current_scene()

func _on_button_menu_button_up() -> void:
	sound_select.play()
	await sound_select.finished
	get_tree().change_scene_to_file("res://Scene/UI/UIMenu.tscn")

func _on_button_retry_mouse_entered() -> void:
	sound_hover.play()

func _on_button_menu_mouse_entered() -> void:
	sound_hover.play()
