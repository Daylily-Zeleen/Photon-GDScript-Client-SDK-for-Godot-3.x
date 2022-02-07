extends Node
## 当你使用继承从方式实现时
## 由于 Godot 3.x 父类对子类没有封装的概念
## 确保你对该类的属性通过 .prop 或 self.prop 进行访问（通过访问器）
class_name RealtimeClient

const CALLBACK_GROUP_NAME = "_rc_callbacks"
const CALLBACK_PREFIX = "_on_rc_"

## realtime_
## 一个低级别的通讯,请确保对 Photon 的交互协议足够了解再进行使用
signal op_response_received(operation_response) # OperationResponse
signal event_received(event_data)# PhotonEventData
## This can be useful to react to being connected, joined into a room, etc.
## previous_state	int	: Photon.ClientState
## current_state	int	: Photon.ClientState
signal state_changed(previous_state, current_state) 

## 连接相关信号
signal connected()
signal connected_to_master()
signal custom_authentication_failed(debug_msg)  # str 
signal custom_authentication_responsed(data) # dict
signal disconnected(cause) # int
signal region_list_received(region_handler) # RegionHandler

## Error 
signal error_info_reveived(error_info) # ErrorInfo

## WebRpc 响应
signal web_rpc_responsed(response) # WebRpcResponse

## 匹配相关信号
signal room_created()
signal room_joined()
signal create_room_failed(return_code, message) # byte(不同操作的返回代码不同，0 通常为 OK) , str
signal join_room_failed(return_code, message) # byte(不同操作的返回代码不同，0 通常为 OK) , str
signal join_random_failed(return_code, message) # byte(不同操作的返回代码不同，0 通常为 OK) , str
signal room_lefting() # byte(不同操作的返回代码不同，0 通常为 OK) , str
signal friend_list_updated(friend_list) # array<PhotonFriendInfo>

# 在游戏房间内的信号
signal player_room_entered(new_player) # PhotonPlayer
signal player_room_lefting(other_player) # PhotonPlayer
signal room_properties_updated(changed_props) # dict
signal player_properties_updated(target_player,changed_props) # PhotonPlayer, dict
signal master_client_switched(new_master_client) # PhotonPlayer

# 在大厅内的信号
signal lobby_joined()
signal lobby_lefting()
signal room_list_updated(roomList) # Array<PhoronRoomInfo> ## 待包装
signal lobby_statistics_updated(lobby_statistics) # Array<PhotonTypedLobbyInfo> ## 待包装

# 以下为信号同步回调
func _on_op_response_received(operation_response:OperationResponse)->void:pass	
func _on_event_received(event_data:EventData)->void: pass
func _on_state_changed(previous_state:int,current_state:int)->void: pass 
func _on_connected()->void:pass
func _on_connected_to_master()->void:pass
func _on_custom_authentication_failed(debug_message:String)->void:pass
func _on_custom_authentication_responsed(data:Dictionary)->void:pass
func _on_disconnected(disconnected_cause:int)->void:pass
func _on_region_list_received(regionHandler:RegionHandler)->void:pass
func _on_error_info_reveived(error_info:ErrorInfo)->void:pass
func _on_web_rpc_responsed(response:WebRpcResponse)->void:pass
func _on_room_created()->void:pass
func _on_room_joined()->void:pass
func _on_create_room_failed(return_code:int, message:String)->void:pass
func _on_join_room_failed(return_code:int, message:String)->void:pass
func _on_join_random_failed(return_code:int, message:String)->void:pass
func _on_room_lefting()->void:pass
func _on_friend_list_updated(friend_list:Array)->void:pass # Array<FriendInfo>
func _on_player_room_entered(new_player:PhotonPlayer)->void:pass
func _on_player_room_lefting(other_player:PhotonPlayer)->void:pass
func _on_room_properties_updated(changed_props:Dictionary)->void:pass
func _on_player_properties_updated(target_player:PhotonPlayer,changed_props:Dictionary)->void:pass
func _on_master_client_switched(new_master_client:PhotonPlayer)->void:pass
func _on_lobby_joined()->void:pass
func _on_lobby_lefting()->void:pass
func _on_room_list_updated(room_list:Array)->void:pass # Array<RoomInfo>
func _on_lobby_statistics_updated(lobby_statistics:Array)->void:pass # Array<LobbyInfo>


