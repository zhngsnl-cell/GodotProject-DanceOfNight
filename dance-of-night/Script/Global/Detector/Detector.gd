class_name Detector extends Node

const line_position:Vector2 = Vector2(240.0,200.0)
const pitch_scale:Array[float] = [
	1.0,
	1.122,
	1.259,
	1.414,
	1.587,
	1.781,
	2.0,
	2.244,
]
const pitch_scale_higher:Array[float] = [
	2.519,
	2.828,
	3.174,
	3.563,
	4.0,
	4.489,
	5.039,
	5.656,
]
const pitch_position:Array[Vector2] = [
	Vector2(135.0,200.0),
	Vector2(165.0,200.0),
	Vector2(195.0,200.0),
	Vector2(225.0,200.0),
	Vector2(255.0,200.0),
	Vector2(285.0,200.0),
	Vector2(315.0,200.0),
	Vector2(345.0,200.0),
]

var game_is_end:bool = false
var fallen_line_entering:bool = false
var higher_mode:bool = false

var playing_pitch:int
var current_pitch:int = 0
var last_pitch:int = 0
var music_score_pitch:int

var rhythm_index:int = 0
var rhythm_amount:int = 0
var fallen_line_index:int = 0

var playing_speed:float = 1.0
var fallen_speed:float = 1.0

var completed_time:float = 0.0
var progress:float = 0.0

var pitch_state:Array[bool] = [
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
]
var pitch_rank:Array[int] = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
]

var time_container:Array[float]
var pitch_container:Array[int]
var length_container:Array[float]

var point_array:Array[float]

var fallen_line_pool:ObjectPoolFallenLine

var pre_delay:float
var delay:float

@export var fallen_line_container:Node2D
@export var timer:Timer
@export var music_player:AudioStreamPlayer
@export var sound_player:AudioStreamPlayer
@export var line_whole:Sprite2D
@export var line_playing:Sprite2D
@export var outline:Sprite2D
@export var wave_effect:Sprite2D
@export var wave_effect_shader_material:ShaderMaterial
@export var progress_label:Label
@export var button_finish:Button

@export var music_score:TimeLine

signal send_final_point(final_point:float)

func processed_pitch(pitch:int)->int:
	if pitch > 7:
		return pitch - 8
	else:
		return pitch

func push_to_front(the_pitch:int,the_pitch_rank:Array[int])->void:
	the_pitch_rank.erase(the_pitch)
	the_pitch_rank.push_front(the_pitch)

func calculate_points()->float:
	var sum:float = 0.0
	for i:float in point_array:
		sum += i
	var final_point:float = sum/rhythm_amount
	return final_point

func calculate_pitch()->void:
	for i:int in range(16):
		print(pow(2.0,float(i)/6.0))

func change_pitch_state()->void:
	if Input.is_action_just_pressed("key_a"):
		pitch_state[0] = true
		current_pitch = 0
		push_to_front(0,pitch_rank)
	elif Input.is_action_just_released("key_a"):
		pitch_state[0] = false
	if Input.is_action_just_pressed("key_s"):
		pitch_state[1] = true
		current_pitch = 1
		push_to_front(1,pitch_rank)
	elif Input.is_action_just_released("key_s"):
		pitch_state[1] = false
	if Input.is_action_just_pressed("key_d"):
		pitch_state[2] = true
		current_pitch = 2
		push_to_front(2,pitch_rank)
	elif Input.is_action_just_released("key_d"):
		pitch_state[2] = false
	if Input.is_action_just_pressed("key_f"):
		pitch_state[3] = true
		current_pitch = 3
		push_to_front(3,pitch_rank)
	elif Input.is_action_just_released("key_f"):
		pitch_state[3] = false
	if Input.is_action_just_pressed("key_j"):
		pitch_state[4] = true
		current_pitch = 4
		push_to_front(4,pitch_rank)
	elif Input.is_action_just_released("key_j"):
		pitch_state[4] = false
	if Input.is_action_just_pressed("key_k"):
		pitch_state[5] = true
		current_pitch = 5
		push_to_front(5,pitch_rank)
	elif Input.is_action_just_released("key_k"):
		pitch_state[5] = false
	if Input.is_action_just_pressed("key_l"):
		pitch_state[6] = true
		current_pitch = 6
		push_to_front(6,pitch_rank)
	elif Input.is_action_just_released("key_l"):
		pitch_state[6] = false
	if Input.is_action_just_pressed("key_semi"):
		pitch_state[7] = true
		current_pitch = 7
		push_to_front(7,pitch_rank)
	elif Input.is_action_just_released("key_semi"):
		pitch_state[7] = false

func change_higher_mode()->void:
	if Input.is_action_pressed("key_space"):
		higher_mode = true
	else:
		higher_mode = false

func pressing()->bool:
	for i:bool in pitch_state:
		if i == true:
			return true
	return false

func in_beat()->bool:
	if pressing():
		if playing_pitch == music_score_pitch and fallen_line_entering:
			return true
		else:
			return false
	else:
		return false

