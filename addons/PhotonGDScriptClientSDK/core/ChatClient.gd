## 当你使用继承从方式实现时
## 由于 Godot 3.x 父类对子类没有封装的概念
## 确保你对该类的属性通过 .prop 或 self.prop 进行访问（通过访问器）
extends Node
## 很多地方 user_id 还是 user_name 还搞不清楚
## 因为 原版的 C# Photon Chat SDK 方法 也是有些 userName 有些 userID
## 但是全部统一成 user_id 了
## 因为 原版的 C# Photon Chat SDK 中 只有 UserID 属性, 所以猜测使用 userName 作为变量名的地方是没改过来 
class_name ChatClient
const CALLBACK_GROUP_NAME = "_cc_callbacks"
const CALLBACK_PREFIX = "_on_cc_"




signal debug_retun_message(level, debug_message) # int(Photon.DebugLevel) , string 
signal connected()
signal disconnected()
signal state_changed(current_state) # int( Photon.ChatState)
signal message_received(channel_name, senders, message) # string, PoolStringArray, Array
signal private_message_received(sender, message, channel_name) # string ,obj , string 
signal subscribed(channels, results) # PoolStringArray , Array<bool>
signal unsubscribed(channels) # PoolStringArray
signal status_updated(user_id, status, got_message, status_message) # string, int , bool , obj
signal user_subscribed(channel_name, user_id) # string, string
signal user_unsubscribed(channel_name ,uset_id) #string,string

## 以下信号暂不可用
signal channel_properties_changed(channel_name, sender_user_id, properties) # string, string, dict<string,obj> 
signal user_properties_changed(channel_name, target_user_id, sender_user_id, properties) # string ,string ,string, dict<string,obj>
signal error_info_received(channel_name, error, data)# string, string, obj
signal broadcast_message_received(channel_name, message)#string ,PoolByteArray



## 以下为信号回调
func _on_debug_retun_message(level:int,debug_message:String)->void:pass
func _on_connected()->void:pass
func _on_disconnected()->void:pass
func _on_state_changed(current_state)->void:pass
func _on_message_received(channel_name:String, senders:PoolStringArray, messages:Array)->void:pass # Array<obj>
func _on_private_message_received(sender:String, message, channel_name:String)->void:pass
func _on_subscribed(channels:PoolStringArray, results:Array)->void:pass # Array<bool>
func _on_unsubscribed(channels:PoolStringArray)->void:pass
func _on_status_updated(user_id:String, status:int, got_message:bool, status_message)->void:pass
func _on_user_subscribed(channel_name:String, user_id:String)->void:pass
func _on_user_unsubscribed(channel_name:String, user_id:String)->void:pass
# 以下回调暂未使用
func _on_channel_properties_changed(channel:String, sender_user_id:String, properties:Dictionary)->void:pass
func _on_user_properties_changed(channel:String, target_user_id:String, sender_user_id:String, properties:Dictionary)->void:pass
func _on_error_info_received(channel:String, error:String, data)->void:pass
func _on_broadcast_message_received(channel:String, message:PoolByteArray)->void:pass


## true - 如果在场景树中，在发送信号之后会调用加入到 ChatClient.CALLBACK_GROUP_NAME 组(Group)的对象中的相应的回调方法
##		回调方法为 对应信号名加前缀 "_on_cc_", 方法参数为 ChatClient.user_id 和 信号携带的参数。
##		注意 回调 是在空闲时
## 当你的设计中可能同时存在多个在场景树中 ChatClient 对象时,回调方法的第一个参数将可用于区分具体是那个 ChatClient 对象发出的。
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
var reuse_event_instance:bool setget _set_reuse_event_instance, _get_reuse_event_instance