## true - 如果在场景树中，在发送信号之后会调用加入到 RealtimeClient.CALLBACK_GROUP_NAME 组(Group)的对象中的相应的回调方法
##		回调方法为 对应信号名加前缀 "_on_rc_", 方法参数为 RealtimeClient.local_player.actor_number 和 信号携带的参数。
##		注意 回调 是在空闲时
## 当你的设计中可能同时存在多个在场景树中 RealtimeClient 对象时,回调方法的第一个参数将可用于区分具体是那个 RealtimeClient 对象发出的。
## 默认为 true 
var notify_group:bool = true
## true - 在空闲时回调方法
## false - 发送相应信号后立即调用
var notify_when_idle:bool = true setget _set_notify_when_idle
var bg_send:bool setget _set_bg_send,_get_bg_send
var bg_dispatch:bool setget _set_bg_dispatch,_get_bg_dispatch
var bg_send_interval_ms:int setget _set_bg_send_interval_ms,_get_bg_send_interval_ms
var bg_dispatch_interval_ms:int setget _set_bg_dispatch_interval_ms,_get_bg_dispatch_interval_ms
var bg_send_single:bool setget _set_bg_send_single,_get_bg_send_single
var bg_dispatch_single:bool setget _set_bg_dispatch_single,_get_bg_dispatch_single
var reuse_event_instance:bool setget _set_reuse_event_instance,_get_reuse_event_instance
var serialization_protocol:int setget _set_serialization_protocol,_get_serialization_protocol
var app_version:String setget _set_app_version,_get_app_version 
var app_id:String setget _set_app_id, _get_app_id
## 当使用AppSetting进行连接时该项在内部才有效，用于从AppSetting中读取响应的AppiId
var client_type:int setget _set_client_type,_get_client_type
## <summary>User authentication values to be sent to the Photon server right after connecting.</summary>
## <remarks>Set this property or pass AuthenticationValues by Connect(..., authValues).</remarks>
var auth_values :RealtimeAuthenticationValues setget _set_auth_values, _get_auth_values
var auth_mode:int setget _set_auth_mode, _get_auth_mode
var encryption_mode:int setget _set_encryption_mode,_get_encryption_mode
var expected_protocol:int setget _set_expected_protocol,_get_expected_protocol
var is_using_name_server:bool setget _set_using_name_server, _is_using_name_server
## AppSetting连接才被赋予自定义值
var name_server_host:String setget _set_name_server_host, _get_name_server_host
var name_server_address:String setget _readonly, _get_name_server_address
## 端口重写(自己搭服务器时才有意义）
var name_server_port_override:int setget _set_name_server_port_override, _get_name_server_port_override
var master_server_port_override:int setget _set_master_server_port_override, _get_master_server_port_override
var game_server_port_override:int setget _set_game_server_port_override, _get_game_server_port_override
var enable_protocol_fallback:bool setget _set_enable_protocol_fallback, _get_enable_protocol_fallback
var current_server_address:String setget _readonly, _get_current_server_address
var master_server_address:String  setget _set_master_server_address, _get_master_server_address
var game_server_address:String  setget _readonly, _get_game_server_address
## 指示当前连接的服务器类型 通过 Photon.ServerConnection 枚举进行查询
## 根据连接的服务器类型不同，客户端能进行的操作也不同，执行非当前连接的服务器类型允许是操作将会被回绝
var server:int setget _readonly, _get_server
var proxy_server_address:String setget _set_proxy_server_address,_get_proxy_server_address
var state:int setget _set_state,_get_state
var is_realtime_connected setget _readonly, _is_realtime_connected 
var is_connected_and_ready setget _readonly, _is_connected_and_ready
var disconnected_cause setget _readonly, _get_disconnected_cause
var in_lobby :bool setget _readonly, is_in_lobby
var current_lobby:TypedLobby setget _readonly
# 连接前设置
var enable_lobby_statistics:bool setget _set_enable_lobby_statistics , _get_enable_lobby_statistics
var local_player:PhotonPlayer setget _readonly, _get_local_player
var nick_name:String setget _set_nick_name,_get_nick_name
# 连接前设置
var user_id:String setget _set_user_id,_get_user_id
var current_room:PhotonRoom setget _readonly,_get_current_room
var in_room:bool setget _readonly, is_in_room
# 大厅统计参数
var players_on_master_count :int setget _readonly, _get_players_on_master_count
var players_in_rooms_count :int setget _readonly, _get_players_in_rooms_count
var rooms_count :int setget _readonly, _get_rooms_count

var is_fetching_friendlist:bool setget _readonly, _get_is_fetching_friendlist
var cloud_region:String setget _readonly, _get_cloud_region
var current_cluster:String setget _readonly, _get_current_cluster
var region_handler:RegionHandler setget _readonly , _get_region_handler
## region_handler.SummaryToCache 的缓存，虽然可以设置他的值，但是在内部没有意义
var summary_to_cache:String setget _set_summary_to_cache, _get_summary_to_cache

