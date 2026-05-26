extends Node

class ColorRef:
	var color: Color
	func _init(p_color: Color) -> void:
		color = p_color

const SAVE_PATH:String = "user://settings.tres"

var ref_color_line:ColorRef = ColorRef.new(Color.WHITE)
var ref_color_line_playing:ColorRef = ColorRef.new(Color.WHITE)
var ref_color_outline:ColorRef = ColorRef.new(Color.WHITE)
var ref_color_rhythm:ColorRef = ColorRef.new(Color.WHITE)
var ref_color_rhythm_higher:ColorRef = ColorRef.new(Color.WHITE)
var ref_color_wave:ColorRef = ColorRef.new(Color.WHITE)

var color_ref_array:Array[ColorRef] = [
	ref_color_line,
	ref_color_line_playing,
	ref_color_outline,
	ref_color_rhythm,
	ref_color_rhythm_higher,
	ref_color_wave,
]

func save_single_color(color:Color)->ColorData:
	var color_data:ColorData = ColorData.new()
	color_data.r = color.r
	color_data.g = color.g
	color_data.b = color.b
	color_data.a = color.a
	return color_data

func save_color()->void:
	var color_data_array:ColorDataArray = ColorDataArray.new()
	for i:int in range(color_ref_array.size()):
		color_data_array.color_data_array.append(save_single_color(color_ref_array[i].color))
	var err:Error = ResourceSaver.save(color_data_array,SAVE_PATH)
	if err != OK:
		printerr("fail to save!")
	print("color saved!")

func load_single_color(color_to_load:ColorData)->Color:
	var color:Color
	color.r = color_to_load.r
	color.g = color_to_load.g
	color.b = color_to_load.b
	color.a = color_to_load.a
	return color

func load_color()->void:
	if not ResourceLoader.exists(SAVE_PATH):
		print("resource doesn't exist")
		return
	var color_data_array:ColorDataArray = ResourceLoader.load(SAVE_PATH) as ColorDataArray
	if color_data_array == null:
		print("data is null")
		return
	if color_data_array.color_data_array.is_empty():
		print("array is empty")
		return
	for i:int in range(color_ref_array.size()):
		color_ref_array[i].color = load_single_color(color_data_array.color_data_array[i])
	print("color loaded!")
