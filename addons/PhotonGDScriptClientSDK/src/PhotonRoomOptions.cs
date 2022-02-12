using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;

namespace PhotonGodotWraps.Wraps
{
    public class PhotonRoomOptions: Reference
    {
        public bool IsVisible{get=>RoomOptions.IsVisible;set=>RoomOptions.IsVisible=value;}
        public bool IsOpen{get=>RoomOptions.IsOpen;set=>RoomOptions.IsOpen=value;}
        public byte MaxPlayers{get=>RoomOptions.MaxPlayers;set=>RoomOptions.MaxPlayers=value;}
        public int PlayerTtl{get=>RoomOptions.PlayerTtl;set=>RoomOptions.PlayerTtl=value;}
        public int EmptyRoomTtl{get=>RoomOptions.EmptyRoomTtl;set=>RoomOptions.EmptyRoomTtl=value;}
        public bool CleanupCacheOnLeave{get=>RoomOptions.CleanupCacheOnLeave;set=>RoomOptions.CleanupCacheOnLeave=value;}
        public Dictionary CustomRoomProperties{get;set;} = new Dictionary();
        public string[] CustomRoomPropertiesForLobby{get=>RoomOptions.CustomRoomPropertiesForLobby;set=>RoomOptions.CustomRoomPropertiesForLobby=value;}
        public string[] Plugins{get=>RoomOptions.Plugins;set=>RoomOptions.Plugins=value;}
        public bool SuppressRoomEvents{get=>RoomOptions.SuppressRoomEvents;set=>RoomOptions.SuppressRoomEvents=value;}
        public bool SuppressPlayerInfo{get=>RoomOptions.SuppressPlayerInfo;set=>RoomOptions.SuppressPlayerInfo=value;}
        public bool PublishUserId{get=>RoomOptions.PublishUserId;set=>RoomOptions.PublishUserId=value;}
        public bool DeleteNullProperties{get=>RoomOptions.DeleteNullProperties;set=>RoomOptions.DeleteNullProperties=value;}
        public bool BroadcastPropsChangeToAll{get=>RoomOptions.BroadcastPropsChangeToAll;set=>RoomOptions.BroadcastPropsChangeToAll=value;}
        #if SERVERSDK
        public bool CheckUserOnJoin{get=>RoomOptions.CheckUserOnJoin;set=>RoomOptions.CheckUserOnJoin=value;}
        #endif
        
        internal RoomOptions RoomOptions
        {
            get
            {
                // 获取前赋值不同步的引用类
                if (CustomRoomProperties==null || CustomRoomProperties.Count ==0 ) roomOptions.CustomRoomProperties = null;
                else roomOptions.CustomRoomProperties = new Hashtable(CustomRoomProperties);
                return roomOptions;
            }
        }
        private RoomOptions roomOptions = new RoomOptions();

        public PhotonRoomOptions(){}
    }





}