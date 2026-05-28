class_name FallenLine extends Sprite2D

const pitch_position:Array[float] = [
	135.0,
	165.0,
	195.0,
	225.0,
	255.0,
	285.0,
	315.0,
	345.0,
]

var the_texture:Texture2D = preload("res://Asset/Image/RhythmTexture/LineFallen.png")
const shader_mat:ShaderMaterial = preload("res://Asset/Material/FallenLine.tres")

var processed_pitch:int
var fallen_speed:float = 100.0
var appear_position:Vector2

func setup_position()->void:
	global_position = appear_position

func return_processed_pitch(pitch:int)->int:
	if pitch > 7:
		var higher_pitch:int = pitch - 8
		self_modulate = SaveLoad.ref_color_rhythm_higher.color
		return higher_pitch
	else:
		self_modulate = SaveLoad.ref_color_rhythm.color
		return pitch

func _init(_pitch:int,_fallen_speed:float,_length:float) -> void:
	texture = the_texture
	scale.y = _length * _fallen_speed * 100.0
	processed_pitch = return_processed_pitch(_pitch)
	appear_position.x = pitch_position[processed_pitch]
	appear_position.y = -(_length * _fallen_speed * 100.0)/2.0
	global_position = appear_position
	fallen_speed *= _fallen_speed
	
	material = shader_mat
	if shader_mat:
		shader_mat.set_shader_parameter("judgment_global_y", 200.0)
	

func _process(delta: float) -> void:
	global_position.y += fallen_speed * delta
