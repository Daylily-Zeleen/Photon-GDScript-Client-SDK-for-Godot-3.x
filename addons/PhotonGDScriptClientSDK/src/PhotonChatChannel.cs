using Godot;
using Photon.Chat;
using System.Collections.Generic;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonChatChannel:Reference
    {
        /// <summary>Name of the channel (used to subscribe and unsubscribe).</summary>
        public string Name => chatChannel.Name;

        // /// <summary>Senders of messages in chronological order. Senders and Messages refer to each other by index. Senders[x] is the sender of Messages[x].</summary>
        // public readonly Array<string> Senders = new Array<string>();

        // /// <summary>Messages in chronological order. Senders and Messages refer to each other by index. Senders[x] is the sender of Messages[x].</summary>
        // public readonly Array<object> Messages = new Array<object>();

        /// <summary>If greater than 0, this channel will limit the number of messages, that it caches locally.</summary>
        public int MessageLimit {get=>chatChannel.MessageLimit;set=>chatChannel.MessageLimit=value;}

        /// <summary>Unique channel ID.</summary>
        public int ChannelID {get=>chatChannel.ChannelID;set=>chatChannel.ChannelID=value;}

        /// <summary>Is this a private 1:1 channel?</summary>
        public bool IsPrivate =>chatChannel.IsPrivate;

        /// <summary>Count of messages this client still buffers/knows for this channel.</summary>
        public int MessageCount => chatChannel.MessageCount;

        /// <summary>
        /// ID of the last message received.
        /// </summary>
        public int LastMsgId => chatChannel.LastMsgId;

        /// <summary>Whether or not this channel keeps track of the list of its subscribers.</summary>
        public bool PublishSubscribers => chatChannel.PublishSubscribers;

        /// <summary>Maximum number of channel subscribers. 0 means infinite.</summary>
        public int MaxSubscribers => chatChannel.MaxSubscribers;

        /// <summary>Subscribers</summary>
        public Array<string> Subscribers {get;}= new Array<string>();

        private ChatChannel chatChannel;
        private static readonly GDScript GDSChatChannelClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/ChatChannel.gd");
        private readonly WeakRef GDSChatChannelRef ;
        public Reference GDSChatChannel => GDSChatChannelRef.GetRef() as Reference;
        /// <summary>
        /// 对接用
        /// </summary>
        public PhotonChatChannel(){
            GDSChatChannelRef = WeakRef(GDSChatChannelClass.New(this) as Reference);
        }

        /// <summary>Used internally to create new channels. This does NOT create a channel on the server! Use ChatClient.Subscribe.</summary>
        internal PhotonChatChannel(ChatChannel chatChannel):this()
        {
            this.chatChannel = chatChannel;
        }
    


        #region 接口
        public string GetSender(int index)
        {
            if (index < chatChannel.MessageCount) return chatChannel.Senders[index];
            else 
            {
                GD.PushError("Can't get sender by index:"+ index.ToString());
                return null;
            }
        }
        public object GetMessage(int index)
        {
            if (index < chatChannel.MessageCount) return chatChannel.Messages[index];
            else 
            {
                GD.PushError("Can't get sender by index:"+ index.ToString());
                return null;
            }
        }

            
        #endregion




        /// <summary>Provides a string-representation of all messages in this channel.</summary>
        /// <returns>All known messages in format "Sender: Message", line by line.</returns>
        public string ToStringMessages() => chatChannel.ToStringMessages();

        internal void SyncSubscribers()
        {
            this.Subscribers.Clear();
            foreach (var userID in chatChannel.Subscribers)
            {
                Subscribers.Add(userID);
            }
        }


        #if CHAT_EXTENDED
        public object TryGetCustomChannelProperty(string propertyKey)
        {
            object value;
            if (TryGetCustomChannelProperty(propertyKey,out value)) return value;
            return null;
        } 
        public bool TryGetCustomChannelProperty<T>(string propertyKey, out T propertyValue)
        {
            return this.TryGetChannelProperty(propertyKey, out propertyValue);
        }
        #endif
    }
}