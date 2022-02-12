using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonOpJoinRandomRoomParams:Reference
    {
        /// <summary>The custom room properties a room must have to fit. All key-values must be present to match. In SQL Lobby, use SqlLobbyFilter instead.</summary>
        public Dictionary ExpectedCustomRoomProperties{set;get;}=new Dictionary();
        /// <summary>Filters by the MaxPlayers value of rooms.</summary>
        public byte ExpectedMaxPlayers{get=>OpJoinRandomRoomParams.ExpectedMaxPlayers;set=>OpJoinRandomRoomParams.ExpectedMaxPlayers=value;}
        /// <summary>The MatchmakingMode affects how rooms get filled. By default, the server fills rooms.</summary>
        public MatchmakingMode MatchingType{get=>OpJoinRandomRoomParams.MatchingType;set=>OpJoinRandomRoomParams.MatchingType=value;}
        /// <summary>The lobby in which to match. The type affects how filters are applied.</summary>
        public PhotonTypedLobby TypedLobby{set=>OpJoinRandomRoomParams.TypedLobby=value.TypedLobby;}
        /// <summary>SQL query to filter room matches. For default-typed lobbies, use ExpectedCustomRoomProperties instead.</summary>
        public string SqlLobbyFilter{get=>OpJoinRandomRoomParams.SqlLobbyFilter;set=>OpJoinRandomRoomParams.SqlLobbyFilter=value;}
        /// <summary>The expected users list blocks player slots for your friends or team mates to join the room, too.</summary>
        /// <remarks>See: https://doc.photonengine.com/en-us/pun/v2/lobby-and-matchmaking/matchmaking-and-lobby#matchmaking_slot_reservation </remarks>
        public string[] ExpectedUsers{get=>OpJoinRandomRoomParams.ExpectedUsers;set=>OpJoinRandomRoomParams.ExpectedUsers=value;}
        internal OpJoinRandomRoomParams OpJoinRandomRoomParams
        {
            get
            {
                // 获取前赋值不同步引用类
                if (ExpectedCustomRoomProperties==null || ExpectedCustomRoomProperties.Count == 0) opJoinRandomRoomParams.ExpectedCustomRoomProperties = null;
                else opJoinRandomRoomParams.ExpectedCustomRoomProperties = new Hashtable(ExpectedCustomRoomProperties);
                return opJoinRandomRoomParams;
            }
        } 
        private OpJoinRandomRoomParams opJoinRandomRoomParams = new OpJoinRandomRoomParams();
        public PhotonOpJoinRandomRoomParams(){}
    }
}