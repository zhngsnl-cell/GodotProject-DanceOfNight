extends CanvasLayer

enum ColorType{
	LINE,
	LINE_PLAYING,
	OUTLINE,
	RHYTHM,
	RHYTHM_HIGHER,
	WAVE,
}

var current_color_type:ColorType = ColorType.LINE

@onready var menu: MarginContainer = $Control/Menu
@onready var options: MarginContainer = $Control/Options

@onready var texture_rect_show: TextureRect = $Control/Options/PanelContainer/Control/Container/TextureRectShow

@onready var line_whole: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineWhole
@onready var line_fallen: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineFallen
@onready var wave: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/Wave
@onready var line_playing: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LinePlaying


func update_shown_color()->void:
	texture_rect_show.self_modulate = return_current_color().color
	line_whole.self_modulate = SaveLoad.ref_color_line.color
	line_fallen.self_modulate = SaveLoad.ref_color_rhythm.color
	wave.self_modulate = SaveLoad.ref_color_wave.color
	line_playing.self_modulate = SaveLoad.ref_color_line_playing.color

func return_current_color()->SaveLoad.ColorRef:
	match current_color_type:
		ColorType.LINE:
			return SaveLoad.color_ref_array[0]
		ColorType.LINE_PLAYING:
			return SaveLoad.color_ref_array[1]
		ColorType.OUTLINE:
			return SaveLoad.color_ref_array[2]
		ColorType.RHYTHM:
			return SaveLoad.color_ref_array[3]
		ColorType.RHYTHM_HIGHER:
			return SaveLoad.color_ref_array[4]
		ColorType.WAVE:
			return SaveLoad.color_ref_array[5]
		_:
			return SaveLoad.ColorRef.new(Color())

func change_current_color_r(value:float)->void:
	return_current_color().color.r = value

func change_current_color_g(value:float)->void:
	return_current_color().color.g = value

func change_current_color_b(value:float)->void:
	return_current_color().color.b = value

func change_current_color_a(value:float)->void:
	return_current_color().color.a = value

func return_curren_texture() -> TextureRect:
	match current_color_type:
		ColorType.LINE:
			return line_whole
		ColorType.LINE_PLAYING:
			return line_playing
		ColorType.OUTLINE:
			return null
		ColorType.RHYTHM:
			return line_fallen
		ColorType.RHYTHM_HIGHER:
			return null
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
	current_color_type = ColorType.LINE_PLAYING
	update_shown_color()
