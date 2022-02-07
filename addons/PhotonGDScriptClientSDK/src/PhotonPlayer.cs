using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonPlayer:Reference
    {
        private static GDScript GDSPlayerClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/PhotonPlayer.gd"); 
        public int ActorNumber=>Player.ActorNumber;
        public bool IsLocal =>Player.IsLocal;
        public bool HasRejoined=>Player.HasRejoined;
        public string NickName=>Player.NickName;
        public string UserId=>Player.UserId;
        public bool IsMasterClient=>Player.IsMasterClient;
        public bool IsInactive=>Player.IsInactive;
        public Dictionary CustomProperties=>customProperties;
        private Dictionary customProperties = new Dictionary();
        public object TagObject{get=>Player.TagObject;set=>Player.TagObject=value;}

        public Reference GDSplayer 
        {
            get{
                return GDSPlayerRef.GetRef() as Reference ;
            }
        }
        private readonly WeakRef GDSPlayerRef;
        #region 方法
        public Reference GetNextGDSPlalyer() 
        {
            return GetNextGDSPlalyerFor(this.ActorNumber);
        }
        public Reference GetGDSPlayer(int actorNumber)
        {
            if (RoomReference == null )return null;
            else return RoomReference.GetGDSPlayer(actorNumber);
        }
        public Reference GetNextGDSPlalyerFor(int currentPlayerActorNumber)
        {
            if (this.RoomReference == null || this.RoomReference.Players == null || this.RoomReference.Players.Count < 2)
            {
                return null;
            }

            Dictionary<int, Reference> players = this.RoomReference.Players;
            int nextHigherId = int.MaxValue;    // we look for the next higher ID
            int lowestId = currentPlayerActorNumber;     // if we are the player with the highest ID, there is no higher and we return to the lowest player's id

            foreach (int playerid in players.Keys)
            {
                if (playerid < lowestId)
                {
                    lowestId = playerid;        // less than any other ID (which must be at least less than this player's id).
                }
                else if (playerid > currentPlayerActorNumber && playerid < nextHigherId)
                {
                    nextHigherId = playerid;    // more than our ID and less than those found so far.
                }
            }

            return (nextHigherId != int.MaxValue) ? players[nextHigherId] : players[lowestId];
        }
        public Reference GetNextGDSPlalyerForPlayer(Reference currentGDSPlayer)
        {
            return GetNextGDSPlalyerFor((int)currentGDSPlayer.Get("actor_number"));
        }
        /// <summary>Gets this Player's next Player, as sorted by ActorNumber (Player.ID). Wraps around.</summary>
        /// <returns>Player or null.</returns>
        // public PhotonPlayer GetNext()
        // {   
        //     return GetNextFor(this.ActorNumber);
        // }
        // public PhotonPlayer GetPhotonPlayer(int actorNumber)
        // {
        //     if (this.RoomReference == null)
        //     {
        //         return null;
        //     }

        //     return this.RoomReference.GetPlayer(actorNumber);
        // }
        // public PhotonPlayer GetNextFor(int currentPlayerActorNumber)
        // {
        //     if (this.RoomReference == null || this.RoomReference.Players == null || this.RoomReference.Players.Count < 2)
        //     {
        //         return null;
        //     }

        //     Dictionary<int, Reference> players = this.RoomReference.Players;
        //     int nextHigherId = int.MaxValue;    // we look for the next higher ID
        //     int lowestId = currentPlayerActorNumber;     // if we are the player with the highest ID, there is no higher and we return to the lowest player's id

        //     foreach (int playerid in players.Keys)
        //     {
        //         if (playerid < lowestId)
        //         {
        //             lowestId = playerid;        // less than any other ID (which must be at least less than this player's id).
        //         }
        //         else if (playerid > currentPlayerActorNumber && playerid < nextHigherId)
        //         {
        //             nextHigherId = playerid;    // more than our ID and less than those found so far.
        //         }
        //     }

        //     //UnityEngine.Debug.LogWarning("Debug. " + currentPlayerId + " lower: " + lowestId + " higher: " + nextHigherId + " ");
        //     //UnityEngine.Debug.LogWarning(this.RoomReference.GetPlayer(currentPlayerId));
        //     //UnityEngine.Debug.LogWarning(this.RoomReference.GetPlayer(lowestId));
        //     //if (nextHigherId != int.MaxValue) UnityEngine.Debug.LogWarning(this.RoomReference.GetPlayer(nextHigherId));
        //     return (nextHigherId != int.MaxValue) ? players[nextHigherId] : players[lowestId];
        // }
        // public PhotonPlayer GetNextForPhotonPlayer(PhotonPlayer currentPlayer)
        // {
        //     if (currentPlayer == null)
        //     {
        //         return null;
        //     }
        //     return GetNextFor(currentPlayer.ActorNumber);
        // }
        public bool SetCustomProperties(Dictionary propertiesToSet,
                                        Dictionary expectedValues = null,
                                        PhotonWebFlags webFlags = null)
        {
            var result = this.Player.SetCustomProperties(new Hashtable(propertiesToSet),
                                                   (expectedValues == null) ? null : new Hashtable(expectedValues),
                                                   (webFlags == null) ? null : webFlags.WebFlags);
            if (result)
            {
                MergeCustomProperties();
            }
            return result;
        }

        protected internal void ChangeLocalID(int newID) => Player.ChangeLocalID(newID);
        
        #endregion

        /// <summary>
        /// Used internally to identify the masterclient of a room.
        /// </summary>
        protected internal PhotonRoom RoomReference { get; set; }
        protected internal Player Player{get;internal set;}
        /// <summary>
        /// GDS 包装接口，不应该自行实例化该类
        /// </summary>
        public PhotonPlayer(){
            GDSPlayerRef = WeakRef( GDSPlayerClass.New(this) as Reference); // 弱引用
        }
        
        internal PhotonPlayer(Player player):this()
        {
            Player = player;
            
        }

        protected internal void MergeCustomProperties(IDictionary toMergeProperties = null)
        {
            customProperties.MergeStringKeys((toMergeProperties == null)? this.Player.CustomProperties : toMergeProperties);
            customProperties.StripKeysWithNullValues();
        }
        #region 次要
        public override string ToString()
        {
            return this.Player.ToString();
        }
        public string ToStringFull()
        {
            return this.Player.ToStringFull();
        }
        public override bool Equals(object p)
        {
            PhotonPlayer pp = p as PhotonPlayer;
            return this.Player.Equals(pp.Player);
        }
        public override int GetHashCode()
        {
            return this.Player.GetHashCode();
        }

            
        #endregion
    }
}