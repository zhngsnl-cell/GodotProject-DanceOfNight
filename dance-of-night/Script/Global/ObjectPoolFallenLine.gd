# GenericObjectPool.gd

class_name ObjectPoolFallenLine

extends RefCounted

var _pool: Array[FallenLine] = []
var _parent: Node

func _init(
	parent: Node, 
	size: int,
	fallen_speed_multiplier:float,
	disappear_point:float,
	pitch_array:Array[int],
	length_array:Array[float],
)->void:
	_parent = parent
	_initialize_pool(size,fallen_speed_multiplier,disappear_point,pitch_array,length_array)

func _initialize_pool(
	count: int,
	fallen_speed_multiplier:float,
	disappear_point:float,
	pitch_array:Array[int],
	length_array:Array[float],
	)->void:
	for i:int in range(count):
		var fallen_line:FallenLine = _create_instance(pitch_array[i],fallen_speed_multiplier,length_array[i],disappear_point)
		#print(fallen_line.scale.y)
		#print(fallen_line.appear_position.x)
		#print(fallen_line.appear_position.y)
		_return_to_pool(fallen_line)

func _create_instance(_pitch:int,_fallen_speed_multiplier:float,_length:float,_disappear_point:float) -> FallenLine:
	var new_line:FallenLine = FallenLine.new(_pitch,_fallen_speed_multiplier,_length,_disappear_point)
	_parent.add_child(new_line)
	return new_line

func _return_to_pool(obj: FallenLine)->void:
	obj.visible = false
	obj.set_process(false)
	obj.set_physics_process(false)
	_pool.append(obj)

func get_instance(index:int) -> FallenLine:
	var instance: FallenLine#这是正确的吗？
	
	instance = _pool[index]
	
	# 激活实例
	instance.visible = true
	instance.set_process(true)
	instance.set_physics_process(true)
	
	# 调用重置方法
	#if instance.has_method("reset"):
	#	instance.reset()
	
	return instance