## 1.
## 	<summary>Creates a LoadBalancingClient with UDP protocol or the one specified.</summary>
## 	<param name="protocol">Specifies the network protocol to use for connections.</param>
## 2.
## 	<summary>Creates a LoadBalancingClient, setting various values needed before connecting.</summary>
## 	<param name="protocol">Specifies the network protocol to use for connections.</param>
## 	<param name="masterAddress">The Master Server's address to connect to. Used in Connect.</param>
## 	<param name="appId">The AppId of this title. Needed for the Photon Cloud. Find it in the Dashboard.</param>
## 	<param name="gameVersion">A version for this client/build. In the Photon Cloud, players are separated by AppId, GameVersion and Region.</param>
func _init(connection_protocol:= Photon.ConnectionProtocol.UDP,
		master_address:="",app_id:="",game_version:="") -> void:
	assert(connection_protocol in Photon.ConnectionProtocol.values(),"非法的连接协议")
	assert((master_address=="" and app_id == "" and game_version=="") or \
		(master_address!="" and app_id != "" and game_version!=""),"非法的输入参数")
	if master_address=="" and app_id == "" and game_version=="":
		_base.init(connection_protocol)
	elif master_address!="" and app_id != "" and game_version!="":
		_base.init(master_address,app_id,game_version,connection_protocol)
	else:
		assert(false,"非法的输入参数")
		free()
		return
	_connect_internal_signal()
		
## needed connect variants:
## connect to Name Server only (could include getregions) -> end after getregions
## connect to Region Master via Name Server (specific region/cluster) -> no getregions! authenticates and ends after on connected to master
## connect to Best Region via Name Server
## connect to Master Server (no Name Server, no appid)
func connect_using_settings(app_setting:AppSettings)->bool:
	return _base.ConnectUsingSettings(app_setting._base)

## <summary>
## Starts the "process" to connect to a Master Server, using MasterServerAddress and AppId properties.
##
## To connect to the Photon Cloud, use ConnectUsingSettings() or ConnectToRegionMaster().
## 
## The process to connect includes several steps: the actual connecting, establishing encryption, authentification
## (of app and optionally the user) and connecting to the MasterServer
##
## Users can connect either anonymously or use "Custom Authentication" to verify each individual player's login.
## Custom Authentication in Photon uses external services and communities to verify users. While the client provides a user's info,
## the service setup is done in the Photon Cloud Dashboard.
## The parameter authValues will set this.AuthValues and use them in the connect process.
##
## Connecting to the Photon Cloud might fail due to:
## - Network issues (OnStatusChanged() StatusCode.ExceptionOnConnect)
## - Region not available (OnOperationResponse() for OpAuthenticate with ReturnCode == ErrorCode.InvalidRegion)
## - Subscription CCU limit reached (OnOperationResponse() for OpAuthenticate with ReturnCode == ErrorCode.MaxCcuReached)
func connect_to_master_server()->bool:
	return _base.ConnectToMasterServer()

## Connects to the NameServer for Photon Cloud, where a region and server list can be obtained.
##
## <see cref="OpGetRegions"/>
## <returns>If the workflow was started or failed right away.</returns>
func connect_to_name_server()->bool:
	return _base.ConnectToNameServer()

## Connects you to a specific region's Master Server, using the Name Server to find the IP.
##
## If the region is null or empty, no connection will be made.
## If the region (code) provided is not available, the connection process will fail on the Name Server.
## This method connects only to the region defined. No "Best Region" pinging will be done.
##
## If the region string does not contain a "/", this means no specific cluster is requested.
## To support "Sharding", the region gets a "/*" postfix in this case, to select a random cluster.
## <returns>If the operation could be sent. If false, no operation was sent.</returns>
func connect_to_region_master()->bool:
	return _base.ConnectToRegionMaster()
	
## Can be used to reconnect to the master server after a disconnect.
## Common use case: Press the Lock Button on a iOS device and you get disconnected immediately.
func reconnect_to_master()->bool:
	return _base.ReconnectToMaster()
	
## Can be used to return to a room quickly by directly reconnecting to a game server to rejoin a room.
##
## Rejoining room will not send any player properties. Instead client will receive up-to-date ones from server.
## If you want to set new player properties, do it once rejoined.
## <returns>False, if the conditions are not met. Then, this client does not attempt the ReconnectAndRejoin.
func reconnect_and_rejoin()->bool:
	return _base.ReconnectAndRejoin()
	
## Useful to test loss of connection which will end in a client timeout. This modifies LoadBalancingPeer.NetworkSimulationSettings. Read remarks.
##
## Use with care as this sets LoadBalancingPeer.IsSimulationEnabled.<br/>
## Read LoadBalancingPeer.IsSimulationEnabled to check if this is on or off, if needed.<br/>
##
## If simulateTimeout is true, LoadBalancingPeer.NetworkSimulationSettings.IncomingLossPercentage and
## LoadBalancingPeer.NetworkSimulationSettings.OutgoingLossPercentage will be set to 100.<br/>
## Obviously, this overrides any network simulation settings done before.<br/>
##
## If you want fine-grained network simulation control, use the NetworkSimulationSettings.<br/>
##
## The timeout will lead to a call to <see cref="IConnectionCallbacks.OnDisconnected"/>, as usual in a client timeout.
##
## You could modify this method (or use NetworkSimulationSettings) to deliberately run into a server timeout by
## just setting the OutgoingLossPercentage = 100 and the IncomingLossPercentage = 0.
## <param name="simulateTimeout">If true, a connection loss is simulated. If false, the simulation ends.</param>
func simulate_connection_loss(simulate_timeout:bool) ->bool:
	return _base.SimulateConnectionLoss(simulate_timeout)
	
