extends Node

const SAVE_PATH:String = "user://settings.tres"

var color_line:Color
var color_outline:Color
var color_rhythm:Color
var color_wave:Color

func save_single_color(color:Color)->ColorData:
	var color_data:ColorData = ColorData.new()
	color_data.r = color.r
	color_data.g = color.g
	color_data.b = color.b
	color_data.a = color.a
	return color_data

func save_color()->void:
	var color_data_array:ColorDataArray = ColorDataArray.new()
	color_data_array.color_data_array.append(save_single_color(color_line))
	color_data_array.color_data_array.append(save_single_color(color_outline))
	color_data_array.color_data_array.append(save_single_color(color_rhythm))
	color_data_array.color_data_array.append(save_single_color(color_wave))
	ResourceSaver.save(color_data_array,SAVE_PATH)
	print(color_data_array.color_data_array[0])
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
	color_line = load_single_color(color_data_array.color_data_array[0])
	color_outline = load_single_color(color_data_array.color_data_array[1])
	color_rhythm = load_single_color(color_data_array.color_data_array[2])
	color_wave = load_single_color(color_data_array.color_data_array[3])
	print("color loaded!")