## <summary>Enables a fallback to another protocol in case a connect to the Name Server fails.</summary>
## <remarks>
## When connecting to the Name Server fails for a first time, the client will select an alternative
## network protocol and re-try to connect.
##
## The fallback will use the default Name Server port as defined by ProtocolToNameServerPort.
##
## The fallback for TCP is UDP. All other protocols fallback to TCP.
## </remarks>
var enable_protocol_fallback :bool setget _set_enable_protocol_fallback,_get_enable_protocol_fallback
## <summary>The address of last connected Name Server.</summary>
var name_server_address:String setget _readonly,_get_name_server_address
## <summary>The address of the actual chat server assigned from NameServer. Public for read only.</summary>
var frontend_address:String setget _readonly,_get_frontend_address
## <summary>Settable only before you connect! Defaults to "EU".</summary>
var chat_region:String setget _set_chat_region, _get_chat_region
## <summary>The version of your client. A new version also creates a new "virtual app" to separate players from older client versions.</summary>
var app_version:String setget _readonly, _get_app_version
## <summary>The AppID as assigned from the Photon Cloud.</summary>
var app_id:String setget _readonly, _get_app_id

		
## <summary>Settable only before you connect!</summary>
## <summary>User authentication values to be sent to the Photon server right after connecting.</summary>
## <remarks>Set this property or pass AuthenticationValues by Connect(..., authValues).</remarks>
var auth_values :ChatAuthenticationValues setget _set_auth_values,_get_auth_values
## Current state of the ChatClient. Also use CanChat.
## Photon.ChatState
var state:int setget _readonly, _get_state
## Disconnection cause. Check this inside <see cref="IChatClientListener.OnDisconnected"/>.
## Photon.ChatDisconnectCause
var disconnected_cause:int setget _readonly, _get_disconnected_cause
## Checks if this client is ready to send messages.
var can_chat:bool setget _readonly, _get_can_chat
## <summary>The unique ID of a user/person, stored in AuthValues.UserId. Set it before you connect.</summary>
## <remarks>
## This value wraps AuthValues.UserId.
## It's not a nickname and we assume users with the same userID are the same person.</remarks>
var user_id:String setget _readonly, _get_user_id
## <summary>If greater than 0, new channels will limit the number of messages they cache locally.</summary>
## <remarks>
## This can be useful to limit the amount of memory used by chats.
## You can set a MessageLimit per channel but this value gets applied to new ones.
##
## Note:
## Changing this value, does not affect ChatChannels that are already in use!
## </remarks>
var message_limit:int setget _set_message_list,_get_message_list
## <summary>Limits the number of messages from private channel histories.</summary>
## <remarks>
## This is applied to all private channels on reconnect, as there is no explicit re-joining private channels.<br/>
## Default is -1, which gets available messages up to a maximum set by the server.<br/>
## A value of 0 gets you zero messages.<br/>
## The server's limit of messages may be lower. If so, the server's value will overrule this.<br/>
## </remarks>
var private_chat_history_length:int setget _set_private_chat_history_length, _get_private_chat_history_length
## Public channels this client is subscribed to.
## Dict<channel_name:str , ChatChannel>
var public_channels:Dictionary setget _readonly, _get_public_channels
## Private channels in which this client has exchanged messages.
## Dict<channel_name:str , ChatChannel>
var private_channels:Dictionary setget _readonly, _get_private_channels
## Exposes the TransportProtocol of the used PhotonPeer. Settable while not connected.
var transport_protocol:int setget _set_transport_protocol, _get_transport_protocol
## <summary>
## Sets the level (and amount) of debug output provided by the library.
## </summary>
## <remarks>
## This affects the callbacks to IChatClientListener.DebugReturn.
## Default Level: Error.
## </remarks>
var debug_out:int setget _set_debug_out, _get_debug_out


## <summary>
## Chat client constructor.
## </summary>
## <param name="protocol">Connection protocol to be used by this client. Default is <see cref="ConnectionProtocol.Udp"/>.</param>
func _init(protocol=Photon.ConnectionProtocol.UDP) -> void:
	_base.init(protocol)
	_connect_internal_signal()


func ConnectUsingSettings(chat_app_settings:ChatAppSettings)->bool:
	return _base.ConnectUsingSettings(chat_app_settings._base)
	
## <summary>
## Connects this client to the Photon Chat Cloud service, which will also authenticate the user (and set a UserId).
## </summary>
## <param name="appId">Get your Photon Chat AppId from the <a href="https:##dashboard.photonengine.com">Dashboard</a>.</param>
## <param name="appVersion">Any version string you make up. Used to separate users and variants of your clients, which might be incompatible.</param>
## <param name="authValues">Values for authentication. You can leave this null, if you set a UserId before. If you set authValues, they will override any UserId set before.</param>
## <returns></returns>
func connect_server(app_id:String, app_version:String, auth_values:ChatAuthenticationValues)->bool:
	return _base.Connect(app_id, app_version, auth_values)
	
