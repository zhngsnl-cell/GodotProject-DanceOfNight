extends CanvasLayer

var pausing:bool = false

@onready var control: Control = $Control
@onready var label: Label = $Label

@onready var sound_hover: AudioStreamPlayer = $Sound/SoundHover
@onready var sound_select: AudioStreamPlayer = $Sound/SoundSelect

func create_tween_delay(time:float)->void:
	var tween_delay:Tween = create_tween()
	tween_delay.tween_interval(time)
	await tween_delay.finished

func pause()->void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pausing = true
	control.visible = true
	label.visible = false
	get_tree().paused = true

func resume()->void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	control.visible = false
	label.visible = true
	label.text = "3"
	await create_tween_delay(1.0)
	label.text = "2"
	await create_tween_delay(1.0)
	label.text = "1"
	await create_tween_delay(1.0)
	label.visible = false
	get_tree().paused = false
	pausing = false

#func pausable_tween(object:Object,node_path:NodePath,variant:Variant,time:float)->void:
	#var tween:Tween = create_tween()
	#tween.tween_property(object,node_path,variant,time)
	#var delay_tween:Tween = create_tween()
	#delay_tween.tween_interval(time)
	#await delay_tween.finished

func go_to_main()->void:
	get_tree().change_scene_to_file("res://Scene/Level/Main.tscn")

func go_to_menu()->void:
	get_tree().change_scene_to_file("res://Scene/UI/UIMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if not pausing:
			pause()


func _on_button_resume_button_up() -> void:
	sound_select.play()
	await resume()

func _on_button_menu_button_up() -> void:
	sound_select.play()
	await sound_select.finished
	get_tree().paused = false
	call_deferred("go_to_menu")

func _on_button_retry_button_up() -> void:
	sound_select.play()
	await sound_select.finished
	call_deferred("go_to_main")

func _on_button_resume_mouse_entered() -> void:
	sound_hover.play()

func _on_button_retry_mouse_entered() -> void:
	sound_hover.play()

func _on_button_menu_mouse_entered() -> void:
	sound_hover.play()
