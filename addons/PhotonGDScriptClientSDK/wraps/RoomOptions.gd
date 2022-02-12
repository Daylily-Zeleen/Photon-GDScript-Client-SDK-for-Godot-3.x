class_name RoomOptions

var is_visible:bool setget _set_is_visible, _get_is_visible
var is_open:bool setget _set_is_open, _get_is_open
var max_players:int setget _set_max_players,_get_max_players
var player_ttl:int setget _set_player_ttl, _get_player_ttl
var empty_room_ttl:int setget _set_empty_room_ttl, _get_empty_room_ttl
var cleanup_cache_on_leave:bool setget _set_cleanup_cache_on_leave, _get_cleanup_cache_on_leave
# < string, obj>
var custom_room_properties:Dictionary setget _set_custom_room_properties, _get_custom_room_properties
# 别忘了 PoolStringArray 不是引用类型
var custom_room_properties_for_lobby:PoolStringArray setget _set_custom_room_properties_for_lobby,_get_custom_room_properties_for_lobby
var plugins:PoolStringArray setget _set_plugins,_get_plugins
var suppress_room_events:bool setget _set_suppress_room_events, _get_suppress_room_events
var suppress_player_info:bool setget _set_suppress_player_info, _get_suppress_player_info
var publish_user_id:bool setget _set_publish_user_id,_get_publish_user_id
var delete_null_properties:bool setget _set_delete_null_properties, _get_set_delete_null_properties
var broadcast_props_change_to_all:bool setget _set_broadcast_props_change_to_all, _get_broadcast_props_change_to_all 







# setget 
func _set_broadcast_props_change_to_all(v:bool)->void: _base.set_BroadcastPropsChangeToAll(v)
func _get_broadcast_props_change_to_all()->bool:return _base.get_BroadcastPropsChangeToAll()
func _set_delete_null_properties(v:bool)->void: _base.set_DeleteNullProperties(v)
func _get_set_delete_null_properties()->bool:return _base.get_DeleteNullProperties()
func _set_publish_user_id(v:bool)->void: _base.set_PublishUserId(v)
func _get_publish_user_id()->bool: return _base.get_PublishUserId()
func _set_suppress_player_info(v:bool)->void: _base.set_SuppressPlayerInfo(v)
func _get_suppress_player_info()->bool : return _base.get_SuppressPlayerInfo()
func _set_suppress_room_events(v:bool)->void: _base.set_SuppressRoomEvents(v)
func _get_suppress_room_events()->bool: return _base.get_SuppressRoomEvents()
func _set_plugins(v:PoolStringArray)->void:_base.set_Plugins(v)
func _get_plugins()->PoolStringArray:return _base.get_Plugins()
func _set_custom_room_properties_for_lobby(v:PoolStringArray)->void:_base.set_CustomRoomPropertiesForLobby(v)
func _get_custom_room_properties_for_lobby()->PoolStringArray:return _base.get_CustomRoomPropertiesForLobby()
func _set_custom_room_properties(v:Dictionary)->void:_base.set_CustomRoomProperties(v)
func _get_custom_room_properties()->Dictionary:return _base.get_CustomRoomProperties()
func _set_cleanup_cache_on_leave(v:bool)->void:_base.set_CleanupCacheOnLeave(v)
func _get_cleanup_cache_on_leave()->bool:return _base.get_CleanupCacheOnLeave()
func _set_empty_room_ttl(v:int)->void: _base.set_EmptyRoomTtl(v)
func _get_empty_room_ttl()->int:return _base.get_EmptyRoomTtl()
func _set_player_ttl(v:int)->void: _base.set_PlayerTtl(v)
func _get_player_ttl()->int:return _base.get_PlayerTtl()
func _set_max_players(v:int)->void:
	assert(v>=0 and v<256,"非法的最大人数")
	_base.set_MaxPlayers(v)
func _get_max_players()->int:return _base.get_MaxPlayers()
func _set_is_open(v:bool)->void: _base.set_IsOpen(v)
func _get_is_open()->bool: return _base.get_IsOpen()
func _set_is_visible(v:bool)->void: _base.set_IsVisible(v)
func _get_is_visible()->bool: return _base.get_IsVisible()


var _base:= preload("../src/PhotonRoomOptions.cs").new()
