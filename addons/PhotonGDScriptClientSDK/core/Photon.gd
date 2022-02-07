extends Node
class_name Photon



## These are the options that can be used as underlying transport protocol.
enum ConnectionProtocol{
	UDP = 0,
	TCP = 1,
	WEB_SOCKET = 4,
	WEB_SOCKET_SECURE = 5,
}
## Variants of the Photon specific serialization protocol used for operations, responses,events and data.
enum SerializationProtocol{
	# Version 1.6 (outdated).
	GpBinaryV16 = 0,
	# Version 1.8.
	GpBinaryV18 = 1
}
## Defines which sort of app the LoadBalancingClient is used for: Realtime or Voice.
enum ClientAppType{
	### <summary>Realtime apps are for gaming / interaction. Also used by PUN 2.</summary>
	Realtime,
	### <summary>Voice apps stream audio.</summary>
	Voice,
	### <summary>Fusion clients are for matchmaking and relay in Photon Fusion.</summary>
	Fusion
}

## Options for authentication modes. From "classic" auth on each server to AuthOnce (on NameServer).
enum AuthModeOption { Auth, AuthOnce, AuthOnceWss }
	
## Defines how the communication gets encrypted.
enum EncryptionMode{
	## This is the default encryption mode: Messages get encrypted only on demand (when you send operations with the "encrypt" parameter set to true).
	PayloadEncryption,
	## With this encryption mode for UDP, the connection gets setup and all further datagrams get encrypted almost entirely. On-demand message encryption (like in PayloadEncryption) is unavailable.
	DatagramEncryption = 10,
	#With this encryption mode for UDP, the connection gets setup with random sequence numbers and all further datagrams get encrypted almost entirely. On-demand message encryption (like in PayloadEncryption) is unavailable.
	DatagramEncryptionRandomSequence = 11,
	# Same as above except that GCM mode is used to encrypt data.
	# DatagramEncryptionGCMRandomSequence = 12,
	## Datagram Encryption with GCM.
	DatagramEncryptionGCM = 13,
}
## Available server (types) for internally used field: server.
## Photon uses 3 different roles of servers: Name Server, Master Server and Game Server.
enum ServerConnection{
	## This server is where matchmaking gets done and where clients can get lists of rooms in lobbies.
	MasterServer,
	## This server handles a number of rooms to execute and relay the messages between players (in a room).
	GameServer,
	## This server is used initially to get the address (IP) of a Master Server for a specific region. Not used for Photon OnPremise (self hosted).
	NameServer
}
## Level / amount of DebugReturn callbacks. Each debug level includes output for
## lower ones: OFF, ERROR, WARNING, INFO, ALL.
enum DebugLevel{
	## No debug out.
	OFF = 0,
	## Only error descriptions.
	ERROR = 1,
	## Warnings and errors.
	WARNING = 2,
	## Information about internal workflows, warnings and errors.
	INFO = 3,
	## Most complete workflow description (but lots of debug output), info, warnings and errors.
	ALL = 5
}

## State values for a client, which handles switching Photon server types, some operations, etc.
enum ClientState{
	## <summary>Peer is created but not used yet.</summary>
	PeerCreated,

	## <summary>Transition state while connecting to a server. On the Photon Cloud this sends the AppId and AuthenticationValues (UserID).</summary>
	Authenticating,

	## <summary>Not Used.</summary>
	Authenticated,

	## <summary>The client sent an OpJoinLobby and if this was done on the Master Server, it will result in. Depending on the lobby, it gets room listings.</summary>
	JoiningLobby,

	## <summary>The client is in a lobby, connected to the MasterServer. Depending on the lobby, it gets room listings.</summary>
	JoinedLobby,

	## <summary>Transition from MasterServer to GameServer.</summary>
	DisconnectingFromMasterServer,

	## <summary>Transition to GameServer (client authenticates and joins/creates a room).</summary>
	ConnectingToGameServer,

	## <summary>Connected to GameServer (going to auth and join game).</summary>
	ConnectedToGameServer,

