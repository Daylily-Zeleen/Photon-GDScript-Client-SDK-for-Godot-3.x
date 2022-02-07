using Godot;
using Photon.Realtime;
namespace PhotonGodotWarps.Warps
{
    public class PhotonTypedLobbyInfo:Reference
    {
        /// <summary>Count of players that currently joined this lobby.</summary>
        public int PlayerCount{get=>TypedLobbyInfo.PlayerCount;set=>TypedLobbyInfo.PlayerCount=value;}

        /// <summary>Count of rooms currently associated with this lobby.</summary>
        public int RoomCount{get=>TypedLobbyInfo.RoomCount;set=>TypedLobbyInfo.RoomCount=value;}

        public override string ToString() =>TypedLobbyInfo.ToString();

        
        internal TypedLobbyInfo TypedLobbyInfo{get;private set;}
        protected internal PhotonTypedLobbyInfo(TypedLobbyInfo typedLobbyInfo)
        {
            TypedLobbyInfo = typedLobbyInfo;
        }
    }
}