## Disconnects the peer from a server or stays disconnected. If the client / peer was connected, a callback will be triggered.
##
## Disconnect will attempt to notify the server of the client closing the connection.
##
## Clients that are in a room, will leave the room. If the room's playerTTL &gt; 0, the player will just become inactive (and may rejoin).
##
## This method will not change the current State, if this client State is PeerCreated, Disconnecting or Disconnected.
## In those cases, there is also no callback for the disconnect. The DisconnectedCause will only change if the client was connected.
func disconnect_server(cause:=Photon.RealtimeDisconnectCause.DisconnectByClientLogic)->void:
	_base.Disconnect(cause)

## This method dispatches all available incoming commands and then sends this client's outgoing commands.
## It uses DispatchIncomingCommands and SendOutgoingCommands to do that.
##
## The Photon client libraries are designed to fit easily into a game or application. The application
## is in control of the context (thread) in which incoming events and responses are executed and has
## full control of the creation of UDP/TCP packages.
##
## Sending packages and dispatching received messages are two separate tasks. Service combines them
## into one method at the cost of control. It calls DispatchIncomingCommands and SendOutgoingCommands.
##
## Call this method regularly (10..50 times a second).
##
## This will Dispatch ANY received commands (unless a reliable command in-order is still missing) and
## events AND will send queued outgoing commands. Fewer calls might be more effective if a device
## cannot send many packets per second, as multiple operations might be combined into one package.
## </remarks>
## <example>
## You could replace Service by:
##
##     while (DispatchIncomingCommands()); //Dispatch until everything is Dispatched...
##     SendOutgoingCommands(); //Send a UDP/TCP package with outgoing messages
## </example>
## <seealso cref="PhotonPeer.DispatchIncomingCommands"/>
## <seealso cref="PhotonPeer.SendOutgoingCommands"/>
func service()->void:
	_base.Service()

## 摘要:
##     Dispatching received messages (commands), causes callbacks for events, responses
##     and state changes within a IPhotonPeerListener.
##
## 言论：
##     DispatchIncomingCommands only executes a single received command per call. If
##     a command was dispatched, the return value is true and the method should be called
##     again. This method is called by Service() until currently available commands
##     are dispatched. In general, this method should be called until it returns false.
##     In a few cases, it might make sense to pause dispatching (if a certain state
##     is reached and the app needs to load data, before it should handle new events).
##     The callbacks to the peer's IPhotonPeerListener are executed in the same thread
##     that is calling DispatchIncomingCommands. This makes things easier in a game
##     loop: Event execution won't clash with painting objects or the game logic.
func dispatch_incoming_commands()->bool:
	return _base.DispatchIncomingCommands()
		
		
## 摘要:
##     Creates and sends a UDP/TCP package with outgoing commands (operations and acknowledgements).
##     Also called by Service().
##
## 返回结果:
##     The if commands are not yet sent. Udp limits it's package size, Tcp doesnt.
##
## 言论：
##     As the Photon library does not create any UDP/TCP packages by itself. Instead,
##     the application fully controls how many packages are sent and when. A tradeoff,
##     an application will lose connection, if it is no longer calling SendOutgoingCommands
##     or Service. If multiple operations and ACKs are waiting to be sent, they will
##     be aggregated into one package. The package fills in this order: ACKs for received
##     commands A "Ping" - only if no reliable data was sent for a while Starting with
##     the lowest Channel-Nr: Reliable Commands in channel Unreliable Commands in channel
##     This gives a higher priority to lower channels. A longer interval between sends
##     will lower the overhead per sent operation but increase the internal delay (which
##     adds "lag"). Call this 2..20 times per second (depending on your target platform).
func send_outgoing_commands()->bool:
	return _base.SendOutgoingCommands()




func change_local_id(new_id:int)->void: _base.ChangeLocalID(new_id)

func op_change_groups(groups_to_remove:PoolByteArray,group_to_add:PoolByteArray)->bool:
	return _base.OpChangeGroups(groups_to_remove,group_to_add)
	
func op_create_room(create_room_params:EnterRoomParams)->bool: 
	return _base.OpCreateRoom(create_room_params._base if create_room_params else null)

