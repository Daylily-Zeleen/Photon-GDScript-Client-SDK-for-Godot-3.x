extends Reference
## 该类不应该自行实例化
## 该类代表一个Photon玩家
class_name PhotonPlayer


var actor_number:int setget _readonly, _get_actor_number
var is_local:bool setget _readonly, _get_is_local
var has_rejoined:bool setget _readonly, _get_has_rejoined
var nick_name:String setget _readonly, _get_nick_name
var user_id:String setget _readonly, _get_user_id
var is_master_client:bool setget _readonly, _get_is_master_client
var is_inactive:bool setget _readonly, _get_is_inactive
## 不应修改字典里的值
var custom_properties:Dictionary setget _readonly, _get_custom_properties
var tag_object setget _set_tag_object, _get__tag_object

func _init(photon_player ) -> void: #: Photon._PhotonPlayer
	_base = photon_player

func get_player(actor_number:int)->PhotonPlayer:return _base.GetGDSPlayer(actor_number)
func get_next_player()->PhotonPlayer: return _base.GetNextGDSPlalyer()
func get_next_player_for(current_actor_number:int)->PhotonPlayer:return _base.GetNextGDSPlalyerFor(current_actor_number)
func get_next_player_for_player(current_player:PhotonPlayer)->PhotonPlayer:return _base.GetNextGDSPlalyerForPlayer(current_player)






func _to_string() -> String:
	return "[PhotonPlayer:%d]"%get_instance_id()
	
	
	
	
	
# setget 
func _set_tag_object(v)->void: 
	tag_object = v
	_base.set_TagObject(v)
func _get__tag_object():
	if tag_object == null:
		tag_object = _base.get_TagObject()
	return tag_object 
func _get_custom_properties()->Dictionary:return _base.get_CustomProperties()
func _get_is_inactive()->bool:return _base.get_IsInactive()
func _get_is_master_client()->bool:
	return _base.get_IsMasterClient()
func _get_user_id()->String:return _base.get_UserId()
func _get_nick_name()->String:return _base.get_NickName()
func _get_has_rejoined()->bool: return _base.get_HasRejoined()
func _get_is_local()->bool:return _base.get_IsLocal()
func _get_actor_number()->int :return _base.get_ActorNumber()

func _readonly(v)->void:
	assert(false,"该属性为只读属性")


#const _Class = {
#	_Base = null
#}

var _base#: Photon._PhotonPlayer#:_PhotonPlayer
#static func _setup_class()->void:
#	_Class._Base = load("res://addons/Photon/src/PhotonPlayer.cs")
