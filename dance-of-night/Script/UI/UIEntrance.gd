extends CanvasLayer

enum ColorType{
	LINE,
	OUTLINE,
	RHYTHM,
	WAVE,
}

var current_color_type:ColorType = ColorType.LINE

@onready var menu: MarginContainer = $Control/Menu
@onready var options: MarginContainer = $Control/Options

@onready var texture_rect_show: TextureRect = $Control/Options/PanelContainer/Control/Container/TextureRectShow

@onready var line_whole: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineWhole
@onready var line_fallen: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineFallen
@onready var wave: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/Wave
@onready var outline: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/Outline

func update_shown_color()->void:
	texture_rect_show.self_modulate = return_current_color()
	line_whole.self_modulate = SaveLoad.color_line
	line_fallen.self_modulate = SaveLoad.color_rhythm
	wave.self_modulate = SaveLoad.color_wave
	outline.self_modulate = SaveLoad.color_outline

func return_current_color()->Color:
	match current_color_type:
		ColorType.LINE:
			return SaveLoad.color_line
		ColorType.OUTLINE:
			return SaveLoad.color_outline
		ColorType.RHYTHM:
			return SaveLoad.color_rhythm
		ColorType.WAVE:
			return SaveLoad.color_wave
		_:
			return Color()

func change_current_color_r(value:float)->void:
	match current_color_type:
		ColorType.LINE:
			SaveLoad.color_line.r = value
		ColorType.OUTLINE:
			SaveLoad.color_outline.r = value
		ColorType.RHYTHM:
			SaveLoad.color_rhythm.r = value
		ColorType.WAVE:
			SaveLoad.color_wave.r = value

func change_current_color_g(value:float)->void:
	match current_color_type:
		ColorType.LINE:
			SaveLoad.color_line.g = value
		ColorType.OUTLINE:
			SaveLoad.color_outline.g = value
		ColorType.RHYTHM:
			SaveLoad.color_rhythm.g = value
		ColorType.WAVE:
			SaveLoad.color_wave.g = value

func change_current_color_b(value:float)->void:
	match current_color_type:
		ColorType.LINE:
			SaveLoad.color_line.b = value
		ColorType.OUTLINE:
			SaveLoad.color_outline.b = value
		ColorType.RHYTHM:
			SaveLoad.color_rhythm.b = value
		ColorType.WAVE:
			SaveLoad.color_wave.b = value

func change_current_color_a(value:float)->void:
	match current_color_type:
		ColorType.LINE:
			SaveLoad.color_line.a = value
		ColorType.OUTLINE:
			SaveLoad.color_outline.a = value
		ColorType.RHYTHM:
			SaveLoad.color_rhythm.a = value
		ColorType.WAVE:
			SaveLoad.color_wave.a = value

func return_curren_texture() -> TextureRect:
	match current_color_type:
		ColorType.LINE:
			return line_whole
		ColorType.OUTLINE:
			return outline
		ColorType.RHYTHM:
			return line_fallen
		ColorType.WAVE:
			return wave
		_:
			return null

func go_to_main_scene()->void:
	get_tree().change_scene_to_file("res://Scene/Level/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options.visible = false
	SaveLoad.load_color()

func _on_button_quit_button_up() -> void:
	SaveLoad.save_color()
	get_tree().quit()

func _on_button_start_button_up() -> void:
	call_deferred("go_to_main_scene")

func _on_button_option_button_up() -> void:
	update_shown_color()
	menu.visible = false
	options.visible = true

func _on_button_back_button_up() -> void:
	SaveLoad.save_color()
	options.visible = false
	menu.visible = true

func _on_h_slider_r_value_changed(value: float) -> void:
	change_current_color_r(value)
	return_curren_texture().self_modulate.r = value
	update_shown_color()

func _on_h_slider_g_value_changed(value: float) -> void:
	change_current_color_g(value)
	return_curren_texture().self_modulate.g = value
	update_shown_color()

func _on_h_slider_b_value_changed(value: float) -> void:
	change_current_color_b(value)
	return_curren_texture().self_modulate.b = value
	update_shown_color()

func _on_h_slider_a_value_changed(value: float) -> void:
	change_current_color_a(value)
	return_curren_texture().self_modulate.a = value
	update_shown_color()

func _on_line_whole_mouse_entered() -> void:
	current_color_type = ColorType.LINE
	update_shown_color()

func _on_line_fallen_mouse_entered() -> void:
	current_color_type = ColorType.RHYTHM
	update_shown_color()

func _on_wave_mouse_entered() -> void:
	current_color_type = ColorType.WAVE
	update_shown_color()

func _on_outline_mouse_entered() -> void:
	current_color_type = ColorType.OUTLINE
	update_shown_color()