func op_join_lobby(typed_lobby:TypedLobby)->bool:
	var res:bool = _base.OpJoinLobby(typed_lobby._base)
	if res:
		current_lobby = typed_lobby
	return res

func op_join_or_create_room(enter_room_params:EnterRoomParams)->bool: 
	return _base.OpJoinOrCreateRoom(enter_room_params._base if enter_room_params else null)
	
func op_join_random_or_create_room(op_join_random_room_params:OpJoinRandomRoomParams, create_room_params:EnterRoomParams)->bool:
	return _base.OpJoinRandomOrCreateRoom(
			op_join_random_room_params._base if op_join_random_room_params else null , 
			create_room_params._base if create_room_params else null)

func op_join_random_room(op_join_random_room_params:OpJoinRandomRoomParams)->bool:
	return _base.OpJoinRandomRoom(op_join_random_room_params._base if op_join_random_room_params else null)

func op_join_room(enter_room_params:EnterRoomParams)->bool:
	return _base.OpJoinRoom(enter_room_params._base if enter_room_params else null)
	
func op_leave_lobby()->bool:
	return _base.OpLeaveLobby()

func op_leave_room(become_inactive:bool,send_auth_cookie:=false)->bool:
	return _base.OpLeaveRoom(become_inactive,send_auth_cookie)
	
func op_rejoin_room(room_name:String)->bool:
	return _base.OpRejoinRoom(room_name)	
	
func op_set_custom_properties_of_actor( actor_number:int, properties_to_set:Dictionary,
		expected_properties:Dictionary = {}, web_flags:WebFlags = null)->bool:
	return _base.OpSetCustomPropertiesOfActor(actor_number, properties_to_set, 
			null if expected_properties.empty() else expected_properties , web_flags._base if web_flags else null)
			
func op_set_custom_properties_of_room(properties_to_set:Dictionary, expected_properties:={}, web_flags:WebFlags = null )->bool:
	return _base.OpSetCustomPropertiesOfRoom(properties_to_set, null if expected_properties.empty() else expected_properties,  web_flags._base if web_flags else null)

func op_web_rpc(uri_path:String, parameters,  send_auth_cookie:= false)->bool:
	return _base.OpWebRpc(uri_path, parameters, send_auth_cookie)
	
func op_raise_event(event_code:int, custom_event_content, 
		raise_event_options:RaiseEventOptions, 
		send_options: SendOptions )->bool:
	assert(event_code>=0 and event_code<200,"非法的自定义事件代号")
	return _base.OpRaiseEvent(event_code, custom_event_content, raise_event_options._base, send_options._base)
	
	
func op_find_friends(friends_to_find:PoolStringArray, 
		has_options := false, created_on_gs := false, visible := false, open := false)->bool:
	return _base.OpFindFriends(friends_to_find, has_options, created_on_gs, visible, open)

func op_get_game_list(lobby:TypedLobby,sql_lobby_filter:String)->bool:
	return _base.OpGetGameList(lobby._base, sql_lobby_filter)
	
	








# 内部包装

const _Base = preload("../src/PhotonRealtimeClient.cs")
var _base:_Base = _Base.new()

# setget
func _set_summary_to_cache(v:String):_base.set_SummaryToCache(v)
func _get_summary_to_cache()->String :return _base.get_SummaryToCache()
func _get_region_handler()->RegionHandler: return _base.get_GDSRegionHandler()
func _get_current_cluster()->String:return _base.get_CurrentCluster()
func _get_cloud_region()->String:return _base.get_CloudRegion()
func _get_is_fetching_friendlist()->bool:return _base.get_IsFetchingFriendList()
func _get_rooms_count()->int:return _base.get_RoomsCount()
func _get_players_in_rooms_count()->int:return _base.get_PlayersInRoomsCount()
func _get_players_on_master_count()->int:return _base.get_PlayersOnMasterCount()
func is_in_room()->bool:return _base.get_InRoom()
func _get_current_room()->PhotonRoom:return _base.get_CurrentGDSRoom()
func _set_user_id(v:String)->void: _base.set_UserId(v)
func _get_user_id()->String: return _base.get_UserId()
func _set_nick_name(v:String)->void: _base.set_NickName(v)
func _get_nick_name()->String: return _base.get_NickName()
func _get_local_player()->PhotonPlayer: 
	return _base.get_LocalGDSPlayer()
func _set_enable_lobby_statistics(v:bool)->void: _base.set_EnableLobbyStatistics(v)
func _get_enable_lobby_statistics()->bool: return _base.get_EnableLobbyStatistics()
func is_in_lobby()->bool:return _base.get_InLobby()
func _get_disconnected_cause()->int:return _base.get_DisconnectedCause()
func _is_connected_and_ready()->bool:return _base.get_IsConnectedAndReady()
func _is_realtime_connected()->bool:return _base.get_IsRealtimeConnected()
func _set_state(v:int)->void: 
	assert(v in Photon.ClientState.values(),"非法的客户端状态")
	_base.set_State(v)
