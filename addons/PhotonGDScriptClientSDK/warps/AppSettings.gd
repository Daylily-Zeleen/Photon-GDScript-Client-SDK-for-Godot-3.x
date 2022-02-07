class_name AppSettings

## AppId for Realtime or PUN.
var app_id_realtime:String setget _set_app_id_realtime, _get_app_id_realtime
## AppId for Photon Fusion. 
## 暂不支持
var app_id_fusion:String setget _set_app_id_fusion, _get_app_id_fusion
## AppId for Photon Chat.
## 暂不支持
var app_id_chat:String setget _set_app_id_chat,_get_app_id_chat
## AppId for Photon Voice.
## 暂不支持
var app_id_voice:String setget _set_app_id_voice,_get_app_id_voice

## The AppVersion can be used to identify builds and will split the AppId distinct "Virtual AppIds" (important for matchmaking).
var app_version :String setget _set_app_version,_get_app_version
## If false, the app will attempt to connect to a Master Server (which is obsolete but sometimes still necessary).
## if true, Server points to a NameServer (or is null, using the default), else it points to a MasterServer.
var use_name_server:bool setget _set_use_name_server, _get_use_name_server
## Can be set to any of the Photon Cloud's region names to directly connect to that region.
## if this IsNullOrEmpty() AND UseNameServer == true, use BestRegion. else, use a server
var fixed_region:String setget _set_fixed_region, _get_fixed_region
## Set to a previous BestRegionSummary value before connecting.
##
## This is a value used when the client connects to the "Best Region".</br>
## If this is null or empty, all regions gets pinged. Providing a previous summary on connect,
## speeds up best region selection and makes the previously selected region "sticky".</br>
##
## Unity clients should store the BestRegionSummary in the PlayerPrefs.
## You can store the new result by implementing <see cref="IConnectionCallbacks.OnConnectedToMaster"/>.
## If <see cref="LoadBalancingClient.SummaryToCache"/> is not null, store this string.
## To avoid storing the value multiple times, you could set SummaryToCache to null.
var best_region_summary_from_storage:String setget _set_best_region_summary_from_storage, _get_best_region_summary_from_storage 
## The address (hostname or IP) of the server to connect to.
var server:String setget _set_server,_get_server
## If not null, this sets the port of the first Photon server to connect to (that will "forward" the client as needed).
var port:int setget _set_port,_get_port
## The address (hostname or IP and port) of the proxy server.
var proxy_server:String setget _set_proxy_server,_get_proxy_server
## The network level protocol to use.
var protocol:int setget _set_protocol,_get_protocol
## Enables a fallback to another protocol in case a connect to the Name Server fails.
## See: LoadBalancingClient.EnableProtocolFallback.
var enable_protocol_fallback:bool setget _set_enable_protocol_fallback,_get_enable_protocol_fallback 
## Defines how authentication is done. On each system, once or once via a WSS connection (safe).
var auth_mode:int setget _set_auth_mode,_get_auth_mode
## If true, the client will request the list of currently available lobbies.
var enable_lobby_statistics:bool setget _set_enable_lobby_statistics,_get_enable_lobby_statistics
## Log level for the network lib.（也许暂时不起作用
var network_logging:int setget _set_network_logging,_get_network_logging 

# 只读
## If true, the Server field contains a Master Server address (if any address at all).
var is_master_server_address:bool setget _readonly,_get_is_master_server_address 
## If true, the client should fetch the region list from the Name Server and find the one with best ping.
## See "Best Region" in the online docs.
var is_best_region:bool setget _readonly, _get_is_best_region 
## If true, the default nameserver address for the Photon Cloud should be used
var is_default_name_server:bool setget _readonly,_get_is_default_name_server
## If true, the default ports for a protocol will be used.
var is_default_port:bool setget _readonly, _get_is_default_port


static func is_appId(value:String)->bool:
	return _Base.IsAppId(value)



func _to_string() -> String:
	return "[AppSetting:%d]:%s" % [ get_instance_id(), _base.ToStringFull()]











# setget 
func _get_is_default_port()->bool:
	return _base.get_IsDefaultPort()
func _get_is_default_name_server()->bool:
	return _base.get_IsDefaultNameServer()
func _get_is_best_region()->bool:
	return _base.get_IsBestRegion()
func _get_is_master_server_address()->bool:
	return _base.get_IsMasterServerAddress()
func _set_network_logging(v:int)->void:
	assert(v in Photon.DebugLevel.values(),"非法的调试级别")
	_base.set_NetworkLogging(v)
func _get_network_logging()->int:
	return _base.get_NetworkLogging()
func _set_enable_lobby_statistics(v:bool)->void:
	_base.set_EnableLobbyStatistics(v)
func _get_enable_lobby_statistics()->bool:
	return _base.get_EnableLobbyStatistics()
func _set_auth_mode(v:int)->void:
	assert(v in Photon.AuthModeOption.values(),"非法的验证模式")
	_base.set_AuthMode(v)
func _get_auth_mode()->int:
	return _base.get_AuthMode()
func _set_enable_protocol_fallback(v:bool)->void:
	_base.set_EnableProtocolFallback(v)
func _get_enable_protocol_fallback()->bool:
	return _base.get_EnableProtocolFallback()
func _set_protocol(v:int)->void:
	assert(v in Photon.ConnectionProtocol.values(),"非法的连接协议")
	_base.set_Protocol(v)
func _get_protocol()->int:
	return _base.get_Protocol()
func _set_proxy_server(v:String)->void:
	_base.set_ProxyServer(v)
func _get_proxy_server()->String:
	return _base.get_ProxyServer()
func _set_port(v:int)->void:
	_base.set_Port(v)
func _get_port()->int:
	return _base.get_Port()
func _set_server(v:String)->void:
	_base.set_Server(v)
func _get_server()->String:
	return _base.get_Server()
func _set_best_region_summary_from_storage(v:String)->void:
	_base.set_BestRegionSummaryFromStorage(v)
func _get_best_region_summary_from_storage()->String:
	return _base.get_BestRegionSummaryFromStorage()
func _set_fixed_region(v:String)->void:
	_base.set_FixedRegion(v)
func _get_fixed_region()->String:
	return _base.get_FixedRegion()
func _set_use_name_server(v:bool)->void:
	_base.set_UseNameServer(v)
func _get_use_name_server()->bool:
	return _base.get_UseNameServer()
func _set_app_version(v:String)->void:
	_base.set_AppVersion(v)
func _get_app_version()->String:
	return _base.get_AppVersion()
func _set_app_id_voice(v:String)->void:
	_base.set_AppIdVoice(v)
func _get_app_id_voice()->String:
	return _base.get_AppIdVoice()
func _set_app_id_chat(v:String)->void:
	_base.set_AppIdChat(v)
func _get_app_id_chat()->String:
	return _base.get_AppIdChat()
func _set_app_id_fusion(v:String)->void:
	_base.set_AppIdFusion(v)
func _get_app_id_fusion()->String:
	return _base.get_AppIdFusion()
	
func _set_app_id_realtime(v:String)->void:
	_base.set_AppIdRealtime(v)
func _get_app_id_realtime()->String:
	return _base.get_AppIdRealtime()

func _readonly(v)->void:
	assert(false,"该属性为只读属性")

const _Base = preload("../src/PhotonAppSettings.cs")
var _base:_Base = _Base.new()


