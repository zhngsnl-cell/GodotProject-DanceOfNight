extends CanvasLayer

@onready var menu: MarginContainer = $Control/Menu
@onready var options: MarginContainer = $Control/Options

@onready var color_picker_line: ColorPickerButton = $Control/Options/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/ColorPickerLine
@onready var color_picker_outline: ColorPickerButton = $Control/Options/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/ColorPickerOutline
@onready var color_picker_rhythm: ColorPickerButton = $Control/Options/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/ColorPickerRhythm
@onready var color_picker_wave: ColorPickerButton = $Control/Options/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/ColorPickerWave

func go_to_main_scene()->void:
	get_tree().change_scene_to_file("res://Scene/Level/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options.visible = false
	SaveLoad.load_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_quit_button_up() -> void:
	SaveLoad.save_color()
	get_tree().quit()

func _on_button_start_button_up() -> void:
	call_deferred("go_to_main_scene")

func _on_button_option_button_up() -> void:
	color_picker_line.color = SaveLoad.color_line
	color_picker_outline.color = SaveLoad.color_outline
	color_picker_rhythm.color = SaveLoad.color_rhythm
	color_picker_wave.color = SaveLoad.color_wave
	menu.visible = false
	options.visible = true

func _on_button_back_button_up() -> void:
	SaveLoad.save_color()
	options.visible = false
	menu.visible = true

func _on_color_picker_line_color_changed(color: Color) -> void:
	SaveLoad.color_line = color

func _on_color_picker_outline_color_changed(color: Color) -> void:
	SaveLoad.color_outline = color

func _on_color_picker_rhythm_color_changed(color: Color) -> void:
	SaveLoad.color_rhythm = color

func _on_color_picker_wave_color_changed(color: Color) -> void:
	SaveLoad.color_wave = color