func calculate_progress(delta:float)->float:
	if in_beat():
		completed_time += delta
	if rhythm_index > 0:
		progress = completed_time / length_container[rhythm_index - 1]
	if progress >= 1.0:
		progress = 1.0
	return progress

func update_progress(delta:float)->void:
	progress_label.text = str(int(floorf(calculate_progress(delta) * 100.0))) + "%"

func reset_progress()->void:
	#重置单个音符的进度
	completed_time = 0.0
	progress = 0.0

func play_sound()->void:
	if pressing():
		if pitch_state[current_pitch] == true:
			#检测高音
			if higher_mode:
				sound_player.pitch_scale = pitch_scale_higher[current_pitch]
				playing_pitch = current_pitch + 8
			else:
				sound_player.pitch_scale = pitch_scale[current_pitch]
				playing_pitch = current_pitch
		else:
			for i:int in pitch_rank:
				if pitch_state[i] == true:
					if higher_mode:
						sound_player.pitch_scale = pitch_scale_higher[i]
						playing_pitch = i + 8
					else:
						sound_player.pitch_scale = pitch_scale[i]
						playing_pitch = i
					break
			#创建动态数组，每次按下一个键就把那个键提到数组最前方，如果松开了键，就按数组从前向后遍历决定谁演奏
		if sound_player.playing == false:
			sound_player.play()
	else:
		sound_player.stop()

func play_animation()->void:
	if pressing():
		line_playing.visible = true
		line_playing.global_position = pitch_position[processed_pitch(playing_pitch)]
	else:
		line_playing.visible = false

func play_animation_wave()->void:
	if in_beat():
		wave_effect.visible = true
		wave_effect.global_position.x = pitch_position[processed_pitch(playing_pitch)].x
	else:
		wave_effect.visible = false

func play_music()->void:
	music_player.play()

func change_color()->void:
	if higher_mode:
		line_playing.self_modulate = SaveLoad.ref_color_line_playing_higher.color
	else:
		line_playing.self_modulate = SaveLoad.ref_color_line_playing.color

func update_music_score()->void:
	var current_time:float = music_player.get_playback_position()
	if rhythm_index < rhythm_amount:
		if current_time > time_container[rhythm_index] and fallen_line_entering == false:
			delay = current_time - time_container[rhythm_index]
			print(delay)
			#print("update score time" + str(music_player.get_playback_position()))
			music_score_pitch = pitch_container[rhythm_index]
			fallen_line_entering = true
			timer.wait_time = length_container[rhythm_index] - delay
			rhythm_index += 1
			timer.start()
			
			reset_progress()
	else:
		game_is_end = true

func generate_fallen_line()->void:
	if fallen_line_index < rhythm_amount:
		var current_time:float = music_player.get_playback_position()
		if current_time > time_container[fallen_line_index] - pre_delay:
			#print(current_time)
			#print(time_container[fallen_line_index])
			fallen_line_pool.get_instance(fallen_line_index).setup_position()
			fallen_line_index += 1

func generate_fallen_line_pool()->void:
	fallen_line_pool = ObjectPoolFallenLine.new(
		fallen_line_container,
		rhythm_amount,
		fallen_speed,
		pitch_container,
		length_container
		)

func set_outline()->void:
	if rhythm_index < rhythm_amount:
		outline.global_position = pitch_position[processed_pitch(pitch_container[rhythm_index])]

func load_music_score()->void:
	rhythm_amount = music_score.timeline.size()
	for i:Rhythm in music_score.timeline:
		time_container.append(i.time)
		pitch_container.append(i.pitch)
		length_container.append(i.length)

func load_music_score_debug()->void:
	if time_container[0] < pre_delay:
		print("music score crashed!")
		#get_tree().quit(1)
	for i:int in range(fallen_line_index - 1):
		if (time_container[i] + length_container[i]) > time_container[i + 1]:
			print("music score crashed!")
			get_tree().quit(1)
		elif time_container[0] <= 2.0:
			print("music score crashed!")
			get_tree().quit(1)

func _ready() -> void:
	#链接信号
	var err1:int = button_finish.button_down.connect(_on_button_finish_button_up)
	print(err1)
	var err2:int = timer.timeout.connect(_on_time_out)
	print(err2)
	
	pre_delay = 2.0/fallen_speed
	#calculate_pitch()
	load_music_score()
	load_music_score_debug()
	generate_fallen_line_pool()
	play_music()
	
	set_outline()
	
	button_finish.visible = false

func _process(delta: float) -> void:
	
	change_pitch_state()
	change_higher_mode()
	change_color()
	
	play_sound()
	play_animation()
	
	generate_fallen_line()
	update_music_score()
	play_animation_wave()
	
	update_progress(delta)
	

func _on_time_out()->void:
	print("time out time:" + str(music_player.get_playback_position()))
	#结束进入
	set_outline()
	fallen_line_entering = false
	point_array.append(progress)
	if game_is_end:
		button_finish.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_button_finish_button_up()->void:
	button_finish.visible = false
	send_final_point.emit(calculate_points())
