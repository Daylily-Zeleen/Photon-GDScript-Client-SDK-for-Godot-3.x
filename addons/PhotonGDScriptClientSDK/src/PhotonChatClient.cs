// using System.Collections.Generic;
using System.Collections;
using Photon.Realtime;
using Photon.Chat;
using Godot;
using Godot.Collections;
using static Godot.GD;
using System;
using ExitGames.Client.Photon;
using PhotonGodotWarps.Warps;



namespace PhotonGodotWarps.src
{
    public class PhotonChatClient:Reference,IChatClientListener
    {
        #region 自定义
        public bool BGSend {get=>backgroudThreadConfig.BGSend;set=>backgroudThreadConfig.BGSend=value;}
        public bool BGDispatch {get=>backgroudThreadConfig.BGDispatch;set=>backgroudThreadConfig.BGDispatch=value;}
        public int BGSendIntervalMs {get=>backgroudThreadConfig.MsSendInterval;set=>backgroudThreadConfig.MsSendInterval=value;}
        public int BGDispatchIntervalMs {get=>backgroudThreadConfig.MsDispathcInterval;set=>backgroudThreadConfig.MsDispathcInterval=value;}

        public bool BGSendSingle {get=>backgroudThreadConfig.SendSingle;set=>backgroudThreadConfig.SendSingle=value;}
        public bool BGDispatchSingle {get=>backgroudThreadConfig.DispatchSingle;set=>backgroudThreadConfig.DispatchSingle=value;}
        private readonly PhotonClientBackgroundThreadConfig backgroudThreadConfig ;

        public bool ReuseEventInstance // default true
        {
            get=>chatClient.chatPeer.ReuseEventInstance;
            set
            {
                PhotonEventData.ReuseChatEventInstance = value;
                chatClient.chatPeer.ReuseEventInstance = value;
            }
        }
            
        #endregion
        private ChatClient chatClient ;
        /// <summary>
        /// 用于gds包装用的直接构造（preload c# 脚本不能带参new())
        /// 需要进一步调用 init()
        /// </summary>
        public PhotonChatClient()
        {
            backgroudThreadConfig = new PhotonClientBackgroundThreadConfig(
                                new Func<bool>(SendOutgoingCommands),
                                new Func<bool>(DispatchIncomingCommands)
                            );
        }
        public void init(ConnectionProtocol protocol = ConnectionProtocol.Udp)
        {
            chatClient = new ChatClient(this, protocol);
            // 出于性能考虑，且chatClient的交互不依赖 EventData
            this.ReuseEventInstance = true;
        }
        ~PhotonChatClient() => chatClient.Disconnect();
        

        public bool ConnectUsingSettings(PhotonChatAppSettings appSettings)
        {
            return chatClient.ConnectUsingSettings(appSettings.ChatAppSettings);
        }
        /// <summary>
        /// Connects this client to the Photon Chat Cloud service, which will also authenticate the user (and set a UserId).
        /// </summary>
        /// <param name="appId">Get your Photon Chat AppId from the <a href="https://dashboard.photonengine.com">Dashboard</a>.</param>
        /// <param name="appVersion">Any version string you make up. Used to separate users and variants of your clients, which might be incompatible.</param>
        /// <param name="authValues">Values for authentication. You can leave this null, if you set a UserId before. If you set authValues, they will override any UserId set before.</param>
        /// <returns></returns>
        public bool Connect(string appId, string appVersion, Reference authValues)
        {
            gdsAuthValues = authValues;
            return chatClient.Connect(appId,appVersion,(gdsAuthValues.Get("_base") as PhotonChatAuthenticationValues).AuthenticationValues);
        }