	## <summary>Transition state while joining or creating a room on GameServer.</summary>
	Joining,

	## <summary>The client entered a room. The CurrentRoom and Players are known and you can now raise events.</summary>
	Joined,

	## <summary>Transition state when leaving a room.</summary>
	Leaving,

	## <summary>Transition from GameServer to MasterServer (after leaving a room/game).</summary>
	DisconnectingFromGameServer,

	## <summary>Connecting to MasterServer (includes sending authentication values).</summary>
	ConnectingToMasterServer,

	## <summary>The client disconnects (from any server). This leads to state Disconnected.</summary>
	Disconnecting,

	## <summary>The client is no longer connected (to any server). Connect to MasterServer to go on.</summary>
	Disconnected,

	## <summary>Connected to MasterServer. You might use matchmaking or join a lobby now.</summary>
	ConnectedToMasterServer,

	## <summary>Client connects to the NameServer. This process includes low level connecting and setting up encryption. When done, state becomes ConnectedToNameServer.</summary>
	ConnectingToNameServer,

	## <summary>Client is connected to the NameServer and established encryption already. You should call OpGetRegions or ConnectToRegionMaster.</summary>
	ConnectedToNameServer,

	## <summary>Clients disconnects (specifically) from the NameServer (usually to connect to the MasterServer).</summary>
	DisconnectingFromNameServer,

	## <summary>Client was unable to connect to Name Server and will attempt to connect with an alternative network protocol (TCP).</summary>
	ConnectWithFallbackProtocol
}
## <summary>Types of lobbies define their behaviour and capabilities. Check each value for details.</summary>
## <remarks>Values of this enum must be matched by the server.</remarks>
enum LobbyType{
	## <summary>Standard type and behaviour: While joined to this lobby clients get room-lists and JoinRandomRoom can use a simple filter to match properties (perfectly).</summary>
	Default = 0,
	## <summary>This lobby type lists rooms like Default but JoinRandom has a parameter for SQL-like "where" clauses for filtering. This allows bigger, less, or and and combinations.</summary>
	SqlLobby = 2,
	## <summary>This lobby does not send lists of games. It is only used for OpJoinRandomRoom. It keeps rooms available for a while when there are only inactive users left.</summary>
	AsyncRandomLobby = 3
}

## Options for matchmaking rules for OpJoinRandom.
enum MatchmakingMode {
	## <summary>Fills up rooms (oldest first) to get players together as fast as possible. Default.</summary>
	## <remarks>Makes most sense with MaxPlayers > 0 and games that can only start with more players.</remarks>
	FillRoom = 0,

	## <summary>Distributes players across available rooms sequentially but takes filter into account. Without filter, rooms get players evenly distributed.</summary>
	SerialMatching = 1,

	## <summary>Joins a (fully) random room. Expected properties must match but aside from this, any available room might be selected.</summary>
	RandomMatching = 2
}


enum RealtimeDisconnectCause{
	## <summary>No error was tracked.</summary>
	None,

	## <summary>OnStatusChanged: The server is not available or the address is wrong. Make sure the port is provided and the server is up.</summary>
	ExceptionOnConnect,

	## <summary>OnStatusChanged: Dns resolution for a hostname failed. The exception for this is being catched and logged with error level.</summary>
	DnsExceptionOnConnect,

	## <summary>OnStatusChanged: The server address was parsed as IPv4 illegally. An illegal address would be e.g. 192.168.1.300. IPAddress.TryParse() will let this pass but our check won't.</summary>
	ServerAddressInvalid,

	## <summary>OnStatusChanged: Some internal exception caused the socket code to fail. This may happen if you attempt to connect locally but the server is not available. In doubt: Contact Exit Games.</summary>
	Exception,

	## <summary>OnStatusChanged: The server disconnected this client due to timing out (missing acknowledgement from the client).</summary>
	ServerTimeout,

	## <summary>OnStatusChanged: This client detected that the server's responses are not received in due time.</summary>
	ClientTimeout,

