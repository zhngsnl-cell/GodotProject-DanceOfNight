extends Node

const SCORE_1:JSON = preload("res://Asset/Text/Score1.json")

func generate_resource(resource_path:String)->TimeLine:
	var timeline_resource:TimeLine = TimeLine.new()
	var file:FileAccess = FileAccess.open(resource_path,FileAccess.READ)
	var file_text:Dictionary = JSON.parse_string(file.get_as_text())
	if file_text is Dictionary:
		for i:int in range(file_text.size()):
			var array:Array = file_text[i]
			if array is Array:
				for inde:int in range(array.size()):
					var single_array:Array = array[inde]
					var single_pitch:Rhythm = Rhythm.new()
					single_pitch.pitch = single_array[0]
					single_pitch.time = single_array[1]
					single_pitch.length = single_array[2]
					timeline_resource.timeline.append(single_pitch)
	return timeline_resource

func _ready() -> void:
	pass
