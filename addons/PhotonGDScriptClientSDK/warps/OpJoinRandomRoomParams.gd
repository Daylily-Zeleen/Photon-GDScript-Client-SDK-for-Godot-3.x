class_name OpJoinRandomRoomParams

var expected_custom_room_properties:Dictionary setget _set_expected_custom_room_properties,_get_expected_custom_room_properties
var expected_max_players:int setget _set_expected_max_players, _get_expected_max_players
var matching_type:int setget _set_matching_type, _get_matching_type
var typed_lobby:TypedLobby setget _set_typed_lobby,_get_typed_lobby
var sql_lobby_filter:String setget _set_sql_lobby_filter, _get_sql_lobby_filter
var expected_users:PoolStringArray setget _set_expected_users, _get_expected_users




# setget 
func _set_expected_users(v:PoolStringArray)->void:
	_base.set_ExpectedUsers(v)
func _get_expected_users()->PoolStringArray:
	return _base.get_ExpectedUsers()
func _set_sql_lobby_filter(v:String)->void:
	_base.set_SqlLobbyFilter(v)
func _get_sql_lobby_filter()->String:return _base.get_SqlLobbyFilter()
func _set_typed_lobby(v:TypedLobby)->void:
	typed_lobby = v
	_base.set_TypedLobby(v._base)
func _get_typed_lobby()->TypedLobby:return typed_lobby
func _set_matching_type(v:int)->void:
	assert(v in Photon.MatchmakingMode.values(),"非法的匹配类型")
	_base.set_MatchingType(v)
func _get_matching_type()->int:
	return _base.get_MatchingType()
func _set_expected_max_players(v:int)->void:
	assert(v>=0 and v<256,"非法的最大玩家数量")
	_base.set_ExpectedMaxPlayers(v)
func _get_expected_max_players()->int: 
	return _base.get_ExpectedMaxPlayers()
func _set_expected_custom_room_properties(v:Dictionary)->void:
	_base.set_ExpectedCustomRoomProperties(v)
func _get_expected_custom_room_properties()->Dictionary:
	return _base.get_ExpectedCustomRoomProperties()
	
var _base:=preload("../src/PhotonOpJoinRandomRoomParams.cs").new()