	## <summary>OnStatusChanged: The server disconnected this client from within the room's logic (the C# code).</summary>
	DisconnectByServerLogic,

	## <summary>OnStatusChanged: The server disconnected this client for unknown reasons.</summary>
	DisconnectByServerReasonUnknown,

	## <summary>OnOperationResponse: Authenticate in the Photon Cloud with invalid AppId. Update your subscription or contact Exit Games.</summary>
	InvalidAuthentication,

	## <summary>OnOperationResponse: Authenticate in the Photon Cloud with invalid client values or custom authentication setup in Cloud Dashboard.</summary>
	CustomAuthenticationFailed,

	## <summary>The authentication ticket should provide access to any Photon Cloud server without doing another authentication-service call. However, the ticket expired.</summary>
	AuthenticationTicketExpired,

	## <summary>OnOperationResponse: Authenticate (temporarily) failed when using a Photon Cloud subscription without CCU Burst. Update your subscription.</summary>
	MaxCcuReached,

	## <summary>OnOperationResponse: Authenticate when the app's Photon Cloud subscription is locked to some (other) region(s). Update your subscription or master server address.</summary>
	InvalidRegion,

	## <summary>OnOperationResponse: Operation that's (currently) not available for this client (not authorized usually). Only tracked for op Authenticate.</summary>
	OperationNotAllowedInCurrentState,

	## <summary>OnStatusChanged: The client disconnected from within the logic (the C# code).</summary>
	DisconnectByClientLogic,

	## <summary>The client called an operation too frequently and got disconnected due to hitting the OperationLimit. This triggers a client-side disconnect, too.</summary>
	## <remarks>To protect the server, some operations have a limit. When an OperationResponse fails with ErrorCode.OperationLimitReached, the client disconnects.</remarks>
	DisconnectByOperationLimit,

	## <summary>The client received a "Disconnect Message" from the server. Check the debug logs for details.</summary>
	DisconnectByDisconnectMessage
}


## <summary>
## Lite - OpRaiseEvent allows you to cache events and automatically send them to joining players in a room.
## Events are cached per event code and player: Event 100 (example!) can be stored once per player.
## Cached events can be modified, replaced and removed.
## </summary>
## <remarks>
## Caching works only combination with ReceiverGroup options Others and All.
## </remarks>
enum EventCaching{
	# <summary>Default value (not sent).</summary>
	DoNotCache = 0,

	## <summary>Will merge this event's keys with those already cached.</summary>
	## [Obsolete]
	MergeCache = 1,

	## <summary>Replaces the event cache for this eventCode with this event's content.</summary>
	## [Obsolete]
	ReplaceCache = 2,

	## <summary>Removes this event (by eventCode) from the cache.</summary>
	##[Obsolete]
	RemoveCache = 3,

	## <summary>Adds an event to the room's cache</summary>
	AddToRoomCache = 4,

	## <summary>Adds this event to the cache for actor 0 (becoming a "globally owned" event in the cache).</summary>
	AddToRoomCacheGlobal = 5,

	## <summary>Remove fitting event from the room's cache.</summary>
	RemoveFromRoomCache = 6,

	## <summary>Removes events of players who already left the room (cleaning up).</summary>
	RemoveFromRoomCacheForActorsLeft = 7,

	## <summary>Increase the index of the sliced cache.</summary>
	SliceIncreaseIndex = 10,

	## <summary>Set the index of the sliced cache. You must set RaiseEventOptions.CacheSliceIndex for this.</summary>
	SliceSetIndex = 11,

	## <summary>Purge cache slice with index. Exactly one slice is removed from cache. You must set RaiseEventOptions.CacheSliceIndex for this.</summary>
	SlicePurgeIndex = 12,

	## <summary>Purge cache slices with specified index and anything lower than that. You must set RaiseEventOptions.CacheSliceIndex for this.</summary>
	SlicePurgeUpToIndex = 13,
}

## Lite - OpRaiseEvent lets you chose which actors in the room should receive events.
## By default, events are sent to "Others" but you can overrule this.
enum ReceiverGroup {
	## <summary>Default value (not sent). Anyone else gets my event.</summary>
	Others = 0,