## <summary>
## Connects this client to the Photon Chat Cloud service, which will also authenticate the user (and set a UserId).
## This also sets an online status once connected. By default it will set user status to <see cref="ChatUserStatus.Online"/>.
## See <see cref="SetOnlineStatus(int,object)"/> for more information.
## </summary>
## <param name="appId">Get your Photon Chat AppId from the <a href="https:##dashboard.photonengine.com">Dashboard</a>.</param>
## <param name="appVersion">Any version string you make up. Used to separate users and variants of your clients, which might be incompatible.</param>
## <param name="authValues">Values for authentication. You can leave this null, if you set a UserId before. If you set authValues, they will override any UserId set before.</param>
## <param name="status">User status to set when connected. Predefined states are in class <see cref="ChatUserStatus"/>. Other values can be used at will.</param>
## <param name="message">Optional status Also sets a status-message which your friends can get.</param>
## <returns>If the connection attempt could be sent at all.</returns>
func connect_and_set_status(app_id:String, app_version:String, auth_values:ChatAuthenticationValues,
			status:int = Photon.ChatUserStatus.Online, message = null)->bool:
	return _base.ConnectAndSetStatus(app_id, app_version, auth_values, status, message)
## <summary>
## Must be called regularly to keep connection between client and server alive and to process incoming messages.
## </summary>
## <remarks>
## This method limits the effort it does automatically using the private variable msDeltaForServiceCalls.
## That value is lower for connect and multiplied by 4 when chat-server connection is ready.
## </remarks>
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
	return _base.send
	
# Disconnects from the Chat Server by sending a "disconnect command", which prevents a timeout server-side.
func disconnect_server(caust := Photon.ChatDisconnectCause.DisconnectByClientLogic)->void:
	_base.Disconnect(caust)
	
## <summary>Sends operation to subscribe to a list of channels by name.</summary>
## <param name="channels">List of channels to subscribe to. Avoid null or empty values.</param>
## <returns>If the operation could be sent at all (Example: Fails if not connected to Chat Server).</returns>      
func subscribe(channels:PoolStringArray)->bool:
	return _base.Subscribe(channels)
	
## <summary>
## Sends operation to subscribe to a list of channels by name and possibly retrieve messages we did not receive while unsubscribed.
## </summary>
## <param name="channels">List of channels to subscribe to. Avoid null or empty values.</param>
## <param name="lastMsgIds">ID of last message received per channel. Useful when re subscribing to receive only messages we missed.</param>
## <returns>If the operation could be sent at all (Example: Fails if not connected to Chat Server).</returns>
func subscribe_and_get_message_by_last_msg_id(channels:PoolStringArray,last_msg_ids:PoolIntArray)->bool:
	return _base.SubscribeAndGetHistoryByLastMessageId(channels,last_msg_ids)
## <summary>
## Sends operation to subscribe client to channels, optionally fetching a number of messages from the cache.
## </summary>
## <remarks>
## Subscribes channels will forward new messages to this user. Use PublishMessage to do so.
## The messages cache is limited but can be useful to get into ongoing conversations, if that's needed.
## </remarks>
## <param name="channels">List of channels to subscribe to. Avoid null or empty values.</param>
## <param name="messagesFromHistory">0: no history. 1 and higher: number of messages in history. -1: all available history.</param>
## <returns>If the operation could be sent at all (Example: Fails if not connected to Chat Server).</returns>  
func subscribe_and_get_msgs_by_message_count(channels:PoolStringArray,messages_from_history:int)->bool:
	return _base.SubscribeAndGetHistoryByMessageCount(channels, messages_from_history)
