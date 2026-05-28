extends Sprite2D

const NOTE_RED:CompressedTexture2D = preload("uid://bov62xodfrwrt")
const NOTE_GREEN:CompressedTexture2D = preload("uid://dptfsu87r2cf0")
const NOTE_BLUE:CompressedTexture2D = preload("uid://py6gbsvqj0ur")
const NOTE_WHITE:CompressedTexture2D = preload("uid://dd6ft46millg")

var resource_array:Array[Resource] = [
	NOTE_RED,
	NOTE_GREEN,
	NOTE_BLUE,
	NOTE_WHITE,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number:int = randi_range(0,3)
	texture = resource_array[random_number]
	position = Vector2(randf_range(-1.0,1.0) * 24.0,-24.0 - randf_range(0.0,1.0) * 16.0)
	var positive:float = 1.0
	for i:int in range(10):
		var tween:Tween = create_tween()
		tween.tween_interval(0.2)
		await tween.finished
		position -= Vector2(positive,1.0)
		positive *= -1.0
	queue_free()