func _get_state()->int:return _base.get_State()
func _set_proxy_server_address(v:String)->void: _base.set_ProxyServerAddress(v)
func _get_proxy_server_address()->String:return _base.get_ProxyServerAddress()
func _get_server()->int:return _base.get_Server()
func _get_game_server_address()->String:return _base.get_GameServerAddress()
func _set_master_server_address(v:String): _base.set_MasterServerAddress(v)
func _get_master_server_address()->String: return _base.get_MasterServerAddress()
func _get_current_server_address()->String:return _base.get_CurrentServerAddress()
func _set_enable_protocol_fallback(v:bool)->void: _base.set_EnableProtocolFallback(v)
func _get_enable_protocol_fallback()->bool: return _base.get_EnableProtocolFallback()
func _set_game_server_port_override(v:int)->void:
	assert(v>=0,"非法端口号")
	_base.set_GameServerPortOverride(v)
func _get_game_server_port_override()->int:return _base.get_GameServerPortOverride()
func _set_name_server_port_override(v:int)->void:
	assert(v>=0,"非法端口号")
	_base.set_NameServerPortOverride(v)
func _get_name_server_port_override()->int:return _base.get_NameServerPortOverride()
func _set_master_server_port_override(v:int)->void:
	assert(v>=0,"非法端口号")
	_base.set_MasterServerPortOverride(v)
func _get_master_server_port_override()->int:return _base.get_MasterServerPortOverride()
func _get_name_server_address()->String: return _base.get_NameServerAddress()
func _set_name_server_host(v:String)->void:_base.set_NameServerHost(v)
func _get_name_server_host()->String:return _base.get_NameServerHost()
func _set_using_name_server(v:bool)->void:
	_base.set_IsUsingNameServer(v)
func _is_using_name_server()->bool:return _base.get_IsUsingNameServer()
func _set_expected_protocol(v:int)->void:
	assert(v in Photon.ConnectionProtocol.values(),"非法的连接协议")
	_base.set_ExpectedProtocol(v)
func _get_expected_protocol()->int:return _base.get_ExpectedProtocol()
func _set_encryption_mode(v:int)->void:
	assert(v in Photon.EncryptionMode.values(),"非法的加密模式")
	_base.set_EncryptionMode(v)
func _get_encryption_mode()->int: return _base.get_EncryptionMode()
func _set_auth_mode(v:int)->void:
	assert(v in Photon.AuthModeOption.values(),"非法的验证模式")
	_base.set_AuthMode(v)
func _get_auth_mode()->int:return _base.get_AuthMode()
func _set_auth_values(v:RealtimeAuthenticationValues)->void: _base.set_GDSAuthValues(v)
func _get_auth_values()->RealtimeAuthenticationValues:return _base.get_GDSAuthValues()
func _set_client_type(v:int)->void:
	assert(v in Photon.ClientAppType.values(),"非法的客户端应用类型")
	_base.set_ClientType(v)
func _get_client_type()->int: return _base.get_ClientType()
func _set_app_id(v:String)->void:_base.set_AppId(v)
func _get_app_id()->String:return _base.get_AppId()
func _set_app_version(v:String)->void: _base.set_AppVersion(v)
func _get_app_version()->String:return _base.get_AppVersion()
func _set_serialization_protocol(v:int)->void:
	assert(v in Photon.SerializationProtocol.values(),"非法的序列化协议")
	_base.set_SerializationProtocol(v)
func _get_serialization_protocol()->int:return _base.get_SerializationProtocol()

func _set_bg_send(v:bool)->void: 
	_base.set_BGSend(v)
func _get_bg_send()->bool: return _base.get_BGSend()
func _set_bg_dispatch(v:bool)->void: _base.set_BGDispatch(v)
func _get_bg_dispatch()->bool: return _base.get_BGDispatch()
func _set_bg_send_interval_ms(v:int)->void: _base.set_BGSendIntervalMs(v)
func _get_bg_send_interval_ms()->int: return _base.get_BGSendIntervalMs()
func _set_bg_dispatch_interval_ms(v:int)->void: _base.set_BGDispatchIntervalMs(v)
func _get_bg_dispatch_interval_ms()->int: return _base.get_BGDispatchIntervalMs()
func _set_bg_send_single(v:bool)->void: _base.set_BGSendSingle(v)
func _get_bg_send_single()->bool: return _base.get_BGSendSingle()
func _set_bg_dispatch_single(v:bool)->void: _base.set_BGDispatchSingle(v)
func _get_bg_dispatch_single()->bool: return _base.get_BGDispatchSingle()
func _set_reuse_event_instance(v:bool)->void:_base.set_ReuseEventInstance(v)
func _get_reuse_event_instance()->bool:return _base.get_ReuseEventInstance()
func _set_notify_when_idle(v:bool):
	notify_when_idle = v
	if v: _call_group_flags = SceneTree.GROUP_CALL_DEFAULT
	else: _call_group_flags = SceneTree.GROUP_CALL_REALTIME
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
	
