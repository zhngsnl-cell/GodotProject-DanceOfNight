extends AnimatedSprite2D

const knife_scene:PackedScene = preload("res://Scene/Character/Knife.tscn")

func throw_knife()->void:
	var knife:Area2D = knife_scene.instantiate() as Area2D
	add_child(knife)
	knife.global_position = global_position + Vector2(10.0,0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_z"):
		throw_knife()
