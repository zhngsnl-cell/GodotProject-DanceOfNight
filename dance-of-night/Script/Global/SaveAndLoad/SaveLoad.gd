extends Node

const SAVE_PATH:String = "user://settings.tres"

var color_line:Color
var color_outline:Color
var color_rhythm:Color
var color_wave:Color

func save_single_color(color:Color)->ColorData:
	var color_data:ColorData = ColorData.new()
	color_data.r8 = color.r8
	color_data.g8 = color.g8
	color_data.b8 = color.b8
	color_data.a8 = color.a8
	return color_data

func save_color()->void:
	var color_data_array:ColorDataArray = ColorDataArray.new()
	color_data_array.color_data_array.append(save_single_color(color_line))
	color_data_array.color_data_array.append(save_single_color(color_outline))
	color_data_array.color_data_array.append(save_single_color(color_rhythm))
	color_data_array.color_data_array.append(save_single_color(color_wave))
	ResourceSaver.save(color_data_array,SAVE_PATH)
	print("color saved!")

func load_single_color(color:Color,color_to_load:ColorData)->void:
	color.r8 = color_to_load.r8
	color.g8 = color_to_load.g8
	color.b8 = color_to_load.b8
	color.a8 = color_to_load.a8

func load_color()->void:
	if not ResourceLoader.exists(SAVE_PATH):
		return
	var color_data_array:ColorDataArray = ResourceLoader.load(SAVE_PATH) as ColorDataArray
	if color_data_array == null:
		return
	if color_data_array.color_data_array.is_empty():
		return
	load_single_color(color_line,color_data_array.color_data_array[0])
	load_single_color(color_line,color_data_array.color_data_array[1])
	load_single_color(color_line,color_data_array.color_data_array[2])
	load_single_color(color_line,color_data_array.color_data_array[3])
	print("color loaded!")
