extends Sprite2D

var speed:float = 100.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# 获取 Shader 材质
	var shader_mat:ShaderMaterial = material as ShaderMaterial
	if shader_mat:
		# 将判定线的全局 Y 坐标传递给 Uniform 变量
		shader_mat.set_shader_parameter("judgment_global_y", 200.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += speed * delta
