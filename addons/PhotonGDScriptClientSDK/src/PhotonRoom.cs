// using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonRoom:Godot.Reference
    {
        public string Name => Room.Name;
        public bool IsOffline => Room.IsOffline;
        public bool IsOpen {get=> Room.IsOpen; set=> Room.IsOpen=value;}
        public bool IsVisible {get=> Room.IsVisible; set=> Room.IsVisible=value;}
        public byte MaxPlayers {get=> Room.MaxPlayers; set=> Room.MaxPlayers=value;}
        public byte PlayerCount => Room.PlayerCount;
        // public Dictionary<int, PhotonPlayer> Players {get;protected internal set;} = new Dictionary<int, PhotonPlayer>();
        public Dictionary<int, Godot.Reference> Players {get;protected internal set;} = new Dictionary<int, Godot.Reference>();
        public string[] ExpectedUsers=>Room.ExpectedUsers;
        public int PlayerTtl{get=>Room.PlayerTtl;set=>Room.PlayerTtl=value;}
        public int EmptyRoomTtl{get=>Room.EmptyRoomTtl;set=>Room.EmptyRoomTtl=value;}
        public int MasterClientId=>Room.MasterClientId;
        public string[] PropertiesListedInLobby=>Room.PropertiesListedInLobby;
        public bool AutoCleanUp=>Room.AutoCleanUp;
        public bool BroadcastPropertiesChangeToAll=>Room.BroadcastPropertiesChangeToAll;
        public bool SuppressRoomEvents=>Room.SuppressRoomEvents;
        public bool SuppressPlayerInfo=>Room.SuppressPlayerInfo;
        public bool PublishUserId=>Room.PublishUserId;
        public bool DeleteNullProperties=>Room.DeleteNullProperties;
        


        #if SERVERSDK
        /// <summary>Define if rooms should have unique UserId per actor and that UserIds are used instead of actor number in rejoin.</summary>
        public bool CheckUserOnJoin =>Room.CheckUserOnJoin;
        #endif

        // 基类
        
        /// <summary>Used in lobby, to mark rooms that are no longer listed (for being full, closed or hidden).</summary>
        public bool RemovedFromList{get=>Room.RemovedFromList;set=>Room.RemovedFromList = value;}

        /// <summary>Read-only "cache" of custom properties of a room. Set via Room.SetCustomProperties (not available for RoomInfo class!).</summary>
        /// <remarks>All keys are string-typed and the values depend on the game/application.</remarks>
        /// <see cref="Room.SetCustomProperties"/>
        public readonly Godot.Collections.Dictionary CustomProperties = new Godot.Collections.Dictionary();

        /// <summary>
        /// Makes RoomInfo comparable (by name).
        /// </summary>
        public override bool Equals(object other)
        {
            PhotonRoom otherRoom = other as PhotonRoom;
            return this.Room.Equals(otherRoom.Room);
        }

        /// <summary>
        /// Accompanies Equals, using the name's HashCode as return.
        /// </summary>
        /// <returns></returns>
        public override int GetHashCode() => this.Room.GetHashCode();

        private static Godot.GDScript GDSRoomClass = Godot.GD.Load<Godot.GDScript>("res://addons/PhotonGDScriptClientSDK/wraps/PhotonRoom.gd");
        public Godot.Reference GDSRoom => GDSRoomRef.GetRef() as Godot.Reference;
        private readonly Godot.WeakRef GDSRoomRef;


        #region 方法
        public virtual bool SetCustomProperties(Dictionary propertiesToSet,
                                                Dictionary expectedProperties = null,
                                                PhotonWebFlags webFlags = null)   
        {
            var result = this.Room.SetCustomProperties(new Hashtable(propertiesToSet),
                                                 new Hashtable(expectedProperties),
                                                 webFlags.WebFlags);
            if (result) MergeCustomProperties();
            return result;
        }
        public bool SetPropertiesListedInLobby(string[] lobbyProps)
        {
            return this.Room.SetPropertiesListedInLobby(lobbyProps);
        }
        public bool SetMasterClient(PhotonPlayer masterClientPlayer)
        {
            return this.Room.SetMasterClient(masterClientPlayer.Player);
        }

        protected internal virtual bool AddPlayer(PhotonPlayer player)
        {
            if (this.Room.AddPlayer(player.Player))
            {
                this.Players[player.ActorNumber] = player;
                return true;
            }
            return false;
        }
        protected internal virtual PhotonPlayer StorePlayer(PhotonPlayer player)
        {
            this.Players[player.ActorNumber] = player;
            this.Room.StorePlayer(player.Player);
            player.RoomReference = this;
            return player;
        }
        protected internal virtual void RemovePlayer(PhotonPlayer player)
        {
            this.Players.Remove(player.ActorNumber);
            this.Room.RemovePlayer(player.Player);
            player.RoomReference = null;
        }


        public virtual Godot.Reference GetGDSPlayer(int actorNumber, bool findMaster = false)
        {
            int idToFind = (findMaster && actorNumber == 0) ? this.MasterClientId : actorNumber;
            
            Godot.Reference result = null;
            this.Players.TryGetValue(idToFind, out result);
            return result;
        }
        // public virtual PhotonPlayer GetPlayer(int actorNumber, bool findMaster = false)
        // {
        //     Player player = this.Room.GetPlayer(actorNumber, findMaster);
        //     PhotonPlayer toReturn = null;
        //     if (toReturn != null) Players.TryGetValue(player.ActorNumber, out toReturn);
        //     return toReturn;    
        // }

        public bool ClearExpectedUsers()
        {
            return this.Room.ClearExpectedUsers();
        }
        public bool SetExpectedUsers(string[] newExpectedUsers)
        {
            return this.Room.SetExpectedUsers(newExpectedUsers);
        }
        #endregion



        internal Room Room{get=>room;}
        private Room room;
        public PhotonRoom()
        {
            GDSRoomRef = WeakRef(GDSRoomClass.New(this) as Godot.Reference) ;
        }
        internal PhotonRoom(Room room, PhotonPlayer localPlayer):this()
        {   
            init( room, localPlayer);
        }
        internal void init(Room room, PhotonPlayer localPlayer)
        {
            this.room = room;
            Players.Clear();
            foreach (var kv in room.Players)
            {
                if (kv.Key == localPlayer.ActorNumber) Players[kv.Key] = localPlayer.GDSplayer;
                else Players[kv.Key] = new PhotonPlayer(kv.Value).GDSplayer;
            }
        }


        // public PhotonRoom(string roomName, RoomOptions options, bool isOffline = false)
        // {
        //     this.Room = new Room(roomName, options, isOffline);
        // }

        protected internal void MergeCustomProperties(IDictionary toMergeProperties = null)
        {
            CustomProperties.MergeStringKeys((toMergeProperties == null)? this.Room.CustomProperties : toMergeProperties);
            CustomProperties.StripKeysWithNullValues();
        }
        
        #region 次要
        public override string ToString()=> this.Room.ToString();
        public string ToStringFull()=> this.Room.ToStringFull();

            
        #endregion
    }
}