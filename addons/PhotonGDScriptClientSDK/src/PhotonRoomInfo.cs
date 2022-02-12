// using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonRoomInfo:Godot.Reference
    {

        /// <summary>Used in lobby, to mark rooms that are no longer listed (for being full, closed or hidden).</summary>
        public bool RemovedFromList{get=>RoomInfo.RemovedFromList;set=>RoomInfo.RemovedFromList = value;}

        /// <summary>Read-only "cache" of custom properties of a room. Set via Room.SetCustomProperties (not available for RoomInfo class!).</summary>
        /// <remarks>All keys are string-typed and the values depend on the game/application.</remarks>
        /// <see cref="Room.SetCustomProperties"/>
        public Dictionary CustomProperties //<string,object>
        {
            get ;
            private set;
        }

        /// <summary>The name of a room. Unique identifier for a room/match (per AppId + game-Version).</summary>
        public string Name =>RoomInfo.Name;

        /// <summary>
        /// Count of players currently in room. This property is overwritten by the Room class (used when you're in a Room).
        /// </summary>
        public int PlayerCount=>RoomInfo.PlayerCount;
        
        /// <summary>
        /// The limit of players for this room. This property is shown in lobby, too.
        /// If the room is full (players count == maxplayers), joining this room will fail.
        /// </summary>
        /// <remarks>
        /// As part of RoomInfo this can't be set.
        /// As part of a Room (which the player joined), the setter will update the server and all clients.
        /// </remarks>
        public byte MaxPlayers =>RoomInfo.MaxPlayers;

        /// <summary>
        /// Defines if the room can be joined.
        /// This does not affect listing in a lobby but joining the room will fail if not open.
        /// If not open, the room is excluded from random matchmaking.
        /// Due to racing conditions, found matches might become closed even while you join them.
        /// Simply re-connect to master and find another.
        /// Use property "IsVisible" to not list the room.
        /// </summary>
        /// <remarks>
        /// As part of RoomInfo this can't be set.
        /// As part of a Room (which the player joined), the setter will update the server and all clients.
        /// </remarks>
        public bool IsOpen => RoomInfo.IsOpen;

        /// <summary>
        /// Defines if the room is listed in its lobby.
        /// Rooms can be created invisible, or changed to invisible.
        /// To change if a room can be joined, use property: open.
        /// </summary>
        /// <remarks>
        /// As part of RoomInfo this can't be set.
        /// As part of a Room (which the player joined), the setter will update the server and all clients.
        /// </remarks>
        public bool IsVisible => RoomInfo.IsVisible;

        /// <summary>
        /// Makes RoomInfo comparable (by name).
        /// </summary>
        public override bool Equals(object other)
        {
            PhotonRoomInfo otherRoomInfo = other as PhotonRoomInfo;
            return this.RoomInfo.Equals(otherRoomInfo.RoomInfo);
        }

        /// <summary>
        /// Accompanies Equals, using the name's HashCode as return.
        /// </summary>
        /// <returns></returns>
        public override int GetHashCode() => this.RoomInfo.GetHashCode();


        /// <summary>Returns most interesting room values as string.</summary>
        /// <returns>Summary of this RoomInfo instance.</returns>
        public override string ToString() => this.RoomInfo.ToString();

        /// <summary>Returns most interesting room values as string, including custom properties.</summary>
        /// <returns>Summary of this RoomInfo instance.</returns>
        public string ToStringFull() => this.RoomInfo.ToStringFull();

    


        internal RoomInfo RoomInfo{get;private set;}

        protected internal PhotonRoomInfo(RoomInfo roomInfo)
        {
            this.RoomInfo = roomInfo; 
            
            CustomProperties = new Dictionary( roomInfo.CustomProperties);
        }

    }
}