        /// <summary>
        /// Connects this client to the Photon Chat Cloud service, which will also authenticate the user (and set a UserId).
        /// This also sets an online status once connected. By default it will set user status to <see cref="ChatUserStatus.Online"/>.
        /// See <see cref="SetOnlineStatus(int,object)"/> for more information.
        /// </summary>
        /// <param name="appId">Get your Photon Chat AppId from the <a href="https://dashboard.photonengine.com">Dashboard</a>.</param>
        /// <param name="appVersion">Any version string you make up. Used to separate users and variants of your clients, which might be incompatible.</param>
        /// <param name="authValues">Values for authentication. You can leave this null, if you set a UserId before. If you set authValues, they will override any UserId set before.</param>
        /// <param name="status">User status to set when connected. Predefined states are in class <see cref="ChatUserStatus"/>. Other values can be used at will.</param>
        /// <param name="message">Optional status Also sets a status-message which your friends can get.</param>
        /// <returns>If the connection attempt could be sent at all.</returns>
        public bool ConnectAndSetStatus(string appId, string appVersion, Reference authValues,
            int status = ChatUserStatus.Online, object message = null)
        {
            gdsAuthValues = authValues;
            return chatClient.ConnectAndSetStatus(appId, appVersion, (gdsAuthValues.Get("_base") as PhotonChatAuthenticationValues).AuthenticationValues, status, message);
        }

        
        /// <summary>
        /// 断开 chat 模块的连接
        /// </summary>
        /// <param name="!"></param>
        public void Disconnect(ChatDisconnectCause cause = ChatDisconnectCause.DisconnectByClientLogic) => chatClient.Disconnect(cause);

        public void Service() => chatClient.Service();
        public bool DispatchIncomingCommands() 
        {
            if (chatClient.chatPeer == null) return false;
            return chatClient.chatPeer.DispatchIncomingCommands();
        }
        public bool SendOutgoingCommands()
        {
            if (chatClient.chatPeer == null) return false;
            return chatClient.chatPeer.SendOutgoingCommands();
        }


        #region Chat 属性
        /// <summary>Enables a fallback to another protocol in case a connect to the Name Server fails.</summary>
        /// <remarks>
        /// When connecting to the Name Server fails for a first time, the client will select an alternative
        /// network protocol and re-try to connect.
        ///
        /// The fallback will use the default Name Server port as defined by ProtocolToNameServerPort.
        ///
        /// The fallback for TCP is UDP. All other protocols fallback to TCP.
        /// </remarks>
        public bool EnableProtocolFallback { get=>chatClient.EnableProtocolFallback; set=>chatClient.EnableProtocolFallback=value; }
        /// <summary>The address of last connected Name Server.</summary>
        public string NameServerAddress=>chatClient.NameServerAddress;
        /// <summary>The address of the actual chat server assigned from NameServer. Public for read only.</summary>
        public string FrontendAddress=>chatClient.FrontendAddress;
        /// <summary>Settable only before you connect! Defaults to "EU".</summary>
        public string ChatRegion
        {
            get { return chatClient.ChatRegion; }
            set { chatClient.ChatRegion = value; }
        }
        /// <summary>The version of your client. A new version also creates a new "virtual app" to separate players from older client versions.</summary>
        public string AppVersion =>chatClient.AppVersion;
        /// <summary>The AppID as assigned from the Photon Cloud.</summary>
        public string AppId=>chatClient.AppId;

        private readonly static GDScript GDSAuthValuesClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/ChatAuthenticationValues.gd");
        
