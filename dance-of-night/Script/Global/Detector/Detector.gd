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
	2.244
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

var playing_pitch:int
var current_pitch:int = 0
var last_pitch:int = 0

var beat_index:int = 0
var beat_amount:int = 0
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

var delay:float = 0.2

@export var music_player:AudioStreamPlayer
@export var sound_player:AudioStreamPlayer
@export var LineWhole:Sprite2D
@export var Outline:Sprite2D
@export var music_score:TimeLine

func push_to_front(the_pitch:int,the_pitch_rank:Array[int])->void:
	the_pitch_rank.erase(the_pitch)
	the_pitch_rank.push_front(the_pitch)

func calculate_pitch()->void:
	for i:int in range(8):
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

func pressing()->bool:
	for i:bool in pitch_state:
		if i == true:
			return true
	return false

func play_sound()->void:
	if pressing():
		if pitch_state[current_pitch] == true:
			sound_player.pitch_scale = pitch_scale[current_pitch]
			playing_pitch = current_pitch
		else:
			for i:int in pitch_rank:
				if pitch_state[i] == true:
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
		Outline.visible = true
		Outline.global_position = pitch_position[playing_pitch]
	else:
		Outline.visible = false

func set_line(pitch:int,length:float)->void:
	var line_scene:PackedScene = preload("res://Scene/Level/LineFallen.tscn")
	var line:Sprite2D = line_scene.instantiate() as Sprite2D
	add_child(line)
	line.scale.y = length
	line.global_position.x = pitch_position[pitch].x
	line.global_position.y = -length/2.0

func load_music_score()->void:
	beat_amount = music_score.timeline.size()
	for i:Rhythm in music_score.timeline:
		time_container.append(i.time)
		pitch_container.append(i.pitch)
		length_container.append(i.length)

func _ready() -> void:
	#calculate_pitch()
	load_music_score()
	music_player.play()

func _process(_delta: float) -> void:
	change_pitch_state()
	play_sound()
	play_animation()
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if Input.is_action_just_pressed("debug"):
		print(pitch_state[0])
	if beat_index < beat_amount:
		var current_time:float = music_player.get_playback_position()
		if current_time >= time_container.get(beat_index) - delay:
			set_line(pitch_container.get(beat_index),length_container.get(beat_index))
			beat_index += 1
