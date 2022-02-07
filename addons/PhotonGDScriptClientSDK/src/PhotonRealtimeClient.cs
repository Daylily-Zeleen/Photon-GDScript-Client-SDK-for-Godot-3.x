using System.Collections.Generic;
using System.Collections;
using Photon.Realtime;
using Photon.Chat;
using Godot;
// using Godot.Collections;
using static Godot.GD;
using System;
using ExitGames.Client.Photon;
using PhotonGodotWarps.Warps;



namespace PhotonGodotWarps.src
{
    /// <summary>
    /// 包装对象提供给GDScript接入
    /// </summary>
    public class PhotonRealtimeClient : Reference,
                IConnectionCallbacks, IErrorInfoCallback, IWebRpcCallback,IInRoomCallbacks, ILobbyCallbacks, IMatchmakingCallbacks // realtime
    {
        #region 自定义
        public bool BGSend {get=>backgroudThreadConfig.BGSend; set=>backgroudThreadConfig.BGSend=value;}
        public bool BGDispatch {get=>backgroudThreadConfig.BGDispatch;set=>backgroudThreadConfig.BGDispatch=value;}
        public int BGSendIntervalMs {get=>backgroudThreadConfig.MsSendInterval;set=>backgroudThreadConfig.MsSendInterval=value;}
        public int BGDispatchIntervalMs {get=>backgroudThreadConfig.MsDispathcInterval;set=>backgroudThreadConfig.MsDispathcInterval=value;}

        public bool BGSendSingle {get=>backgroudThreadConfig.SendSingle;set=>backgroudThreadConfig.SendSingle=value;}
        public bool BGDispatchSingle {get=>backgroudThreadConfig.DispatchSingle;set=>backgroudThreadConfig.DispatchSingle=value;}

        private readonly PhotonClientBackgroundThreadConfig backgroudThreadConfig ;//{ get; set; }
        public bool ReuseEventInstance // default true
        {
            get => realtimeClient.LoadBalancingPeer.ReuseEventInstance;
            set 
            {
                realtimeClient.LoadBalancingPeer.ReuseEventInstance=value;
                PhotonEventData.ReuseRealtimeEventInstance = value;
            }
        }
        #endregion

        #region 构造与析构
        private LoadBalancingClient realtimeClient ;
        /// <summary>
        /// 用于gds包装用的直接构造（preload c# 脚本不能带参new())
        /// 需要进一步调用 init()
        /// </summary>
        public PhotonRealtimeClient(){
            // 实例化后台线程配置
            backgroudThreadConfig = new  PhotonClientBackgroundThreadConfig(
                            new Func<bool>(SendOutgoingCommands),
                            new Func<bool>(DispatchIncomingCommands) );
            // AuthValues = new PhotonRealtimeAuthenticationValues();
        }
        public void init(ConnectionProtocol protocol = ConnectionProtocol.Udp)
        {
            realtimeClient = new LoadBalancingClient(protocol);

            // 包装
            // realtimeClient.AuthValues = this.AuthValues.AuthenticationValues;
            LocalPlayer = new PhotonPlayer(realtimeClient.LocalPlayer);
            realtimeClient.StateChanged += (previousState, currentState)=>
                    {
                        if (!InRoom) CurrentRoom = null;
                        EmitSignal(nameof(StateChanged), previousState, currentState);
                    };
            realtimeClient.EventReceived += (eventData)=>EmitSignal(nameof(EventReceived), PhotonEventData.GetPhotonRealtimeEventData(eventData));
            realtimeClient.OpResponseReceived += (opResponse)=>
                    {
                        if (opResponse.OperationCode == OperationCode.JoinGame)
                        {
                            if (realtimeClient.CurrentRoom == null) CurrentRoom = null;
                            else 
                            {
                                if (CurrentRoom == null) CurrentRoom = new PhotonRoom(realtimeClient.CurrentRoom, LocalPlayer);
                                else CurrentRoom.init(realtimeClient.CurrentRoom, LocalPlayer);
                            }
                        }
                        EmitSignal(nameof(OpResponseReceived), PhotonOperationResponse.GetPhotonRealtimeOpResponse(opResponse));
                    };
            // 二次包装，处于性能考虑，默认复用事件对象
            this.ReuseEventInstance = true;


            realtimeClient.AddCallbackTarget(this);

        }
        public void init(string masterAddress, string appId, string gameVersion, ConnectionProtocol protocol = ConnectionProtocol.Udp) 
        {
            this.init(protocol);

            this.MasterServerAddress = masterAddress;
            this.AppId = appId;
            this.AppVersion = gameVersion;
        }

        ~PhotonRealtimeClient()
        {
            realtimeClient.Disconnect();
            realtimeClient.RemoveCallbackTarget(this);
        }
        #endregion        


        #region 连接与服务
        // needed connect variants:
        // connect to Name Server only (could include getregions) -> end after getregions
        // connect to Region Master via Name Server (specific region/cluster) -> no getregions! authenticates and ends after on connected to master
        // connect to Best Region via Name Server
        // connect to Master Server (no Name Server, no appid)
        public virtual bool ConnectUsingSettings(PhotonAppSettings appSettings)
            => realtimeClient.ConnectUsingSettings(appSettings.AppSettings);
        
        /// <summary>
        /// Starts the "process" to connect to a Master Server, using MasterServerAddress and AppId properties.
        /// </summary>
        /// <remarks>
        /// To connect to the Photon Cloud, use ConnectUsingSettings() or ConnectToRegionMaster().
        ///
        /// The process to connect includes several steps: the actual connecting, establishing encryption, authentification
        /// (of app and optionally the user) and connecting to the MasterServer
        ///
        /// Users can connect either anonymously or use "Custom Authentication" to verify each individual player's login.
        /// Custom Authentication in Photon uses external services and communities to verify users. While the client provides a user's info,
        /// the service setup is done in the Photon Cloud Dashboard.
        /// The parameter authValues will set this.AuthValues and use them in the connect process.
        ///
        /// Connecting to the Photon Cloud might fail due to:
        /// - Network issues (OnStatusChanged() StatusCode.ExceptionOnConnect)
        /// - Region not available (OnOperationResponse() for OpAuthenticate with ReturnCode == ErrorCode.InvalidRegion)
        /// - Subscription CCU limit reached (OnOperationResponse() for OpAuthenticate with ReturnCode == ErrorCode.MaxCcuReached)
        /// </remarks>
        public virtual bool ConnectToMasterServer()=>realtimeClient.ConnectToMasterServer();
        
        /// <summary>
        /// Connects to the NameServer for Photon Cloud, where a region and server list can be obtained.
        /// </summary>
        /// <see cref="OpGetRegions"/>
        /// <returns>If the workflow was started or failed right away.</returns>
        public bool ConnectToNameServer()=>realtimeClient.ConnectToNameServer();

        /// <summary>
        /// Connects you to a specific region's Master Server, using the Name Server to find the IP.
        /// </summary>
        /// <remarks>
        /// If the region is null or empty, no connection will be made.
        /// If the region (code) provided is not available, the connection process will fail on the Name Server.
        /// This method connects only to the region defined. No "Best Region" pinging will be done.
        ///
        /// If the region string does not contain a "/", this means no specific cluster is requested.
        /// To support "Sharding", the region gets a "/*" postfix in this case, to select a random cluster.
        /// </remarks>
        /// <returns>If the operation could be sent. If false, no operation was sent.</returns>
        public bool ConnectToRegionMaster(string region)=>realtimeClient.ConnectToRegionMaster(region);

        /// <summary>Can be used to reconnect to the master server after a disconnect.</summary>
        /// <remarks>Common use case: Press the Lock Button on a iOS device and you get disconnected immediately.</remarks>
        public bool ReconnectToMaster()=>realtimeClient.ReconnectToMaster();

        /// <summary>
        /// Can be used to return to a room quickly by directly reconnecting to a game server to rejoin a room.
        /// </summary>
        /// <remarks>
        /// Rejoining room will not send any player properties. Instead client will receive up-to-date ones from server.
        /// If you want to set new player properties, do it once rejoined.
        /// </remarks>
        /// <returns>False, if the conditions are not met. Then, this client does not attempt the ReconnectAndRejoin.</returns>
        public bool ReconnectAndRejoin()=>realtimeClient.ReconnectAndRejoin();

        /// <summary>
        /// Useful to test loss of connection which will end in a client timeout. This modifies LoadBalancingPeer.NetworkSimulationSettings. Read remarks.
        /// </summary>
        /// <remarks>
        /// Use with care as this sets LoadBalancingPeer.IsSimulationEnabled.<br/>
        /// Read LoadBalancingPeer.IsSimulationEnabled to check if this is on or off, if needed.<br/>
        ///
        /// If simulateTimeout is true, LoadBalancingPeer.NetworkSimulationSettings.IncomingLossPercentage and
        /// LoadBalancingPeer.NetworkSimulationSettings.OutgoingLossPercentage will be set to 100.<br/>
        /// Obviously, this overrides any network simulation settings done before.<br/>
        ///
        /// If you want fine-grained network simulation control, use the NetworkSimulationSettings.<br/>
        ///
        /// The timeout will lead to a call to <see cref="IConnectionCallbacks.OnDisconnected"/>, as usual in a client timeout.
        ///
        /// You could modify this method (or use NetworkSimulationSettings) to deliberately run into a server timeout by
        /// just setting the OutgoingLossPercentage = 100 and the IncomingLossPercentage = 0.
        /// </remarks>
        /// <param name="simulateTimeout">If true, a connection loss is simulated. If false, the simulation ends.</param>
        public void SimulateConnectionLoss(bool simulateTimeout) =>realtimeClient.SimulateConnectionLoss(simulateTimeout);
        
        /// <summary>Disconnects the peer from a server or stays disconnected. If the client / peer was connected, a callback will be triggered.</summary>
        /// <remarks>
        /// Disconnect will attempt to notify the server of the client closing the connection.
        ///
        /// Clients that are in a room, will leave the room. If the room's playerTTL &gt; 0, the player will just become inactive (and may rejoin).
        ///
        /// This method will not change the current State, if this client State is PeerCreated, Disconnecting or Disconnected.
        /// In those cases, there is also no callback for the disconnect. The DisconnectedCause will only change if the client was connected.
        /// </remarks>
        public void Disconnect(DisconnectCause cause = DisconnectCause.DisconnectByClientLogic) => realtimeClient.Disconnect(cause);

        /// <summary>
        /// This method dispatches all available incoming commands and then sends this client's outgoing commands.
        /// It uses DispatchIncomingCommands and SendOutgoingCommands to do that.
        /// </summary>
        /// <remarks>
        /// The Photon client libraries are designed to fit easily into a game or application. The application
        /// is in control of the context (thread) in which incoming events and responses are executed and has
        /// full control of the creation of UDP/TCP packages.
        ///
        /// Sending packages and dispatching received messages are two separate tasks. Service combines them
        /// into one method at the cost of control. It calls DispatchIncomingCommands and SendOutgoingCommands.
        ///
        /// Call this method regularly (10..50 times a second).
        ///
        /// This will Dispatch ANY received commands (unless a reliable command in-order is still missing) and
        /// events AND will send queued outgoing commands. Fewer calls might be more effective if a device
        /// cannot send many packets per second, as multiple operations might be combined into one package.
        /// </remarks>
        /// <example>
        /// You could replace Service by:
        ///
        ///     while (DispatchIncomingCommands()); //Dispatch until everything is Dispatched...
        ///     SendOutgoingCommands(); //Send a UDP/TCP package with outgoing messages
        /// </example>
        /// <seealso cref="PhotonPeer.DispatchIncomingCommands"/>
        /// <seealso cref="PhotonPeer.SendOutgoingCommands"/>
        public void Service() =>realtimeClient.Service();
        public bool DispatchIncomingCommands() 
        {
            if (realtimeClient.LoadBalancingPeer == null) return false;
            return realtimeClient.LoadBalancingPeer.DispatchIncomingCommands();
        }
        public bool SendOutgoingCommands()
        {
            if (realtimeClient.LoadBalancingPeer == null) return false;
            return realtimeClient.LoadBalancingPeer.SendOutgoingCommands();
        }
        #endregion

        #region Realtime 属性
        public SerializationProtocol SerializationProtocol{get=>realtimeClient.SerializationProtocol;set=>realtimeClient.SerializationProtocol=value;}
        public string AppVersion { get=>realtimeClient.AppVersion; set=>realtimeClient.AppVersion=value; }
        public string AppId { get=>realtimeClient.AppId; set=>realtimeClient.AppId=value; }
        public ClientAppType ClientType { get=>realtimeClient.ClientType; set=>realtimeClient.ClientType = value; }
        private readonly static GDScript GDSAuthValuesClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/RealtimeAuthenticationValues.gd");
        
        /// <summary>User authentication values to be sent to the Photon server right after connecting.</summary>
        /// <remarks>Set this property or pass AuthenticationValues by Connect(..., authValues).</remarks>
        public Reference GDSAuthValues 
        { 
            get
            {
                if (realtimeClient.AuthValues != null)
                {
                    if (!IsInstanceValid(gdsAuthValues))
                    {
                        gdsAuthValues = GDSAuthValuesClass.New() as Reference;
                    }
                    var tmp = gdsAuthValues.Get("_base") as PhotonRealtimeAuthenticationValues;
                    if (tmp.AuthenticationValues != realtimeClient.AuthValues)
                    {
                        if (!tmp.IsQueuedForDeletion()) tmp.Free();
                        tmp.AuthenticationValues = realtimeClient.AuthValues;
                    }
                    return gdsAuthValues;
                }
                else
                {
                    if (gdsAuthValues != null) 
                    {
                        if (IsInstanceValid(gdsAuthValues)) gdsAuthValues.Free();
                    }
                    return null;
                }
            }
            set
            {
                gdsAuthValues = value;
                var tmp = gdsAuthValues.Get("_base") as PhotonRealtimeAuthenticationValues;
                realtimeClient.AuthValues = tmp.AuthenticationValues;
            }
        }
        private Reference gdsAuthValues = null;
        // private PhotonRealtimeAuthenticationValues AuthValues ;//{ get;private set;}
        public AuthModeOption AuthMode{get=>realtimeClient.AuthMode;set=>realtimeClient.AuthMode=value;}
        public EncryptionMode EncryptionMode{get=>realtimeClient.EncryptionMode;set=>realtimeClient.EncryptionMode=value;}
        public ConnectionProtocol? ExpectedProtocol { get=>realtimeClient.ExpectedProtocol; set=>realtimeClient.ExpectedProtocol=value; }
        public bool IsUsingNameServer { get=>realtimeClient.IsUsingNameServer; set=>realtimeClient.IsUsingNameServer=value; }
        public string NameServerHost { get=>realtimeClient.NameServerHost; set=>realtimeClient.NameServerHost=value; }
        public string NameServerAddress =>realtimeClient.NameServerAddress; 
        
        /// <summary>Typical ports: UDP: 5058 or 27000, TCP: 4533, WSS: 19093 or 443.</summary>
        public ushort NameServerPortOverride{ get=>realtimeClient.ServerPortOverrides.NameServerPort;set=> realtimeClient.ServerPortOverrides.NameServerPort=value;}
        /// <summary>Typical ports: UDP: 5056 or 27002, TCP: 4530, WSS: 19090 or 443.</summary>
        public ushort MasterServerPortOverride{ get=>realtimeClient.ServerPortOverrides.MasterServerPort;set=> realtimeClient.ServerPortOverrides.MasterServerPort=value;}
        /// <summary>Typical ports: UDP: 5055 or 27001, TCP: 4531, WSS: 19091 or 443.</summary>
        public ushort GameServerPortOverride{ get=>realtimeClient.ServerPortOverrides.GameServerPort;set=> realtimeClient.ServerPortOverrides.GameServerPort=value;}
        public bool EnableProtocolFallback { get=>realtimeClient.EnableProtocolFallback; set=>realtimeClient.EnableProtocolFallback=value; }
        public string CurrentServerAddress=>realtimeClient.CurrentServerAddress;
        public string MasterServerAddress { get=>realtimeClient.MasterServerAddress; set=>realtimeClient.MasterServerAddress=value; }
        public string GameServerAddress =>realtimeClient.GameServerAddress;
        public ServerConnection Server =>realtimeClient.Server;
        public string ProxyServerAddress{get=>realtimeClient.ProxyServerAddress;set=>realtimeClient.ProxyServerAddress=value;}
        public ClientState State{get=>realtimeClient.State;set=>realtimeClient.State=value;}
        public bool IsRealtimeConnected =>realtimeClient.IsConnected; //不一定正式可用
        public bool IsConnectedAndReady =>realtimeClient.IsConnectedAndReady;
        public DisconnectCause DisconnectedCause =>realtimeClient.DisconnectedCause;
        public bool InLobby=>realtimeClient.InLobby;
        public PhotonTypedLobby CurrentLobby{get;private set;}
        public bool EnableLobbyStatistics{get=>realtimeClient.EnableLobbyStatistics;set=>realtimeClient.EnableLobbyStatistics=value;}
        
        public Reference LocalGDSPlayer 
        {
            get{
                return LocalPlayer.GDSplayer;// gds 类
            }
        }
        public PhotonPlayer LocalPlayer{get;private set;} // c# 类
        public string NickName {get=>realtimeClient.NickName;set=>realtimeClient.NickName=value;}
        public string UserId{get=>realtimeClient.UserId;set=>realtimeClient.UserId=value;}
        public Reference CurrentGDSRoom
        {
            get
            {
                if (CurrentRoom == null)return null;
                else return CurrentRoom.GDSRoom;
            }
        }
        public PhotonRoom CurrentRoom{get;private set;}
        public bool InRoom=>realtimeClient.InRoom;
        public int PlayersOnMasterCount=>realtimeClient.PlayersOnMasterCount;
        public int PlayersInRoomsCount=>realtimeClient.PlayersInRoomsCount;
        public int RoomsCount=>realtimeClient.RoomsCount;
        public bool IsFetchingFriendList=>realtimeClient.IsFetchingFriendList;
        public string CloudRegion=>realtimeClient.CloudRegion;
        public string CurrentCluster=>realtimeClient.CurrentCluster;
        public Reference GDSRegionHandler=>RegionHandler.GDSRegionHandler;
        public PhotonRegionHandler RegionHandler{get;private set;} = null;
        public string SummaryToCache {get=>realtimeClient.SummaryToCache;set=>realtimeClient.SummaryToCache=value;}
        public int NameServerPortInAppSettings{get=>realtimeClient.NameServerPortInAppSettings; set=>realtimeClient.NameServerPortInAppSettings=value;}
        #endregion

        #region Realtime 方法
        public void ChangeLocalID(int newID)
        {
            if (this.LocalPlayer == null)
            {
                realtimeClient.DebugReturn(DebugLevel.WARNING, string.Format("Local actor is null or not in mActors! mLocalActor: {0} mActors==null: {1} newID: {2}", this.LocalPlayer, this.CurrentRoom.Players == null, newID));
            }

            if (this.CurrentRoom == null)
            {
                // change to new actor/player ID and make sure the player does not have a room reference left
                this.LocalPlayer.ChangeLocalID(newID);
                this.LocalPlayer.RoomReference = null;
            }
            else
            {
                // remove old actorId from actor list
                this.CurrentRoom.RemovePlayer(this.LocalPlayer);

                // change to new actor/player ID
                this.LocalPlayer.ChangeLocalID(newID);

                // update the room's list with the new reference
                this.CurrentRoom.StorePlayer(this.LocalPlayer);
            }
        }


        public bool OpChangeGroups(byte[] groupsToRemove, byte[] groupsToAdd)
        {
            return realtimeClient.OpChangeGroups(groupsToRemove, groupsToAdd);
        }
        public bool OpCreateRoom(PhotonEnterRoomParams enterRoomParams)
        {
            return realtimeClient.OpCreateRoom(enterRoomParams.EnterRoomParams);
        }
            
        public bool OpFindFriends(string[] friendsToFind,
                                          bool hasOptions = false,
                                          bool createdOnGs = false,
                                          bool visible = false,
                                          bool open = false)
        {
            return realtimeClient.OpFindFriends(friendsToFind,(! hasOptions) ? null : new FindFriendsOptions(){
                CreatedOnGs = createdOnGs,
                Visible =visible,
                Open = open
            });
        }
        public bool OpGetGameList(PhotonTypedLobby typedLobby, string sqlLobbyFilter)
        {
            return realtimeClient.OpGetGameList(typedLobby.TypedLobby, sqlLobbyFilter);
        }

        public bool OpJoinLobby(PhotonTypedLobby typedLobby)
        {
            var result = realtimeClient.OpJoinLobby(typedLobby.TypedLobby);
            if (result)
            {
                CurrentLobby = new PhotonTypedLobby (realtimeClient.CurrentLobby);
            }
            return result;
        }

        public bool OpJoinOrCreateRoom(PhotonEnterRoomParams enterRoomParams)
        {
            return realtimeClient.OpJoinOrCreateRoom(enterRoomParams.EnterRoomParams);
        }

        public bool OpJoinRandomOrCreateRoom(PhotonOpJoinRandomRoomParams opJoinRandomRoomParams, PhotonEnterRoomParams createRoomParams)
        {
            return realtimeClient.OpJoinRandomOrCreateRoom(opJoinRandomRoomParams.OpJoinRandomRoomParams,createRoomParams.EnterRoomParams);
        }
        public bool OpJoinRandomRoom(PhotonOpJoinRandomRoomParams opJoinRandomRoomParams=null)
        {
            return realtimeClient.OpJoinRandomRoom((opJoinRandomRoomParams==null)? null :opJoinRandomRoomParams.OpJoinRandomRoomParams);
        }
        public bool OpJoinRoom(PhotonEnterRoomParams enterRoomParams)
        {
            return realtimeClient.OpJoinRoom(enterRoomParams.EnterRoomParams);
        }
        public bool OpLeaveLobby()
        {
            return realtimeClient.OpLeaveLobby();
        }
        public bool OpLeaveRoom(bool becomeInactive, bool sendAuthCookie = false)
        {
            return realtimeClient.OpLeaveRoom(becomeInactive,sendAuthCookie);
        }
        public bool OpRaiseEvent(byte eventCode,
                               object customEventContent,
                               PhotonRaiseEventOptions raiseEventOptions ,
                               PhotonSendOptions sendOptions )
        {
            return realtimeClient.OpRaiseEvent(eventCode,customEventContent,raiseEventOptions.RaiseEventOptions,sendOptions.SendOptions);
        }
        public bool OpRejoinRoom(string roomName)
        {
            return realtimeClient.OpRejoinRoom(roomName);
        }
        public bool OpSetCustomPropertiesOfActor(int actorNr,
                                                         Godot.Collections.Dictionary propertiesToSet,
                                                         Godot.Collections.Dictionary expectedProperties = null,
                                                         PhotonWebFlags webFlags = null)
        {
            return realtimeClient.OpSetCustomPropertiesOfActor(actorNr,
                                                               new Hashtable(propertiesToSet),
                                                               (expectedProperties == null) ? null : new Hashtable(expectedProperties),
                                                               (webFlags == null) ? null : webFlags.WebFlags);
        }
        
        public bool OpSetCustomPropertiesOfRoom(Godot.Collections.Dictionary propertiesToSet,
                                                        Godot.Collections.Dictionary expectedProperties = null,
                                                        PhotonWebFlags webFlags = null)
        {
            return realtimeClient.OpSetCustomPropertiesOfRoom(new Hashtable(propertiesToSet),
                                                              (expectedProperties == null) ? null : new Hashtable(expectedProperties),
                                                              (webFlags == null) ? null : webFlags.WebFlags);
        }
        
        public bool OpWebRpc(string uriPath, object parameters, bool sendAuthCookie = false)
        {
            return realtimeClient.OpWebRpc(uriPath,parameters,sendAuthCookie);
        }
        #endregion

        #region Realtime 回调

        [Signal] //
        delegate void OpResponseReceived(PhotonOperationResponse operationResponse); // 低级别的回调，不建议直接使用
        [Signal] // 
        delegate void EventReceived(PhotonEventData eventData);
        [Signal]
        delegate void StateChanged(ClientState previousState, ClientState currentState);

        #region Connection 信号
        [Signal]
        delegate void Connected(); // 并不意味着连接正式可用
        [Signal]
        delegate void ConnectedToMaster(); // 连接正式可用
        [Signal]
        delegate void CustomAuthenticationFailed(string debugMessage);
        [Signal]
        delegate void CustomAuthenticationResponsed(Godot.Collections.Dictionary<string, object> data);
        [Signal]
        delegate void Disconnected(DisconnectCause cause);
        [Signal]
        delegate void RegionListReceived(Reference regionHandler);

        #endregion

        #region Error 信号
        [Signal]
        delegate void ErrorInfoReveived(PhotonErrorInfo errorInfo);
        #endregion

        #region WebRpc 信号
        [Signal]
        delegate void WebRpcResponsed(PhotonWebRpcResponse response);
        #endregion

        #region MatchMaking 信号
        [Signal]
        delegate void RoomCreated();
        [Signal]
        delegate void RoomJoined();
        [Signal]
        delegate void CreateRoomFailed(short returnCode, string message);
        [Signal]
        delegate void JoinRoomFailed(short returnCode, string message);
        [Signal]
        delegate void JoinRandomFailed(short returnCode, string message);
        [Signal]
        delegate void RoomLefting();
        [Signal] // <PhotonFriendInfo>
        delegate void FriendListUpdated(Godot.Collections.Array friendList);
                        
        #endregion

        #region InRoom 信号
        [Signal]
        delegate void PlayerRoomEntered(Reference newPlayer);
        [Signal]
        delegate void PlayerRoomLefting(Reference otherPlayer);
        [Signal]
        delegate void RoomPropertiesUpdated(Godot.Collections.Dictionary changedProps);
        [Signal]
        delegate void PlayerPropertiesUpdated(Reference targetPlayer, Godot.Collections.Dictionary changedProps);
        [Signal]
        delegate void MasterClientSwitched(Reference newMasterClient);
        #endregion

        #region InLobby 信号
        [Signal]
        delegate void LobbyJoined();
        [Signal]
        delegate void LobbyLefting();
        [Signal]
        delegate void RoomListUpdated(Godot.Collections.Array<PhotonRoomInfo> roomList);
        [Signal]
        delegate void LobbyStatisticsUpdated(Godot.Collections.Array<PhotonTypedLobbyInfo> lobbyStatistics);
        #endregion


        void IConnectionCallbacks.OnConnected()
            => EmitSignal(nameof(Connected));

        void IConnectionCallbacks.OnConnectedToMaster()
            => EmitSignal(nameof(ConnectedToMaster));
        void IConnectionCallbacks.OnCustomAuthenticationFailed(string debugMessage)
            => EmitSignal(nameof(CustomAuthenticationFailed),debugMessage);
        void IConnectionCallbacks.OnCustomAuthenticationResponse(Dictionary<string, object> data)
            => EmitSignal(nameof(CustomAuthenticationResponsed),new Godot.Collections.Dictionary<string, object>(data));
        
        void IConnectionCallbacks.OnDisconnected(DisconnectCause cause)
            => EmitSignal(nameof(Disconnected),cause);
        
        void IConnectionCallbacks.OnRegionListReceived(RegionHandler regionHandler)
        {
            if (this.RegionHandler == null) this.RegionHandler = new PhotonRegionHandler();
            this.RegionHandler.init(regionHandler); 
            EmitSignal(nameof(RegionListReceived), this.GDSRegionHandler);
        }
        
        void IErrorInfoCallback.OnErrorInfo(Photon.Realtime.ErrorInfo errorInfo)
            => EmitSignal(nameof(ErrorInfoReveived), PhotonErrorInfo.GetUniqueInstance(errorInfo));

        void IWebRpcCallback.OnWebRpcResponse(OperationResponse response)
        {
            EmitSignal(nameof(WebRpcResponsed), PhotonWebRpcResponse.GetUniqueInstance(response));
        }


        void IInRoomCallbacks.OnPlayerEnteredRoom(Player newPlayer)
        {
            var _newPlayer = CurrentRoom.GetGDSPlayer(newPlayer.ActorNumber);
            if (_newPlayer == null )
            {
                _newPlayer = new PhotonPlayer(newPlayer).GDSplayer;
                CurrentRoom.Players[newPlayer.ActorNumber] = _newPlayer;
            } 
            else (_newPlayer.Get("_base") as PhotonPlayer).Player = newPlayer;
            EmitSignal(nameof(PlayerRoomEntered),_newPlayer);
        }

        void IInRoomCallbacks.OnPlayerLeftRoom(Player otherPlayer)
        {
            var leftPlayer = CurrentRoom.GetGDSPlayer(otherPlayer.ActorNumber);
            if (leftPlayer == null) 
            {
                PushError("Warps Logic err: A Player left room but can't find in PhotonRoom.");
                leftPlayer = new PhotonPlayer(otherPlayer);
            }
            // 真正离开房间时，从字典里移除
            if (!otherPlayer.IsInactive) CurrentRoom.Players.Remove(otherPlayer.ActorNumber);

            EmitSignal(nameof(PlayerRoomLefting), leftPlayer );
        }

        void IInRoomCallbacks.OnRoomPropertiesUpdate(Hashtable propertiesThatChanged)
        {
            CurrentRoom.MergeCustomProperties(propertiesThatChanged);
            EmitSignal(nameof(RoomPropertiesUpdated), new Godot.Collections.Dictionary(propertiesThatChanged));
        }

        void IInRoomCallbacks.OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
        {
            var p = CurrentRoom.GetGDSPlayer(targetPlayer.ActorNumber);
            (p.Get("_base") as PhotonPlayer).MergeCustomProperties(changedProps);
            EmitSignal(nameof(PlayerPropertiesUpdated),p, new Godot.Collections.Dictionary(changedProps));
        }

        void IInRoomCallbacks.OnMasterClientSwitched(Player newMasterClient)
            => EmitSignal(nameof(MasterClientSwitched),CurrentRoom.GetGDSPlayer(newMasterClient.ActorNumber));


        void ILobbyCallbacks.OnJoinedLobby() => EmitSignal(nameof(LobbyJoined));

        void ILobbyCallbacks.OnLeftLobby() => EmitSignal(nameof(LobbyLefting));

        private static GDScript GDSRoomInfoClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/RaiseEventOptions.gd");

        void ILobbyCallbacks.OnRoomListUpdate(List<RoomInfo> roomList)
        {
            var r = new Godot.Collections.Array<Reference>();
            foreach (var roomInfo in roomList)
            {
                r.Add(GDSRoomInfoClass.New(roomInfo.RemovedFromList, 
                        new Godot.Collections.Dictionary(roomInfo.CustomProperties),
                        (roomInfo.Name == null)? "": roomInfo.Name,
                        roomInfo.PlayerCount,
                        roomInfo.MaxPlayers,
                        roomInfo.IsOpen,
                        roomInfo.IsVisible
                        ) as Reference);
            }
            EmitSignal(nameof(RoomListUpdated),r);
        }

        private static GDScript GDSLobbyInfoClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/TypedLobbyInfo.gd");
        void ILobbyCallbacks.OnLobbyStatisticsUpdate(List<TypedLobbyInfo> lobbyStatistics)
        {
            var r = new Godot.Collections.Array<Reference>();
            foreach (var lobbyInfo in lobbyStatistics)
            {
                r.Add(GDSLobbyInfoClass.New(
                    (lobbyInfo.Name==null)?null:lobbyInfo.Name,
                    lobbyInfo.Type,
                    lobbyInfo.PlayerCount,
                    lobbyInfo.RoomCount
                ) as Reference);
            }
            EmitSignal(nameof(LobbyStatisticsUpdated),r);
        }
        
        
        private static GDScript GDSFriendInfoClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/FriendInfo.gd");
        void IMatchmakingCallbacks.OnFriendListUpdate(List<FriendInfo> friendList)
        {
            var friendInfoList = new Godot.Collections.Array<Reference>();
            foreach (var info in friendList)
            {
                friendInfoList.Add(GDSFriendInfoClass.New(
                    (info.UserId == null)? "" : info.UserId,
                    info.IsOnline,
                    (info.Room == null)? "" : info.Room,
                    info.IsInRoom
                ) as Reference);
            }
            EmitSignal(nameof(FriendListUpdated),new Godot.Collections.Array(friendInfoList));
        }

        void IMatchmakingCallbacks.OnCreatedRoom()
        {
            // CurrentRoom = new PhotonRoom(realtimeClient.CurrentRoom, LocalPlayer);
            EmitSignal(nameof(RoomCreated));
        }
        void IMatchmakingCallbacks.OnJoinedRoom()
        {
            if (CurrentRoom.Room == null || CurrentRoom.Room != realtimeClient.CurrentRoom)
            {
                CurrentRoom = new PhotonRoom(realtimeClient.CurrentRoom, LocalPlayer);
            }
            EmitSignal(nameof(RoomJoined));
        }

        void IMatchmakingCallbacks.OnCreateRoomFailed(short returnCode, string message) 
            => EmitSignal(nameof(CreateRoomFailed), returnCode, message);
        

        void IMatchmakingCallbacks.OnJoinRoomFailed(short returnCode, string message) 
            => EmitSignal(nameof(JoinRoomFailed), returnCode, message);
        

        void IMatchmakingCallbacks.OnJoinRandomFailed(short returnCode, string message) 
            => EmitSignal(nameof(JoinRandomFailed), returnCode, message);
        

        void IMatchmakingCallbacks.OnLeftRoom() => 
            EmitSignal(nameof(RoomLefting));
        
        #endregion


    }
}