## <summary>Unsubscribes from a list of channels, which stops getting messages from those.</summary>
## <remarks>
## The client will remove these channels from the PublicChannels dictionary once the server sent a response to this request.
##
## The request will be sent to the server and IChatClientListener.OnUnsubscribed gets called when the server
## actually removed the channel subscriptions.
##
## Unsubscribe will fail if you include null or empty channel names.
## </remarks>
## <param name="channels">Names of channels to unsubscribe.</param>
## <returns>False, if not connected to a chat server.</returns>
func unsubscribe(channels:PoolStringArray)->bool:
	return _base.Unsubscribe(channels)

## <summary>Sends a message to a public channel which this client subscribed to.</summary>
## <remarks>
## Before you publish to a channel, you have to subscribe it.
## Everyone in that channel will get the message.
## </remarks>
## <param name="channelName">Name of the channel to publish to.</param>
## <param name="message">Your message (string or any serializable data).</param>
## <param name="reliable">是否以可靠的方式进行发送</param>
## <param name="forwardAsWebhook">Optionally, public messages can be forwarded as webhooks. Configure webhooks for your Chat app to use this.</param>
## <returns>False if the client is not yet ready to send messages.</returns>
func publish_message(channel_name:String, message , 
		reliable: = true, forward_as_webhook := false) -> bool :
	return _base.PublishMessage(channel_name, message, reliable, forward_as_webhook)
## <summary>
## Sends a private message to a single target user. Calls OnPrivateMessage on the receiving client.
## </summary>
## <param name="target">Username to send this message to.</param>
## <param name="message">The message you want to send. Can be a simple string or anything serializable.</param>
## <param name="encrypt">Optionally, private messages can be encrypted. Encryption is not end-to-end as the server decrypts the message.</param>
## <param name="reliable">Optionally,是否以可靠的方式发送</param>
## <param name="forwardAsWebhook">Optionally, private messages can be forwarded as webhooks. Configure webhooks for your Chat app to use this.</param>
## <returns>True if this clients can send the message to the server.</returns>
func send_private_message(target_user_id:String, message, encrypt:= false, 
		reliable:=true, forward_as_webhook := false) -> bool :
	return _base.SendPrivateMessage(target_user_id,message,encrypt,reliable,forward_as_webhook)
## <summary>Sets the user's status without changing your status-message.</summary>
## <remarks>
## The predefined status values can be found in class ChatUserStatus.
## State ChatUserStatus.Invisible will make you offline for everyone and send no message.
##
## You can set custom values in the status integer. Aside from the pre-configured ones,
## all states will be considered visible and online. Else, no one would see the custom state.
##
## The message object can be anything that Photon can serialize, including (but not limited to)
## Hashtable, object[] and string. This value is defined by your own conventions.
## </remarks>
## <param name="status">Predefined states are in class ChatUserStatus. Other values can be used at will.</param>
## <param name="message">Also sets a status-message which your friends can get.</param>
## <returns>True if the operation gets called on the server.</returns>
func set_online_status(status:int,message)->bool:
	assert(status in Photon.ChatState.values(),"非法的Chat客户端状态")
	return _base.SetOnlineStatus(status,message)


## <summary>
## Adds friends to a list on the Chat Server which will send you status updates for those.
## </summary>
## <remarks>
## AddFriends and RemoveFriends enable clients to handle their friend list
## in the Photon Chat server. Having users on your friends list gives you access
## to their current online status (and whatever info your client sets in it).
##
## Each user can set an online status consisting of an integer and an arbitrary
## (serializable) object. The object can be null, Hashtable, object[] or anything
## else Photon can serialize.
##
## The status is published automatically to friends (anyone who set your user ID
## with AddFriends).
##
## Photon flushes friends-list when a chat client disconnects, so it has to be
## set each time. If your community API gives you access to online status already,
## you could filter and set online friends in AddFriends.
##
## Actual friend relations are not persistent and have to be stored outside
## of Photon.
## </remarks>
## <param name="friends">Array of friend userIds.</param>
## <returns>If the operation could be sent.</returns>
func add_friends(friends:PoolStringArray)->bool:
	return _base.AddFriends(friends)

