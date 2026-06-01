extends Node

const level_list:Array[String] = [
	"res://Asset/Resource/Score_Tutorial.tres",
	"res://Asset/Resource/Score_You.tres",
	"res://Asset/Text/Score_BrokenMoon.json",
	"res://Asset/Text/Score_ChineseTea.json",
	"res://Asset/Text/Score_HistoryOfTheMoon.json",
	"res://Asset/Resource/Score_DanceOfNight.tres",
	"res://Asset/Text/Score_LunaticPrincess.json",
	"res://Asset/Text/Score_U.N.Owen.json",
	"res://Asset/Resource/Score_FreeMode.tres",
]

const background_list:Array[CompressedTexture2D] = [
	preload("res://Asset/Image/Background/Backgrounds/B1.png"),
	preload("res://Asset/Image/Background/Backgrounds/B2.png"),
	preload("res://Asset/Image/Background/Backgrounds/B3.png"),
	preload("res://Asset/Image/Background/Backgrounds/B4.png"),
	preload("res://Asset/Image/Background/Backgrounds/B5.png"),
	preload("res://Asset/Image/Background/Backgrounds/B6.png"),
	preload("res://Asset/Image/Background/Backgrounds/B7.png"),
	preload("res://Asset/Image/Background/Backgrounds/B8.png"),
	preload("res://Asset/Image/Background/Backgrounds/B1.png")
]

var auto_mode:bool = false
var level_index:int = 1
var global_volume:float = 0.0
var flute_volume:float = 0.0
var play_speed:float = 1.0
var fallen_speed_multiplier:float = 1.0
