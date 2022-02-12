class_name TypedLobby

const Prefeb = {
	DEFAULT = null,
}

var name :String setget _set_name , _get_name 
var type:int setget _set_type , _get_type
var is_default:bool setget _readonly, _get_is_default

func _init(name:String = "", lobby_typ:int = Photon.LobbyType.Default) -> void:
	assert(lobby_typ in Photon.LobbyType.values(),"非法的大厅类型")
	_base.init(name, lobby_typ)	

func _to_string() -> String:
	return "[TypedLobby:%d]name :%s - type:%d" %[get_instance_id(), name, type]

#####
	
func _readonly(v:bool)->void:
	assert(false, "'is_default'是只读属性")
func _get_is_default()->bool:return _base.get_IsDefault()
func _set_name(v:String)->void: _base.set_Name(v)
func _get_name()->String : return _base.get_Name()
func _set_type(v:int)->void:
	assert(v in Photon.LobbyType.values(),"非法的大厅类型")
	_base.set_Type(v)
func _get_type()->int:return _base.get_Type()

const _Base = preload("../src/PhotonTypedLobby.cs") 
var _base:_Base = _Base.new() 

static func _setup_prefeb()->void:
	Prefeb.DEFAULT = load("res://addons/PhotonGDScriptClientSDK/wraps/TypedLobby.gd").new()
#	Prefeb.DEFAULT._base.free()#call_deferred("free")
	Prefeb.DEFAULT._base = _Base.GetDefault()
