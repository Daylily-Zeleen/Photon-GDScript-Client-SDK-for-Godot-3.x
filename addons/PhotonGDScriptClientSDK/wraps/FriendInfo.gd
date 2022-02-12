# 不该自行实例化
class_name FriendInfo

var user_id:String setget _readonly
var is_online :bool setget _readonly
var room:String setget _readonly
var is_in_room:bool setget _readonly


func _to_string() -> String:
	return "[FriendInfo:%d] %s is %s"%[get_instance_id(), "offline" if not is_online else ("playing" if is_in_room else "on master")]
	
# setget 
func _readonly(v):
	assert(false,"该属性为只读属性")

func _init(user_id :String, is_online:bool, room:String, is_in_room:bool) -> void:
	self.user_id = user_id 
	self.is_online = is_online
	self.room = room
	self.is_in_room = is_in_room
