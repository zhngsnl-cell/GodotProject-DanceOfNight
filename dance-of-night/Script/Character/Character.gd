class_name NightAnim extends AnimatedSprite2D

const knife_scene:PackedScene = preload("res://Scene/Character/Knife.tscn")
const note_scene:PackedScene = preload("res://Scene/Character/Note.tscn")

var time_sum:float = 0.0

@onready var flute: Sprite2D = $Flute

@export var pressing:bool = false

func throw_knife()->void:
	var knife:Area2D = knife_scene.instantiate() as Area2D
	add_child(knife)
	knife.global_position = global_position + Vector2(10.0,0.0)

func generate_note()->void:
	var note:Sprite2D = note_scene.instantiate() as Sprite2D
	add_child(note)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		flute.visible = true
		time_sum += delta
		if time_sum >= 1.5:
			generate_note()
			time_sum = 0.0
	else:
		flute.visible = false