        /// <summary>Settable only before you connect!</summary>
        /// <summary>User authentication values to be sent to the Photon server right after connecting.</summary>
        /// <remarks>Set this property or pass AuthenticationValues by Connect(..., authValues).</remarks>
        public Reference GDSAuthValues 
        { 
            get
            {
                if (chatClient.AuthValues != null)
                {
                    if (!IsInstanceValid(gdsAuthValues))
                    {
                        gdsAuthValues = GDSAuthValuesClass.New() as Reference;
                    }
                    var tmp = gdsAuthValues.Get("_base") as PhotonChatAuthenticationValues;
                    if (tmp.AuthenticationValues != chatClient.AuthValues)
                    {
                        if (!tmp.IsQueuedForDeletion()) tmp.Free();
                        tmp.AuthenticationValues = chatClient.AuthValues;
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
                var tmp = gdsAuthValues.Get("_base") as PhotonChatAuthenticationValues;
                chatClient.AuthValues = tmp.AuthenticationValues;
            }
        }
        private Reference gdsAuthValues = null;
        // public PhotonChatAuthenticationValues AuthValues { get; set; }
        // private PhotonChatAuthenticationValues authValues;
        public ChatState State=>chatClient.State;
        public ChatDisconnectCause DisconnectedCause => chatClient.DisconnectedCause;
        public bool CanChat =>chatClient.CanChat;
        public string UserId =>chatClient.UserId;
        public int MessageLimit 
        {
            get=>chatClient.MessageLimit;
            set=>chatClient.MessageLimit = value;
        }
        public int PrivateChatHistoryLength
        {   
            get=>chatClient.PrivateChatHistoryLength;
            set=>chatClient.PrivateChatHistoryLength=value;
        }
        
        public readonly Dictionary<string, Reference> PublicChannels = new Dictionary<string, Reference>();
        public readonly Dictionary<string, Reference> PrivateChannels = new Dictionary<string, Reference>();

        public bool UseBackgroundWorkerForSending 
        {
            get=>chatClient.UseBackgroundWorkerForSending;
            set=>chatClient.UseBackgroundWorkerForSending = value;
        }
        public ConnectionProtocol TransportProtocol
        {
            get=>chatClient.TransportProtocol;
            set=>chatClient.TransportProtocol=value;
        }
        public DebugLevel DebugOut
        {
            get=>chatClient.DebugOut;
            set=>chatClient.DebugOut=value;
        }
        #endregion

        #region Chat 方法
        
        public bool AddFriends(string[] firends) => chatClient.AddFriends(firends);
        public bool RemoveFriends(string[] friends)
            => chatClient.RemoveFriends(friends);
        
        #region 调试用方法        
        /// <summary>
        /// Get you the (locally used) channel name for the chat between this client and another user.
        /// </summary>
        /// <param name="userName">Remote user's name or UserId.</param>
        /// <returns>The (locally used) channel name for a private channel.</returns>
        /// <remarks>Do not subscribe to this channel.
        /// Private channels do not need to be explicitly subscribed to.
        /// Use this for debugging purposes mainly.</remarks>
        public string GetPrivateChannelNameByUser(string userName) =>chatClient.GetPrivateChannelNameByUser(userName);
        
        #endregion





        public bool CanChatInChannel(string channelName) => chatClient.CanChatInChannel(channelName);
        
        public bool Subscribe(string[] channels) => chatClient.Subscribe(channels);
        
        public bool SubscribeAndGetHistoryByLastMessageId(string[] channels,int[] lastMsgIds) => chatClient.Subscribe(channels, lastMsgIds);
        public bool SubscribeAndGetHistoryByMessageCount(string[] channels,int messagesFromHistory=-1) => chatClient.Subscribe(channels,messagesFromHistory);
        
        public bool Unsubscribe(string[] channels)=>chatClient.Unsubscribe(channels);
        public bool SubscribeSingleChannel(string channel,int lastMsgId = 0,int messagesFromHistory = -1, 
                PhotonChannelCreationOptions creationOptions = null)
            => chatClient.Subscribe(channel, lastMsgId, messagesFromHistory, creationOptions.Options);
            
        /// <summary>
        /// 向频道发送消息
        /// </summary>
        /// <param name="channelName"></param>
        /// <param name="message"> string 或 其他Phton支持的可序列化对象 </param>
        /// <param name="reliable"></param>
        /// <param name="forwardAsWebhook"></param>
        /// <returns></returns>
        public bool PublishMessage(string channelName,object message ,bool reliable = true,
                bool forwardAsWebhook = false)
        {
            if (reliable) return chatClient.PublishMessage(channelName,message,forwardAsWebhook);
            else return chatClient.PublishMessageUnreliable(channelName,message,forwardAsWebhook);
        }
        
        /// <summary>
        /// 向私人发送消息
        /// </summary>
        /// <param name="targetUserId"></param>
        /// <param name="message">string 或 其他Phton支持的可序列化对象 </param>
        /// <param name="encrypt"></param>
        /// <param name="reliable"></param>
        /// <param name="forwardAsWebhook"></param>
        /// <returns></returns>
        public bool SendPrivateMessage(string targetUserId, object message, bool encrypt = false, 
                bool reliable=true, bool forwardAsWebhook = false)
        {
            if(reliable)return chatClient.SendPrivateMessage(targetUserId,message,encrypt,forwardAsWebhook);
            else return chatClient.SendPrivateMessageUnreliable(targetUserId, message, encrypt, forwardAsWebhook);
        }
        
        public bool SetOnlineStatus(int newStatus, object newStatusMsg=null)
        {
            if (newStatusMsg == null) return chatClient.SetOnlineStatus(newStatus);
            else return chatClient.SetOnlineStatus(newStatus,newStatusMsg);
        }


        /// <summary>
        /// Simplified access to either private or public channels by name.
        /// </summary>
        /// <param name="channelName">Name of the channel to get. For private channels, the channel-name is composed of both user's names.</param>
        /// <param name="isPrivate">Define if you expect a private or public channel.</param>
        /// <param name="channel">Out parameter gives you the found channel, if any.</param>
        /// <returns>True if the channel was found.</returns>
        /// <remarks>Public channels exist only when subscribed to them.
        /// Private channels exist only when at least one message is exchanged with the target user privately.</remarks>
        public Reference TryGetChannelWithPrivateOrNot(string channelName, bool isPrivate)
        {
            Reference channel=null;
            if (!isPrivate)
            {
                this.PublicChannels.TryGetValue(channelName, out channel);
            }
            else
            {
                this.PrivateChannels.TryGetValue(channelName, out channel);
            }
            return channel;
        } 

        /// <summary>
        /// Simplified access to all channels by name. Checks public channels first, then private ones.
        /// </summary>
        /// <param name="channelName">Name of the channel to get.</param>
        /// <param name="channel">Out parameter gives you the found channel, if any.</param>
        /// <returns>True if the channel was found.</returns>
        /// <remarks>Public channels exist only when subscribed to them.
        /// Private channels exist only when at least one message is exchanged with the target user privately.</remarks>
        public Reference TryGetChannel(string channelName)
        {
            Reference channel=null;
            if (this.PublicChannels.TryGetValue(channelName, out channel)) 
                return channel;
            else
            {
                this.PrivateChannels.TryGetValue(channelName, out channel);
                return channel;
            }
        }



        public Reference TryGetPrivateChannelByUser(string userName)
        {
            if (string.IsNullOrEmpty(userName))
            {
                return null;
            }
            string channelName = this.GetPrivateChannelNameByUser(userName);
            return this.TryGetChannelWithPrivateOrNot(channelName, true);
        }
        
        
        #if CHAT_EXTENDED

        public bool SetCustomChannelProperties(string channelName, Dictionary<string, object> channelProperties, Dictionary<string, object> expectedProperties = null, bool httpForward = false) =>
            chatClient.SetCustomChannelProperties(channelName,
                                                new System.Collections.Generic.Dictionary<string, object>(channelProperties), 
                                                (expectedProperties==null) ? null : new System.Collections.Generic.Dictionary<string, object>(expectedProperties), httpForward);

        public bool SetCustomUserProperties(string channelName, string userId, Dictionary<string, object> userProperties, Dictionary<string, object> expectedProperties = null, bool httpForward = false) =>
            chatClient.SetCustomUserProperties(channelName, userId,
                                                new System.Collections.Generic.Dictionary<string, object>(userProperties), 
                                                (expectedProperties==null) ? null : new System.Collections.Generic.Dictionary<string, object>(expectedProperties), httpForward )

        #endif

        #endregion
        #region Chat 回调
        [Signal]
        delegate void DebugRetunMessage(DebugLevel level, string debugMessage);
        [Signal]
        delegate void Connected();
        [Signal]
        delegate void Disconnected();
        [Signal]
        delegate void StateChanged(ChatState currentState);
        [Signal]
        delegate void MessageReceived(string channelName, string[] senders, object[] messages);
        [Signal]
        delegate void PrivateMessageReceived(string sender, Reference message, string channelName);
        [Signal]
        delegate void Subscribed(string[] channels, Godot.Collections.Array<bool> results);
        [Signal]
        delegate void Unsubscribed(string[] channels);
        [Signal]
        delegate void StatusUpdated(string userName, int status, bool gotMessage, Reference statusMessage);
        [Signal]
        delegate void UserSubscribed(string channelName, string userId);       
        [Signal]
        delegate void UserUnsubscribed(string channelName, string userId);

        #if CHAT_EXTENDED
        [Siganel]
        delegate void ChannelPropertiesChanged(string channel, string senderUserId, Dictionary<object, object> properties);
        [Siganel]
        delegate void UserPropertiesChanged(string channel, string targetUserId, string senderUserId, Dictionary<object, object> properties);
        [Siganel]
        delegate void ErrorInfoReceived(string channel, string error, Reference data);

        #endif

        #if SDK_V4
        [Signal]
        delegate void BroadcastMessageReceived(string channel, byte[] message);
        #endif

        void IChatClientListener.DebugReturn(DebugLevel level, string message) =>
            EmitSignal(nameof(DebugRetunMessage),level,message);

        void IChatClientListener.OnDisconnected() =>
            EmitSignal(nameof(Disconnected));
        
        void IChatClientListener.OnConnected() =>
            EmitSignal(nameof(Connected));

        void IChatClientListener.OnChatStateChange(ChatState state) =>
            EmitSignal(nameof(StateChanged),state);

        void IChatClientListener.OnGetMessages(string channelName, string[] senders, object[] messages)
        {
            Reference channel;
            if (!this.PublicChannels.TryGetValue(channelName, out channel))
            {
                if (this.DebugOut >= DebugLevel.WARNING)
                {
                    ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, "Channel " + channelName + " for incoming message event not found.");
                }
                return;
            }
            EmitSignal(nameof(MessageReceived), channelName, senders, new Godot.Collections.Array(messages));
        }
        void IChatClientListener.OnPrivateMessage(string sender, object message, string channelName)
        {            
            Reference gdsChannel;
            if (!this.PrivateChannels.TryGetValue(channelName, out gdsChannel))
            {
                var channel = new PhotonChatChannel(chatClient.PrivateChannels[channelName]);
                gdsChannel = channel.GDSChatChannel;
                this.PrivateChannels.Add(channel.Name, gdsChannel);
            }
            EmitSignal(nameof(PrivateMessageReceived),sender,message,channelName);
        }
        void IChatClientListener.OnSubscribed(string[] channels, bool[] results) 
        {
            for (int i = 0; i < channels.Length; i++)
            {
                if (results[i])
                {
                    string channelName = channels[i];
                    Reference gdsChannel;
                    if (!this.PublicChannels.TryGetValue(channelName, out gdsChannel))
                    {
                        var channel = new PhotonChatChannel(chatClient.PublicChannels[channelName]);
                        gdsChannel = channel.GDSChatChannel;
                        this.PublicChannels.Add(channelName , gdsChannel);
                    }
                    (gdsChannel.Get("_base") as PhotonChatChannel).SyncSubscribers();
                    
                }
            }
            EmitSignal(nameof(Subscribed),channels, new Godot.Collections.Array<bool>(results));
        }

        void IChatClientListener.OnUnsubscribed(string[] channels)
        {
            foreach (var channelName in channels)
            {
                PublicChannels.Remove(channelName);
            }
            EmitSignal(nameof(Unsubscribed),channels);
        }
        void IChatClientListener.OnStatusUpdate(string user, int status, bool gotMessage, object message) =>
            EmitSignal(nameof(StatusUpdated),user,status,gotMessage,message);

        void IChatClientListener.OnUserSubscribed(string channelName, string userId)
        {
            //TODO: Handle user properties!

            Reference gdsChannel;
            if (this.PublicChannels.TryGetValue(channelName, out gdsChannel))
            {
                var channel = gdsChannel.Get("_base") as PhotonChatChannel;
                if (!channel.PublishSubscribers)
                {
                    if (this.DebugOut >= DebugLevel.WARNING)
                    {
                        ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\" for incoming UserSubscribed (\"{1}\") event does not have PublishSubscribers enabled.", channelName, userId));
                    }
                }
                if (!channel.Subscribers.Contains(userId)) // user came back from the dead ?
                {
                    if (this.DebugOut >= DebugLevel.WARNING)
                    {
                        ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\" already contains newly subscribed user \"{1}\".", channelName, userId));
                    }
                }
                else channel.Subscribers.Add(userId);
                
