class_name LoopLine extends Node2D

@export var acting:bool = false
@export var amount:int
@export var loop_speed:float
@export var loop_time:float
@export var move_direction:Vector2
@export var spawn_position:Vector2
@export var texture:Texture2D

var distance_x:float
var mutual_distance:float
var normalized_move_direction:Vector2
var bias_vector:Vector2
var sprite_container:Array[Sprite2D] = []

func _ready() -> void:
	normalized_move_direction = move_direction.normalized()
	mutual_distance = (loop_speed * loop_time) / amount
	bias_vector = spawn_position - (loop_speed * loop_time * normalized_move_direction)/2.0
	distance_x = spawn_position.x + (normalized_move_direction.x * loop_speed * loop_time)/2.0
	for i:int in amount:
		var new_sprite:Sprite2D = Sprite2D.new()
		add_child(new_sprite)
		new_sprite.texture = texture
		new_sprite.global_position = bias_vector + i * mutual_distance * normalized_move_direction
		sprite_container.append(new_sprite)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if acting:
		for i:Sprite2D in sprite_container:
			i.global_position += loop_speed * normalized_move_direction * delta
			if i.global_position.x >= distance_x:
				i.global_position -= normalized_move_direction * loop_speed * loop_time
				#reset_physics_interpolation()