	## <summary>Everyone in the current room (including this peer) will get this event.</summary>
	All = 1,

	## <summary>The server sends this event only to the actor with the lowest actorNumber.</summary>
	## <remarks>The "master client" does not have special rights but is the one who is in this room the longest time.</remarks>
	MasterClient = 2,
}

## Enum of the three options for reliability and sequencing in Photon's reliable-UDP.
enum DeliveryMode {
	## The operation/message gets sent just once without acknowledgement or repeat.
	## The sequence (order) of messages is guaranteed.
	Unreliable = 0, 
	
	## The operation/message asks for an acknowledgment. It's resent until an ACK arrived.
	## The sequence (order) of messages is guaranteed.
	Reliable = 1,
	
	## The operation/message gets sent once (unreliable) and might arrive out of order.
	## Best for your own sequencing (e.g. for streams).
	UnreliableUnsequenced = 2,
	
	## The operation/message asks for an acknowledgment. It's resent until an ACK arrived
	## and might arrive out of order. Best for your own sequencing (e.g. for streams).
	ReliableUnsequenced = 3
}


## Chat
## <summary>Possible states for a Chat Client.</summary>
enum ChatState{
	## <summary>Peer is created but not used yet.</summary>
	Uninitialized,
	## <summary>Connecting to name server.</summary>
	ConnectingToNameServer,
	## <summary>Connected to name server.</summary>
	ConnectedToNameServer,
	## <summary>Authenticating on current server.</summary>
	Authenticating,
	## <summary>Finished authentication on current server.</summary>
	Authenticated,
	## <summary>Disconnecting from name server. This is usually a transition from name server to frontend server.</summary>
	DisconnectingFromNameServer,
	## <summary>Connecting to frontend server.</summary>
	ConnectingToFrontEnd,
	## <summary>Connected to frontend server.</summary>
	ConnectedToFrontEnd,
	## <summary>Disconnecting from frontend server.</summary>
	DisconnectingFromFrontEnd,
	## <summary>Currently not used.</summary>
	QueuedComingFromFrontEnd,
	## <summary>The client disconnects (from any server).</summary>
	Disconnecting,
	## <summary>The client is no longer connected (to any server).</summary>
	Disconnected,
	## <summary>Client was unable to connect to Name Server and will attempt to connect with an alternative network protocol (TCP).</summary>
	ConnectWithFallbackProtocol
}

## <summary>Enumeration of causes for Disconnects (used in <see cref="ChatClient.DisconnectedCause"/>).</summary>
## <remarks>Read the individual descriptions to find out what to do about this type of disconnect.</remarks>
enum ChatDisconnectCause{
	## <summary>No error was tracked.</summary>
	None,
	## <summary>OnStatusChanged: The server is not available or the address is wrong. Make sure the port is provided and the server is up.</summary>
	ExceptionOnConnect,
	## <summary>OnStatusChanged: The server disconnected this client from within the room's logic (the C# code).</summary>
	DisconnectByServerLogic,
	## <summary>OnStatusChanged: The server disconnected this client for unknown reasons.</summary>
	DisconnectByServerReasonUnknown,
	## <summary>OnStatusChanged: The server disconnected this client due to timing out (missing acknowledgement from the client).</summary>
	ServerTimeout,