                if (channel.MaxSubscribers > 0 && channel.Subscribers.Count > channel.MaxSubscribers)
                {
                    if (this.DebugOut >= DebugLevel.WARNING)
                    {
                        ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\"'s MaxSubscribers exceeded. count={1} > MaxSubscribers={2}.", channelName, channel.Subscribers.Count, channel.MaxSubscribers));
                    }
                }
            }
            else
            {
                if (this.DebugOut >= DebugLevel.WARNING)
                {
                    ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\" not found for incoming UserSubscribed (\"{1}\") event.", channelName, userId));
                }
            }

            EmitSignal(nameof(UserSubscribed),channelName,userId);
        }
        void IChatClientListener.OnUserUnsubscribed(string channelName, string userId)
        {
            Reference gdsChannel;
            if (this.PublicChannels.TryGetValue(channelName, out gdsChannel))
            {
                var channel = gdsChannel.Get("_base") as PhotonChatChannel;
                if (!channel.PublishSubscribers)
                {
                    if (this.DebugOut >= DebugLevel.WARNING)
                    {
                        ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\" for incoming UserUnsubscribed (\"{1}\") event does not have PublishSubscribers enabled.", channelName, userId));
                    }
                }
                if (!channel.Subscribers.Remove(userId)) // user not found!
                {
                    if (this.DebugOut >= DebugLevel.WARNING)
                    {
                        ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\" does not contain unsubscribed user \"{1}\".", channelName, userId));
                    }
                }
            }
            else
            {
                if (this.DebugOut >= DebugLevel.WARNING)
                {
                    ((IChatClientListener)this).DebugReturn(DebugLevel.WARNING, string.Format("Channel \"{0}\" not found for incoming UserUnsubscribed (\"{1}\") event.", channelName, userId));
                }
            }
            
            EmitSignal(nameof(UserUnsubscribed),channelName,userId);
        }

    
        #if CHAT_EXTENDED
        
        /// <summary>
        /// Properties of a public channel has been changed
        /// </summary>
        /// <param name="channel">Channel name in which the properties have changed</param>
        /// <param name="senderUserId">The UserID of the user who changed the properties</param>
        /// <param name="properties">The properties that have changed</param>
        void IChatClientListener.OnChannelPropertiesChanged(string channel, string senderUserId, System.Collections.Generic.Dictionary<object, object> properties)
            => EmitSignal(nameof(ChannelPropertiesChanged),channel,senderUserId,new Dictionary<object, object> (properties));

        /// <summary>
        /// Properties of a user in a public channel has been changed
        /// </summary>
        /// <param name="channel">Channel name in which the properties have changed</param>
        /// <param name="targetUserId">The UserID whom properties have changed</param>
        /// <param name="senderUserId">The UserID of the user who changed the properties</param>
        /// <param name="properties">The properties that have changed</param>
        void IChatClientListener.OnUserPropertiesChanged(string channel, string targetUserId, string senderUserId, System.Collections.Generic.Dictionary<object, object> properties)
            => EmitSignal(nameof(UserPropertiesChanged), channel, targetUserId, senderUserId,new Dictionary<object, object> (properties));

        /// <summary>
        /// The server uses error events to make the client aware of some issues.
        /// </summary>
        /// <remarks>
        /// This is currently used only in Chat WebHooks.
        /// </remarks>
        /// <param name="channel">The name of the channel in which this error info has been received</param>
        /// <param name="error">The text message of the error info</param>
        /// <param name="data">Optional error data</param>
        void IChatClientListener.OnErrorInfo(string channel, string error, object data)
            =>EmitSignal(nameof(ErrorInfoReceived),channel,error,data);
        
        #endif


        #if SDK_V4
        /// <summary>
        /// Received a broadcast message
        /// </summary>
        /// <param name="channel">Name of the chat channel</param>
        /// <param name="message">Message data</param>
        void IChatClientListener.OnReceiveBroadcastMessage(string channel, byte[] message)
            => EmitSignal(nameof(BroadcastMessageReceived),channel,message);
        #endif


        #endregion
    }
}