## <summary>
## Removes the provided entries from the list on the Chat Server and stops their status updates.
## </summary>
## <remarks>
## Photon flushes friends-list when a chat client disconnects. Unless you want to
## remove individual entries, you don't have to RemoveFriends.
##
## AddFriends and RemoveFriends enable clients to handle their friend list
## in the Photon Chat server. Having users on your friends list gives you access
## to their current online status (and whatever info your client sets in it).
##
## Each user can set an online status consisting of an integer and an arbitratry
## (serializable) object. The object can be null, Hashtable, object[] or anything
## else Photon can serialize.
##
## The status is published automatically to friends (anyone who set your user ID
## with AddFriends).
##
## Photon flushes friends-list when a chat client disconnects, so it has to be
## set each time. If your community API gives you access to online status already,
## you could filter and set online friends in AddFriends.
##
## Actual friend relations are not persistent and have to be stored outside
## of Photon.
##
## AddFriends and RemoveFriends enable clients to handle their friend list
## in the Photon Chat server. Having users on your friends list gives you access
## to their current online status (and whatever info your client sets in it).
##
## Each user can set an online status consisting of an integer and an arbitratry
## (serializable) object. The object can be null, Hashtable, object[] or anything
## else Photon can serialize.
##
## The status is published automatically to friends (anyone who set your user ID
## with AddFriends).
##
##
## Actual friend relations are not persistent and have to be stored outside
## of Photon.
## </remarks>
## <param name="friends">Array of friend userIds.</param>
## <returns>If the operation could be sent.</returns>
func remove_friends(friends:PoolStringArray)->bool:
	return _base.RemoveFriends(friends)
	
## <summary>
## Get you the (locally used) channel name for the chat between this client and another user.
## </summary>
## <param name="userName">Remote user's name or UserId.</param>
## <returns>The (locally used) channel name for a private channel.</returns>
## <remarks>Do not subscribe to this channel.
## Private channels do not need to be explicitly subscribed to.
## Use this for debugging purposes mainly.</remarks>
## 主要是调试打印使用
func get_private_channel_name_by_user(user_id:String)->String:
	return _base.GetPrivateChannelNameByUser(user_id)
## <summary>
## Simplified access to either private or public channels by name.
## </summary>
## <param name="channelName">Name of the channel to get. For private channels, the channel-name is composed of both user's names.</param>
## <param name="isPrivate">Define if you expect a private or public channel.</param>
## <returns>The found channel, if any</returns>
## <remarks>Public channels exist only when subscribed to them.
## Private channels exist only when at least one message is exchanged with the target user privately.</remarks>
func try_get_channel_with_private_or_not(channel_name:String, is_private:bool)->ChatChannel:
	return _base.TryGetChannelWithPrivateOrNot(channel_name,is_private)
## <summary>
## Simplified access to all channels by name. Checks public channels first, then private ones.
## </summary>
## <param name="channelName">Name of the channel to get.</param>
## <returns>The found channel, if any</returns>
## <remarks>Public channels exist only when subscribed to them.
## Private channels exist only when at least one message is exchanged with the target user privately.</remarks>
func try_get_channel(channel_name:String)->ChatChannel:
	return _base.TryGetChannel(channel_name)

## <summary>
## Simplified access to private channels by target user.
## </summary>
## <param name="userId">UserId of the target user in the private channel.</param>
## <returns>The found channel, if any</returns>
func try_get_private_channel_by_user(user_id:String)->ChatChannel:
	return _base.TryGetPrivateChannelByUser(user_id)
	
## <summary>
## Subscribe to a single channel and optionally sets its well-know channel properties in case the channel is created.
## </summary>
## <param name="channel">name of the channel to subscribe to</param>
## <param name="lastMsgId">ID of the last received message from this channel when re subscribing to receive only missed messages, default is 0</param>
## <param name="messagesFromHistory">how many missed messages to receive from history, default is -1 (available history). 0 will get you no items. Positive values are capped by a server side limit.</param>
## <param name="creationOptions">options to be used in case the channel to subscribe to will be created.</param>
## <returns></returns>
func subscribe_single_channel(channel:String, last_msg_id := 0, messages_from_history := -1,
		creation_options:ChannelCreationOptions = null)->bool:
	return _base.SubscribeSingleChannel(channel, last_msg_id, messages_from_history, creation_options._base if creation_options else null)


