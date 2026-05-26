extends CanvasLayer

enum ColorType{
	LINE,
	LINE_PLAYING,
	OUTLINE,
	RHYTHM,
	RHYTHM_HIGHER,
	WAVE,
}

const ColorTypeArray:Array[ColorType] = [
	ColorType.LINE,
	ColorType.RHYTHM,
	ColorType.RHYTHM_HIGHER,
	ColorType.WAVE,
	ColorType.OUTLINE,
	ColorType.LINE_PLAYING,
]

var current_color_type:ColorType = ColorType.LINE

@onready var menu: MarginContainer = $Control/Menu
@onready var options: MarginContainer = $Control/Options

@onready var texture_rect_show: TextureRect = $Control/Options/PanelContainer/Control/Container/TextureRectShow

@onready var line_whole: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineWhole
@onready var line_fallen: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineFallen
@onready var line_fallen_higher: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LineFallenHigher
@onready var wave: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/Wave
@onready var outline: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/Outline
@onready var line_playing: TextureRect = $Control/Options/PanelContainer/Control/TextureRect/LinePlaying

@onready var h_slider_r: HSlider = $Control/Options/PanelContainer/Control/SliderContainer/HSliderR
@onready var h_slider_g: HSlider = $Control/Options/PanelContainer/Control/SliderContainer/HSliderG
@onready var h_slider_b: HSlider = $Control/Options/PanelContainer/Control/SliderContainer/HSliderB
@onready var h_slider_a: HSlider = $Control/Options/PanelContainer/Control/SliderContainer/HSliderA

var dic_type_to_node:Dictionary[ColorType,TextureRect] = {}

func initialize_shown_color()->void:
	for i:ColorType in ColorTypeArray:
		current_color_type = i
		update_shown_color()

func initialize_dic()->void:
	#先布置节点后执行ready函数，所以放到_ready函数内
	dic_type_to_node = {
		ColorType.LINE:line_whole,
		ColorType.RHYTHM:line_fallen,
		ColorType.RHYTHM_HIGHER:line_fallen_higher,
		ColorType.WAVE:wave,
		ColorType.OUTLINE:outline,
		ColorType.LINE_PLAYING:line_playing,
	}

func update_shown_color()->void:
	texture_rect_show.self_modulate = return_current_color().color
	dic_type_to_node[current_color_type].self_modulate = return_current_color().color
	h_slider_r.set_value_no_signal(return_current_color().color.r)
	h_slider_g.set_value_no_signal(return_current_color().color.g)
	h_slider_b.set_value_no_signal(return_current_color().color.b)
	h_slider_a.set_value_no_signal(return_current_color().color.a)

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
			return outline
		ColorType.RHYTHM:
			return line_fallen
		ColorType.RHYTHM_HIGHER:
			return line_fallen_higher
		ColorType.WAVE:
			return wave
		_:
			return null

func go_to_main_scene()->void:
	get_tree().change_scene_to_file("res://Scene/Level/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_dic()
	options.visible = false
	SaveLoad.load_color()
	initialize_shown_color()

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

func _on_line_playing_mouse_entered() -> void:
	current_color_type = ColorType.LINE_PLAYING
	update_shown_color()

func _on_outline_mouse_entered() -> void:
	current_color_type = ColorType.OUTLINE
	update_shown_color()

func _on_line_fallen_higher_mouse_entered() -> void:
	current_color_type = ColorType.RHYTHM_HIGHER
	update_shown_color()