var _tree:SceneTree
var _call_group_flags:int = SceneTree.GROUP_CALL_DEFAULT
func _connect_internal_signal()->void:
	connect("tree_entered",self,"_on_tree_entered")
	connect("tree_exited",self,"_on_tree_exited")
	_base.connect("OpResponseReceived",self,"_on_OpResponseReceived")
	_base.connect("EventReceived",self,"_on_EventReceived")
	_base.connect("StateChanged",self,"_on_StateChanged")
	_base.connect("Connected",self,"_on_Connected")
	_base.connect("ConnectedToMaster",self,"_on_ConnectedToMaster")
	_base.connect("CustomAuthenticationFailed",self,"_on_CustomAuthenticationFailed")
	_base.connect("CustomAuthenticationResponsed",self,"_on_CustomAuthenticationResponsed")
	_base.connect("Disconnected",self,"_on_Disconnected")
	_base.connect("RegionListReceived",self,"_on_RegionListReceived")
	_base.connect("ErrorInfoReveived",self,"_on_ErrorInfoReveived")
	_base.connect("WebRpcResponsed",self,"_on_WebRpcResponsed")
	_base.connect("RoomCreated",self,"_on_RoomCreated")
	_base.connect("RoomJoined",self,"_on_RoomJoined")
	_base.connect("CreateRoomFailed",self,"_on_CreateRoomFailed")
	_base.connect("JoinRoomFailed",self,"_on_JoinRoomFailed")
	_base.connect("JoinRandomFailed",self,"_on_JoinRandomFailed")
	_base.connect("RoomLefting",self,"_on_RoomLefting")
	_base.connect("FriendListUpdated",self,"_on_FriendListUpdated")
	_base.connect("PlayerRoomEntered",self,"_on_PlayerRoomEntered")
	_base.connect("PlayerRoomLefting",self,"_on_PlayerRoomLefting")
	_base.connect("RoomPropertiesUpdated",self,"_on_RoomPropertiesUpdated")
	_base.connect("PlayerPropertiesUpdated",self,"_on_PlayerPropertiesUpdated")
	_base.connect("MasterClientSwitched",self,"_on_MasterClientSwitched")
	_base.connect("LobbyJoined",self,"_on_LobbyJoined")
	_base.connect("LobbyLefting",self,"_on_LobbyLefting")
	_base.connect("RoomListUpdated",self,"_on_RoomListUpdated")
	_base.connect("LobbyStatisticsUpdated",self,"_on_LobbyStatisticsUpdated")




func _on_OpResponseReceived(operationResponse)->void:#:OperationResponse._Base
	OperationResponse._Prefeb._UNIQUE._base = operationResponse
	_on_op_response_received(OperationResponse._Prefeb._UNIQUE)
	emit_signal("op_response_received",OperationResponse._Prefeb._UNIQUE)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"response_received", _get_local_player().actor_number,
			OperationResponse._Prefeb._UNIQUE)

func _on_EventReceived(eventData)->void:#:EventData._Base
	var event_data := EventData._get_event_data(eventData)
	_on_event_received(event_data)
	emit_signal("event_received",event_data)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"event_received", _get_local_player().actor_number,
			event_data)
	
func _on_StateChanged(previousState:int,currentState:int)->void:
	_on_state_changed(previousState,currentState)
	emit_signal("state_changed",previousState,currentState)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"state_changed", _get_local_player().actor_number,
			previousState, currentState)	

func _on_Connected()->void:
	_on_connected()
	emit_signal("connected")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"connected", _get_local_player().actor_number)
	
func _on_ConnectedToMaster()->void:
	_on_connected_to_master()
	emit_signal("connected_to_master")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"connected_to_master", _get_local_player().actor_number)
	
func _on_CustomAuthenticationFailed(debugMessage:String)->void:
	_on_custom_authentication_failed(debugMessage)
	emit_signal("custom_authentication_failed",debugMessage)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"custom_authentication_failed", _get_local_player().actor_number, debugMessage)
	
func _on_CustomAuthenticationResponsed(data:Dictionary)->void:
	_on_custom_authentication_responsed(data)
	emit_signal("custom_authentication_responsed",data)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"custom_authentication_responsed", _get_local_player().actor_number, data)
	
func _on_Disconnected(cause:int)->void:
	_on_disconnected(cause)
	emit_signal("disconnected",cause)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"disconnected", _get_local_player().actor_number, cause)
	
