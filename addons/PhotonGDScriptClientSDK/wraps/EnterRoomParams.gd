class_name EnterRoomParams

var room_name:String setget _set_room_name,_get_room_name
var room_options:RoomOptions setget _set_room_options,_get_room_options
var lobby:TypedLobby setget _set_lobby,_get_lobby
# < string , obj >
var player_properties:Dictionary setget _set_player_properties, _get_player_properties
var expected_users:PoolStringArray setget _set_expected_users, _get_expected_users


func _to_string() -> String:
	return "[EnterRoomParams:%d]:"%[get_instance_id()]



#setget 
func _set_expected_users(v:PoolStringArray)->void: _base.set_ExpectedUsers(v)
func _get_expected_users()->PoolStringArray:return _base.get_ExpectedUsers()
func _set_player_properties(v:Dictionary)->void: _base.set_PlayerProperties(v)
func _get_player_properties()->Dictionary:return _base.get_PlayerProperties()
func _set_lobby(v:TypedLobby)->void:
	lobby = v
	_base.set_Lobby(v._base)
func _get_lobby()->TypedLobby: return lobby
func _set_room_options(v:RoomOptions)->void:
	room_options = v
	_base.set_PhotonRoomOptions(v._base)
func _get_room_options()->RoomOptions:return room_options
func _set_room_name(v:String)->void: _base.set_RoomName(v)
func _get_room_name()->String:return _base.get_RoomName()



const _Base = preload("../src/PhotonEnterRoomParams.cs")
var _base: _Base = _Base.new()
