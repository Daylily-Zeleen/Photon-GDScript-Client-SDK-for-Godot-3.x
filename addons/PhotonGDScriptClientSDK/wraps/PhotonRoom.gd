## 该类不应该自行实例化
class_name PhotonRoom


var name:String setget _readonly,_get_name
var is_offline:bool setget _readonly, _get_is_offline
var is_open:bool setget _set_is_open, _get_is_open
var is_visible:bool setget _set_is_visible, _get_is_visible
var max_players:int setget _set_max_players, _get_max_players
var player_count:int setget _readonly, _get_player_count
# 不应修改该字典
## < PhotonPlaer.actor_number , PhotonPlayer >
var players:Dictionary setget _readonly, _get_players
var expected_users:PoolStringArray setget _readonly, _get_expected_users
## ms
var player_ttl:int setget _set_player_ttl, _get_player_ttl
var empty_room_ttl:int setget _set_empty_room_ttl, _get_empty_room_ttl
var master_client_id:int setget _readonly, _get_master_client_id
var properties_listed_in_lobby:PoolStringArray setget _readonly, _get_properties_listed_in_lobby
var auto_clean_up :bool setget _readonly, _get_auto_clean_up
var broadcast_properties_change_to_all :bool setget _readonly,_set_broadcast_properties_change_to_all
var suppress_room_events:bool setget _readonly, _get_suppress_room_events
var suppress_player_info:bool setget _readonly, _get_suppress_player_info
var publish_user_id:bool setget _readonly, _get_publish_user_id
var delete_null_properties:bool setget _readonly, _get_delete_null_properties
var removed_fro_list:bool setget _readonly, _get_removed_fro_list
# 不应修改该数组
## < String , obj >
var custom_properties:Dictionary setget _readonly, _get_custom_properties

func _init(room) -> void: #: Photon._PhotonRoom
	_base = room 

func set_custom_properties()->bool:
	return false




# setget 
func _get_custom_properties()->Dictionary :return _base.get_CustomProperties()
func _get_removed_fro_list()->bool:return _base.get_RemovedFromList()
func _get_delete_null_properties()->bool:return _base.get_DeleteNullProperties()
func _get_publish_user_id()->bool:return _base.get_PublishUserId()
func _get_suppress_player_info()->bool :return _base.get_SuppressPlayerInfo()
func _get_suppress_room_events()->bool :return _base.get_SuppressRoomEvents()
func _set_broadcast_properties_change_to_all()->bool:return _base.get_BroadcastPropertiesChangeToAll()
func _get_auto_clean_up()->bool: return _base.get_AutoCleanUp()
func _get_properties_listed_in_lobby()->PoolStringArray :return _base.get_PropertiesListedInLobby()
func _get_master_client_id()->int: return _base.get_MasterClientId()
func _set_empty_room_ttl(v:int)->void: _base.set_EmptyRoomTtl(v)
func _get_empty_room_ttl()->int: return _base.get_EmptyRoomTtl()
func _set_player_ttl(v:int)->void: _base.set_PlayerTtl(v)
func _get_player_ttl()->int:return _base.get_PlayerTtl()
func _get_expected_users()->PoolStringArray: return _base.get_ExpectedUsers()
func _get_players()->Dictionary:return _base.get_Players()
func _get_player_count()->int: return _base.get_PlayerCount()
func _set_max_players(v:int):
	assert(v>=0 and v<256,"非法的最大人数")
	_base.set_MaxPlayers(v)
func _get_max_players()->int:return _base.get_MaxPlayers()
func _set_is_visible(v:bool)->void: _base.set_IsVisible(v)
func _get_is_visible()->bool: return _base.get_IsVisible()
func _set_is_open(v:bool)->void: _base.set_IsOpen(v)
func _get_is_open()->bool:return _base.get_IsOpen()
func _get_is_offline()->bool:return _base.get_IsOffline()
func _get_name()->String: return _base.get_Name()
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
# 包装

var _base#: Photon._PhotonRoom 
