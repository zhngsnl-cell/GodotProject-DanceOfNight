class_name RhythmLine extends Sprite2D

var speed:float = 100.0

func return_processed_pitch(pitch:int)->int:
	if pitch > 7:
		var higher_pitch:int = pitch - 8
		self_modulate = SaveLoad.ref_color_rhythm_higher.color
		return higher_pitch
	else:
		self_modulate = SaveLoad.ref_color_rhythm.color
		return pitch

func _ready() -> void:
	var shader_mat:ShaderMaterial = material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("judgment_global_y", 200.0)

func _process(delta: float) -> void:
	global_position.y += speed * delta