	## <summary>OnStatusChanged: This client detected that the server's responses are not received in due time.</summary>
	ClientTimeout,
	## <summary>OnStatusChanged: Some internal exception caused the socket code to fail. Contact Exit Games.</summary>
	Exception,
	## <summary>OnOperationResponse: Authenticate in the Photon Cloud with invalid AppId. Update your subscription or contact Exit Games.</summary>
	InvalidAuthentication,
	## <summary>OnOperationResponse: Authenticate (temporarily) failed when using a Photon Cloud subscription without CCU Burst. Update your subscription.</summary>
	MaxCcuReached,
	## <summary>OnOperationResponse: Authenticate when the app's Photon Cloud subscription is locked to some (other) region(s). Update your subscription or change region.</summary>
	InvalidRegion,
	## <summary>OnOperationResponse: Operation that's (currently) not available for this client (not authorized usually). Only tracked for op Authenticate.</summary>
	OperationNotAllowedInCurrentState,
	## <summary>OnOperationResponse: Authenticate in the Photon Cloud with invalid client values or custom authentication setup in Cloud Dashboard.</summary>
	CustomAuthenticationFailed,
	## <summary>The authentication ticket should provide access to any Photon Cloud server without doing another authentication-service call. However, the ticket expired.</summary>
	AuthenticationTicketExpired,
	## <summary>OnStatusChanged: The client disconnected from within the logic (the C# code).</summary>
	DisconnectByClientLogic
}
## <summary>
## Options for optional "Custom Authentication" services used with Photon. Used by OpAuthenticate after connecting to Photon.
## </summary>
enum CustomAuthenticationType{
	## <summary>Use a custom authentication service. Currently the only implemented option.</summary>
	Custom = 0,

	## <summary>Authenticates users by their Steam Account. Set Steam's ticket as "ticket" via AddAuthParameter().</summary>
	Steam = 1,

	## <summary>Authenticates users by their Facebook Account.  Set Facebooks's tocken as "token" via AddAuthParameter().</summary>
	Facebook = 2,

	## <summary>Authenticates users by their Oculus Account and token. Set Oculus' userid as "userid" and nonce as "nonce" via AddAuthParameter().</summary>
	Oculus = 3,

	## <summary>Authenticates users by their PSN Account and token on PS4. Set token as "token", env as "env" and userName as "userName" via AddAuthParameter().</summary>
	PlayStation4 = 4,

	## <summary>Authenticates users by their Xbox Account. Pass the XSTS token via SetAuthPostData().</summary>
	Xbox = 5,

	## <summary>Authenticates users by their HTC Viveport Account. Set userToken as "userToken" via AddAuthParameter().</summary>
	Viveport = 10,

	## <summary>Authenticates users by their NSA ID. Set token  as "token" and appversion as "appversion" via AddAuthParameter(). The appversion is optional.</summary>
	NintendoSwitch = 11,

	## <summary>Authenticates users by their PSN Account and token on PS5. Set token as "token", env as "env" and userName as "userName" via AddAuthParameter().</summary>
	PlayStation5 = 12,

	## <summary>Authenticates users with Epic Online Services (EOS). Set token as "token" and ownershipToken as "ownershipToken" via AddAuthParameter(). The ownershipToken is optional.</summary>
	Epic = 13,

	## <summary>Authenticates users with Facebook Gaming api. Set token as "token" via AddAuthParameter().</summary>
	FacebookGaming = 15,

	## <summary>Disables custom authentication. Same as not providing any AuthenticationValues for connect (more precisely for: OpAuthenticate).</summary>
	None = 255
}
## <summary>Contains commonly used status values for SetOnlineStatus. You can define your own.</summary>
## <remarks>
## While "online" (value 2 and up), the status message will be sent to anyone who has you on his friend list.
##
## Define custom online status values as you like with these rules:
## 0: Means "offline". It will be used when you are not connected. In this status, there is no status message.
## 1: Means "invisible" and is sent to friends as "offline". They see status 0, no message but you can chat.
## 2: And any higher value will be treated as "online". Status can be set.
## </remarks>
enum ChatUserStatus{
	## <summary>(0) Offline.</summary>
	Offline = 0,
	## <summary>(1) Be invisible to everyone. Sends no message.</summary>
	Invisible = 1,
	## <summary>(2) Online and available.</summary>
	Online = 2,
	## <summary>(3) Online but not available.</summary>
	Away = 3,
	## <summary>(4) Do not disturb.</summary>
	DND = 4,
	## <summary>(5) Looking For Game/Group. Could be used when you want to be invited or do matchmaking.</summary>
	LFG = 5,
	## <summary>(6) Could be used when in a room, playing.</summary>
	Playing = 6,
}
