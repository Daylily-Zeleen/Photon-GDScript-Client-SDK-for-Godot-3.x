using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonEnterRoomParams:Reference
    {
        public string RoomName{get=>EnterRoomParams.RoomName;set=>EnterRoomParams.RoomName=value;}
        public PhotonRoomOptions PhotonRoomOptions
        {
            set
            {
                photonRoomOptions = value;
                EnterRoomParams.RoomOptions=value.RoomOptions;
            }
            get => photonRoomOptions;

        }
        private PhotonRoomOptions photonRoomOptions;

        public PhotonTypedLobby Lobby
        {
            set
            { 
                lobby = value;
                EnterRoomParams.Lobby=value.TypedLobby;
            }
            get
            {
                return lobby;
            }
        }
        private PhotonTypedLobby lobby;

        public Dictionary PlayerProperties{get;set;} = new Dictionary();
        public string[] ExpectedUsers{get=>EnterRoomParams.ExpectedUsers; set=>EnterRoomParams.ExpectedUsers = value;}
        
        internal EnterRoomParams EnterRoomParams
        {
            get
            {
                // 获取前赋值不同步的引用类
                if (this.PlayerProperties == null || this.PlayerProperties.Count == 0 ) enterRoomParams.PlayerProperties = null;
                else enterRoomParams.PlayerProperties = new Hashtable(this.PlayerProperties);

                return enterRoomParams;
            }
        }
        private EnterRoomParams enterRoomParams = new EnterRoomParams();

        public PhotonEnterRoomParams(){}
    }
}