class_name Detector extends Node

const pitch_position:Array[Vector2] = [
	Vector2(135.0,180.0),
	Vector2(165.0,180.0),
	Vector2(195.0,180.0),
	Vector2(225.0,180.0),
	Vector2(255.0,180.0),
	Vector2(285.0,180.0),
	Vector2(315.0,180.0),
	Vector2(345.0,180.0),
]

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
var time_container:Array[float]
var pitch_container:Array[int]
var length_container:Array[float]

var delay:float = 0.2

@export var music_player:AudioStreamPlayer
@export var music_score_index:String
@export var music_score:TimeLine

func change_pitch_state()->void:
	if Input.is_action_just_pressed("key_a"):
		pitch_state[0] = true
	elif Input.is_action_just_pressed("key_a"):
		pitch_state[0] = false
	if Input.is_action_just_pressed("key_s"):
		pitch_state[1] = true
	elif Input.is_action_just_pressed("key_s"):
		pitch_state[1] = false
	if Input.is_action_just_pressed("key_d"):
		pitch_state[2] = true
	elif Input.is_action_just_pressed("key_d"):
		pitch_state[2] = false
	if Input.is_action_just_pressed("key_f"):
		pitch_state[3] = true
	elif Input.is_action_just_pressed("key_f"):
		pitch_state[3] = false
	if Input.is_action_just_pressed("key_j"):
		pitch_state[4] = true
	elif Input.is_action_just_pressed("key_j"):
		pitch_state[4] = false
	if Input.is_action_just_pressed("key_k"):
		pitch_state[5] = true
	elif Input.is_action_just_pressed("key_k"):
		pitch_state[5] = false
	if Input.is_action_just_pressed("key_l"):
		pitch_state[6] = true
	elif Input.is_action_just_pressed("key_l"):
		pitch_state[6] = false
	if Input.is_action_just_pressed("key_semi"):
		pitch_state[7] = true
	elif Input.is_action_just_pressed("key_semi"):
		pitch_state[7] = false

#放置节拍
func set_area(pitch:int)->void:
	var rhythm_texture_scene:PackedScene = preload("res://Scene/Level/RhythmTexture.tscn")
	var rhythm_texture:Sprite2D = rhythm_texture_scene.instantiate() as Sprite2D
	add_child(rhythm_texture)
	rhythm_texture.global_position = pitch_position[pitch]

#读取json文件
func load_music_score()->void:
	for i:Rhythm in music_score.timeline:
		time_container.append(i.time)
		pitch_container.append(i.pitch)
		length_container.append(i.length)

func _ready() -> void:
	
	load_music_score()
	#播放音乐
	music_player.play()


#暂时不生成节拍
func _process(delta: float) -> void:
	if beat_index < beat_amount:
		#使用AudioPlayer的时间，如果时间大于检测区域的出现时间，那么生成检测区域
		var current_time = music_player.get_playback_position()
		#减去0.5确保节拍的检测区间与音乐重合
		if current_time >= time_container.get(beat_index) - delay:
			set_area(pitch_container.get(beat_index))
			#进行到下一个检测区域
			beat_index += 1