## 暂不可用
func set_custom_channel_properties(channel_name:String, channel_properties:Dictionary, expected_properties:Dictionary={}, http_forward := false)->bool:
	if _base.has_method("SetCustomChannelProperties"):
		return _base.SetCustomChannelProperties(channel_name,channel_properties,null if expected_properties.empty() else expected_properties, http_forward)
	return false
## 暂不可用
func set_custom_user_properties(channel_name:String, user_id:String, user_properties:Dictionary, expected_properties:={},  http_forward:= false)->bool:
	if _base.has_method("SetCustomUserProperties"):
		return _base.SetCustomUserProperties(channel_name,user_id,user_properties,null if expected_properties.empty() else expected_properties,http_forward)
	return false





# setget 
func _set_auth_values(v:ChatAuthenticationValues)->void:
	_base.set_AuthValues(v)
func _get_auth_values()->ChatAuthenticationValues:
	return _base.get_AuthValues()
func _get_app_id()->String:
	var tmp = _base.get_AppId()
	return tmp if tmp else ""
func _get_app_version()->String:
	var tmp = _base.get_AppVersion()
	return tmp if tmp else ""
func _get_frontend_address()->String:
	var tmp = _base.get_FrontendAddress()
	return tmp if tmp else ""
func _get_name_server_address()->String:
	var tmp = _base.get_NameServerAddress()
	return tmp if tmp else ""
func _set_enable_protocol_fallback(v:bool)->void:
	_base.set_EnableProtocolFallback(v)
func _get_enable_protocol_fallback()->bool:
	return _base.get_EnableProtocolFallback()
func _set_debug_out(v:int)->void:
	assert(v in Photon.DebugLevel.values(),"非法的调试级别")
	_base.set_DebugOut(v)
func _get_debug_out()->int:
	return _base.get_DebugOut()
func _set_transport_protocol(v:int)->void:
	assert(v in Photon.ConnectionProtocol.values(), "非法的传输协议")
	_base.set_TransportProtocol(v)
func _get_transport_protocol()->int:
	return _base.get_TransportProtocol()
func _get_private_channels()->Dictionary:
	return _base.PrivateChannels
func _get_public_channels()->Dictionary:
	return _base.PublicChannels
func _set_private_chat_history_length(v:int)->void:
	_base.set_PrivateChatHistoryLength(v)
func _get_private_chat_history_length()->int:
	return _base.get_PrivateChatHistoryLength()
func _set_message_list(v:int)->void:
	_base.set_MessageLimit(v)
func _get_message_list()->int:
	return _base.get_MessageLimit()
func _get_user_id()->String:
	var tmp = _base.get_UserId()
	return tmp if tmp else ""
func _get_can_chat()->bool:
	return _base.get_CanChat()
func _get_disconnected_cause()->int:
	return _base.get_DisconnectedCause()
func _get_state()->int:
	return _base.get_State()
func _set_chat_region(v:String)->void:
	_base.set_ChatRegion(v)
func _get_chat_region()->String:
	return _base.get_ChatRegion()

func _set_bg_send(v:bool)->void: _base.set_BGSend(v)
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
	_base.connect("DebugRetunMessage",self,"_on_DebugRetunMessage")
	_base.connect("Connected",self,"_on_Connected")
	_base.connect("Disconnected",self,"_on_Disconnected")
	_base.connect("StateChanged",self,"_on_StateChanged")
	_base.connect("MessageReceived",self,"_on_MessageReceived")
	_base.connect("PrivateMessageReceived",self,"_on_PrivateMessageReceived")
	_base.connect("Subscribed",self,"_on_Subscribed")
	_base.connect("Unsubscribed",self,"_on_Unsubscribed")
	_base.connect("StatusUpdated",self,"_on_StatusUpdated")
	_base.connect("UserSubscribed",self,"_on_UserSubscribed")
	_base.connect("UserUnsubscribed",self,"_on_UserUnsubscribed")
	if _base.has_signal("ChannelPropertiesChanged"):
		_base.connect("ChannelPropertiesChanged",self,"_on_ChannelPropertiesChanged")
	if _base.has_signal("UserPropertiesChanged"):
		_base.connect("UserPropertiesChanged",self,"_on_UserPropertiesChanged")
	if _base.has_signal("ErrorInfoReceived"):
		_base.connect("ErrorInfoReceived",self,"_on_ErrorInfoReceived")
	if _base.has_signal("BroadcastMessageReceived"):
		_base.connect("BroadcastMessageReceived",self,"_on_BroadcastMessageReceived")




