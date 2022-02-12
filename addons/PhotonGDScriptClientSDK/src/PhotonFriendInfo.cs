using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
using ExitGames.Client.Photon;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonFriendInfo:Reference
    {
        public string UserId =>FriendInfo.UserId;

        public bool IsOnline =>FriendInfo.IsOnline;
        public string Room =>FriendInfo.Room;

        public bool IsInRoom => FriendInfo.IsInRoom;
        

        public override string ToString() => FriendInfo.ToString();

        protected internal FriendInfo FriendInfo{get;protected private set;}
        protected internal PhotonFriendInfo(FriendInfo friendInfo)
        {
            this.FriendInfo = friendInfo;
        }
    }
}