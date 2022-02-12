## <summary>
## Settings for Photon application(s) and the server to connect to.
## </summary>
## <remarks>
## This is Serializable for Unity, so it can be included in ScriptableObject instances.
## </remarks>
class_name ChatAppSettings
## AppId for the Chat Api.
var app_id_chat :String setget _set_app_id_chat,_get_app_id_chat
## The AppVersion can be used to identify builds and will split the AppId distinct "Virtual AppIds" (important for the users to find each other).
var app_version :String setget _set_app_version, _get_app_version
## Can be set to any of the Photon Cloud's region names to directly connect to that region.
var fixed_region :String setget _set_fixed_region, _get_fixed_region
## The address (hostname or IP) of the server to connect to.
var server :String setget _set_server, _get_server
## If not null, this sets the port of the first Photon server to connect to (that will "forward" the client as needed).
var port :int setget _set_port, _get_port
## The network level protocol to use.
var protocol:int setget _set_protocol, _get_protocol
## Enables a fallback to another protocol in case a connect to the Name Server fails.
## See: LoadBalancingClient.EnableProtocolFallback.
var enable_protocol_fallback:bool setget _set_enable_protocol_fallback, _get_enable_protocol_fallback
## Log level for the network lib.
var network_logging:int setget _set_network_logging, _get_network_logging 
## If true, the default nameserver address for the Photon Cloud should be used.
var is_default_name_server :bool setget _readonly, _get_is_default_name_server





# setget
func _get_is_default_name_server()->bool:
	return _base.get_IsDefaultNameServer()
func _set_network_logging(v:int)->void:
	assert(v in Photon.DebugLevel.values(),"非法的调试级别")
	_base.set_NetworkLogging(v)
func _get_network_logging()->int:
	return _base.get_NetworkLogging()

func _set_enable_protocol_fallback(v:bool)->void:
	_base.set_EnableProtocolFallback(v)
func _get_enable_protocol_fallback()->bool:
	return _base.get_EnableProtocolFallback()
func _set_protocol(v:int)->void:
	assert(v in Photon.ConnectionProtocol.values(),"非法的连接协议")
	_base.set_Protocol(v)
func _get_protocol()->int:
	return _base.get_Protocol()
func _set_port(v:int)->void:
	assert(v > 0 and v < 65536, "非法端口号")
	_base.set_Port(v)
func _get_port()->int:
	return _base.get_Port()
func _set_server(v:String)->void:
	_base.set_Server(v)
func _get_server()->String:
	var tmp = _base.get_Server()
	return tmp if tmp else ""
func _set_fixed_region(v:String)->void:
	_base.set_FixedRegion(v)
func _get_fixed_region()->String:
	var tmp = _base.get_FixedRegion()
	return tmp if tmp else ""
func _set_app_version(v:String)->void:
	_base.set_AppVersion(v)
func _get_app_version()->String:
	var tmp = _base.get_AppVersion()
	return tmp if tmp else ""
func _set_app_id_chat(v:String)->void:
	_base.set_AppIdChat(v)
func _get_app_id_chat()->String:
	var tmp = _base.get_AppIdChat()
	return tmp if tmp else ""
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
	

const _Base:=preload("../src/PhotonChatAppSettings.cs")
var _base = _Base.new()