func _on_DebugRetunMessage(level:int, debugMessage:String)->void:
	_on_debug_retun_message(level,debugMessage)
	emit_signal("debug_retun_message")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"debug_retun_message", self.user_id,level,debugMessage)
	
func _on_Connected()->void:
	_on_connected()
	emit_signal("connected")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"connected", self.user_id)
	
func _on_Disconnected()->void:
	_on_disconnected()
	emit_signal("disconnected")
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"disconnected", self.user_id)
	
func _on_StateChanged(currentState:int)->void:
	_on_state_changed(currentState)
	emit_signal("state_changed",currentState)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"state_changed", self.user_id, currentState)
	
func _on_MessageReceived(channel_name:String, senders:PoolStringArray, messages:Array)->void:
	_on_message_received(channel_name, senders, messages)
	emit_signal("message_received",channel_name, senders, messages)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"message_received", self.user_id, channel_name, senders, messages)

func _on_PrivateMessageReceived(sender:String, message, channel_name:String)->void:
	_on_private_message_received(sender, message, channel_name)
	emit_signal("private_message_received", sender, message, channel_name)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"private_message_received", self.user_id, sender, message, channel_name)
	
func _on_Subscribed(channels:PoolStringArray, results:Array)->void:
	_on_subscribed(channels,results)
	emit_signal("subscribed", channels, results)	
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"subscribed", self.user_id, channels, results)

func _on_Unsubscribed(channels:PoolStringArray)->void:
	_on_unsubscribed(channels)
	emit_signal("unsubscribed", channels)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"unsubscribed", self.user_id, channels)
	
func _on_StatusUpdated(userName:String, status:int, gotMessage:bool, statusMessage)->void:
	_on_status_updated(userName,status,gotMessage,statusMessage)
	emit_signal("status_updated", userName, status, gotMessage, statusMessage)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"status_updated", self.user_id, userName, status, gotMessage, statusMessage)
	
func _on_UserSubscribed(channelName:String, userId:String)->void:
	_on_user_subscribed(channelName,userId)
	emit_signal("user_subscribed", channelName, userId)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"user_subscribed", self.user_id, channelName, userId)
	
func _on_UserUnsubscribed(channelName:String, userId:String)->void:
	_on_user_unsubscribed(channelName,userId)
	emit_signal("user_unsubscribed", channelName, userId)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"user_unsubscribed", self.user_id, channelName, userId)
	
func _on_ChannelPropertiesChanged(channel:String, senderUserId:String, properties:Dictionary)->void:
	_on_channel_properties_changed(channel,senderUserId,properties)
	emit_signal("channel_properties_changed", channel, senderUserId,properties)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"channel_properties_changed", self.user_id, channel, senderUserId,properties)

func _on_UserPropertiesChanged(channel:String, targetUserId:String, senderUserId:String, properties:Dictionary)->void:
	_on_user_properties_changed(channel, targetUserId, senderUserId, properties)
	emit_signal("user_properties_changed", channel, targetUserId, senderUserId, properties)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"user_properties_changed", self.user_id, channel, targetUserId, senderUserId, properties)

func _on_ErrorInfoReceived(channel:String, error:String, data)->void:
	_on_error_info_received(channel,error,data)
	emit_signal("error_info_received", channel, error, data)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"error_info_received", self.user_id, channel, error, data)
	
func _on_BroadcastMessageReceived(channel:String, message:PoolByteArray)->void:
	_on_broadcast_message_received(channel,message)
	emit_signal("broadcast_message_received", channel, message)
	if _need2call_group():
		_tree.call_group_flags(_call_group_flags, CALLBACK_GROUP_NAME, CALLBACK_PREFIX+"broadcast_message_received", self.user_id, channel, message)
	
func _on_tree_entered()->void:
	_tree = get_tree()
func _on_tree_exited()->void:
	_tree = null
	
func _need2call_group()->bool:
	return notify_group and is_inside_tree() 
# internal
const _Base:=preload("../src/PhotonChatClient.cs")
var _base = _Base.new()