func _on_RegionListReceived(regionHandler:RegionHandler)->void:
	_on_region_list_received(regionHandler)
	emit_signal("region_list_received",regionHandler)	
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"region_list_received", _get_local_player().actor_number, regionHandler)
	
func _on_ErrorInfoReveived(error_info)->void:#:ErrorInfo._Base
	_on_error_info_reveived(ErrorInfo._Internal.UniqueInstance)
	emit_signal("error_info_reveived", ErrorInfo._Internal.UniqueInstance)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"error_info_reveived", _get_local_player().actor_number, ErrorInfo._Internal.UniqueInstance)

func _on_WebRpcResponsed(response)->void:#:WebRpcResponse._Base
	_on_web_rpc_responsed(WebRpcResponse._Internal.UniqueInstance)
	emit_signal("web_rpc_responsed", WebRpcResponse._Internal.UniqueInstance)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"web_rpc_responsed", _get_local_player().actor_number, WebRpcResponse._Internal.UniqueInstance)
	
func _on_RoomCreated()->void:
	_on_room_created()
	emit_signal("room_created")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"room_created", _get_local_player().actor_number)

func _on_RoomJoined()->void:
	_on_room_joined()
	emit_signal("room_joined")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"room_joined", _get_local_player().actor_number)
	
func _on_CreateRoomFailed(returnCode:int, message:String)->void:
	_on_create_room_failed(returnCode,message)
	emit_signal("create_room_failed",returnCode,message)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"create_room_failed", _get_local_player().actor_number,returnCode,message)

func _on_JoinRoomFailed(returnCode:int, message:String)->void:
	_on_join_room_failed(returnCode,message)
	emit_signal("join_room_failed",returnCode,message)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"join_room_failed", _get_local_player().actor_number,returnCode,message)
	
func _on_JoinRandomFailed(returnCode:int, message:String)->void:
	_on_join_random_failed(returnCode, message)
	emit_signal("join_random_failed",returnCode,message)	
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"join_random_failed", _get_local_player().actor_number,returnCode,message)
	
func _on_RoomLefting()->void:
	_on_room_lefting()
	emit_signal("room_lefting")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"room_lefting", _get_local_player().actor_number)
	
func _on_FriendListUpdated(friendList:Array)->void:
	_on_friend_list_updated(friendList)
	emit_signal("friend_list_updated",friendList)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"friend_list_updated", _get_local_player().actor_number,friendList)

func _on_PlayerRoomEntered(newPlayer:PhotonPlayer)->void:
	_on_player_room_entered(newPlayer)
	emit_signal("player_room_entered",newPlayer)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"player_room_entered", _get_local_player().actor_number,newPlayer)

func _on_PlayerRoomLefting(otherPlayer:PhotonPlayer)->void:
	_on_player_room_lefting(otherPlayer)
	emit_signal("player_room_lefting",otherPlayer)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"player_room_lefting", _get_local_player().actor_number,otherPlayer)
	
func _on_RoomPropertiesUpdated(changedProps:Dictionary)->void:
	_on_room_properties_updated(changedProps)
	emit_signal("room_properties_updated",changedProps)	
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"room_properties_updated", _get_local_player().actor_number,changedProps)
	
func _on_PlayerPropertiesUpdated(targetPlayer:PhotonPlayer,changedProps:Dictionary)->void:
	_on_player_properties_updated(targetPlayer,changedProps)
	emit_signal("player_properties_updated",targetPlayer,changedProps)	
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"player_properties_updated", _get_local_player().actor_number,targetPlayer, changedProps)
	
func _on_MasterClientSwitched(newMasterClient:PhotonPlayer)->void:
	_on_master_client_switched(newMasterClient)
	emit_signal("master_client_switched",newMasterClient)	
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"master_client_switched", _get_local_player().actor_number,newMasterClient)
	
func _on_LobbyJoined()->void:
	_on_lobby_joined()
	emit_signal("lobby_joined")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"lobby_joined", _get_local_player().actor_number)
	
func _on_LobbyLefting()->void:
	_on_lobby_lefting()
	emit_signal("lobby_lefting")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"lobby_lefting", _get_local_player().actor_number)
		
func _on_RoomListUpdated(roomList:Array)->void:
	_on_room_list_updated(roomList)
	emit_signal("room_list_updated",roomList)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"room_list_updated", _get_local_player().actor_number,roomList)
	
func _on_LobbyStatisticsUpdated(lobbyStatistics:Array)->void:
	_on_lobby_statistics_updated(lobbyStatistics)
	emit_signal("lobby_statistics_updated",lobbyStatistics)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"lobby_statistics_updated", _get_local_player().actor_number,lobbyStatistics)



func _on_tree_entered()->void:
	_tree = get_tree()
func _on_tree_exited()->void:
	_tree = null
	
func _need2call_group()->bool:
	return notify_group and is_inside_tree() 
