extends CanvasLayer

enum ColorType{
	LINE,
	LINE_PLAYING,
	LINE_PLAYING_HIGHER,
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
	ColorType.LINE_PLAYING_HIGHER
]

var current_color_type:ColorType = ColorType.LINE

@onready var menu: MarginContainer = $Control/Menu
@onready var option: MarginContainer = $Control/Option
@onready var option_color: MarginContainer = $Control/OptionColor
@onready var option_volume: MarginContainer = $Control/OptionVolume
@onready var option_speed: MarginContainer = $Control/OptionSpeed
@onready var level_selection: MarginContainer = $Control/LevelSelection

@onready var texture_rect_show: TextureRect = $Control/OptionColor/PanelContainer/Control/Container/TextureRectShow

@onready var line_whole: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/LineWhole
@onready var line_fallen: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/LineFallen
@onready var line_fallen_higher: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/LineFallenHigher
@onready var wave: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/Wave
@onready var outline: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/Outline
@onready var line_playing: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/LinePlaying
@onready var line_playing_higher: TextureRect = $Control/OptionColor/PanelContainer/Control/TextureRect/LinePlayingHigher

@onready var h_slider_r: HSlider = $Control/OptionColor/PanelContainer/Control/SliderContainer/HSliderR
@onready var h_slider_g: HSlider = $Control/OptionColor/PanelContainer/Control/SliderContainer/HSliderG
@onready var h_slider_b: HSlider = $Control/OptionColor/PanelContainer/Control/SliderContainer/HSliderB
@onready var h_slider_a: HSlider = $Control/OptionColor/PanelContainer/Control/SliderContainer/HSliderA

@onready var label_play_speed: Label = $Control/OptionSpeed/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/LabelPlaySpeed
@onready var label_fall_speed: Label = $Control/OptionSpeed/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/LabelFallSpeed

@onready var button_autoplay: Button = $Control/Option/PanelContainer/HBoxContainer/VBoxContainer2/ButtonAutoplay

@onready var sound_hover: AudioStreamPlayer = $Sounds/SoundHover
@onready var sound_select: AudioStreamPlayer = $Sounds/SoundSelect
@onready var music: AudioStreamPlayer = $Sounds/Music

var dic_type_to_node:Dictionary[ColorType,TextureRect] = {}

func select_level(level_index:int)->void:
	Global.level_index = level_index
	get_tree().change_scene_to_file("res://Scene/Level/Main.tscn")
	var tween:Tween = create_tween()
	tween.tween_property(music,"volume_db",-80.0,1.0)
	await tween.finished
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	call_deferred("select_level",level_index)

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
		ColorType.LINE_PLAYING_HIGHER:line_playing_higher,
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
		ColorType.LINE_PLAYING_HIGHER:
			return SaveLoad.color_ref_array[2]
		ColorType.OUTLINE:
			return SaveLoad.color_ref_array[3]
		ColorType.RHYTHM:
			return SaveLoad.color_ref_array[4]
		ColorType.RHYTHM_HIGHER:
			return SaveLoad.color_ref_array[5]
		ColorType.WAVE:
			return SaveLoad.color_ref_array[6]
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
		ColorType.LINE_PLAYING_HIGHER:
			return line_playing_higher
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_dic()
	option_color.visible = false
	SaveLoad.load_color()
	initialize_shown_color()

func _on_button_quit_button_up() -> void:
	SaveLoad.save_color()
	sound_select.play()
	await sound_select.finished
	get_tree().quit()

func _on_button_start_button_up() -> void:
	menu.visible = false
	level_selection.visible = true
	
	sound_select.play()

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

#检测鼠标进入色块
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

func _on_line_playing_higher_mouse_entered() -> void:
	current_color_type = ColorType.LINE_PLAYING_HIGHER
	update_shown_color()

func _on_outline_mouse_entered() -> void:
	current_color_type = ColorType.OUTLINE
	update_shown_color()

func _on_line_fallen_higher_mouse_entered() -> void:
	current_color_type = ColorType.RHYTHM_HIGHER
	update_shown_color()

#悬浮音效
func _on_button_start_mouse_entered() -> void:
	sound_hover.play()

func _on_button_option_mouse_entered() -> void:
	sound_hover.play()

func _on_button_quit_mouse_entered() -> void:
	sound_hover.play()

func _on_button_back_color_mouse_entered() -> void:
	sound_hover.play()

func _on_button_back_volume_mouse_entered() -> void:
	sound_hover.play()

func _on_button_back_speed_mouse_entered() -> void:
	sound_hover.play()

func _on_button_back_level_mouse_entered() -> void:
	sound_hover.play()

func _on_button_autoplay_mouse_entered() -> void:
	sound_hover.play()

func _on_button_option_button_up() -> void:
	menu.visible = false
	option.visible = true
	
	sound_select.play()

func _on_button_volume_button_up() -> void:
	option.visible = false
	option_volume.visible = true
	
	sound_select.play()

func _on_button_color_button_up() -> void:
	option.visible = false
	option_color.visible = true
	
	sound_select.play()

func _on_button_speed_button_up() -> void:
	option.visible = false
	option_speed.visible = true
	
	sound_select.play()

func _on_button_back_button_up() -> void:
	option.visible = false
	menu.visible = true
	
	sound_select.play()

func _on_button_back_color_button_up() -> void:
	option_color.visible = false
	option.visible = true
	
	sound_select.play()

func _on_button_back_volume_button_up() -> void:
	option_volume.visible = false
	option.visible = true
	
	sound_select.play()

func _on_button_back_speed_button_up() -> void:
	option_speed.visible = false
	option.visible = true
	
	sound_select.play()

func _on_button_back_level_selection_button_up() -> void:
	level_selection.visible = false
	menu.visible = true
	
	sound_select.play()

#speed_slider
func _on_play_speed_value_changed(value: float) -> void:
	Global.play_speed = value
	label_play_speed.text = "PLAY SPEED x" + str(value)

func _on_fall_speed_value_changed(value: float) -> void:
	Global.fallen_speed_multiplier = value
	label_fall_speed.text = "FALL SPEED x" + str(value)

func _on_volume_global_value_changed(value: float) -> void:
	Global.global_volume = value - 80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Global.global_volume)

func _on_volume_flute_value_changed(value: float) -> void:
	Global.flute_volume = value - 80.0

func _on_button_level_1_button_up() -> void:
	await select_level(1)

func _on_button_level_2_button_up() -> void:
	await select_level(2)

func _on_button_level_3_button_up() -> void:
	await select_level(3)

func _on_button_level_4_button_up() -> void:
	await select_level(4)

func _on_button_level_5_button_up() -> void:
	await select_level(5)

func _on_button_level_6_button_up() -> void:
	await select_level(6)

func _on_button_level_7_button_up() -> void:
	await select_level(7)

func _on_button_level_8_button_up() -> void:
	await select_level(8)

func _on_button_level_9_button_up() -> void:
	await select_level(9)

func _on_button_autoplay_button_up() -> void:
	sound_select.play()
	if Global.auto_mode == false:
		Global.auto_mode = true
		button_autoplay.text = "AUTO:TRUE"
	else:
		Global.auto_mode = false
		button_autoplay.text = "AUTO:FALSE"
