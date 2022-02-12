using Godot;
using Photon.Realtime;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonTypedLobby:Reference
    {
        public string Name{get=>TypedLobby.Name;set=>TypedLobby.Name=value;}
        public LobbyType Type{get=>TypedLobby.Type;set=>TypedLobby.Type=value;}
        public static readonly PhotonTypedLobby Default = new PhotonTypedLobby();
        /// <summary>
        /// Returns whether or not this instance points to the "default lobby" (<see cref="TypedLobby.Default"/>).
        /// </summary>
        /// <remarks>
        /// This comes up to checking if the Name is null or empty.
        /// <see cref="LobbyType.Default"/> is not the same thing as the "default lobby" (<see cref="TypedLobby.Default"/>).
        /// </remarks>
        public bool IsDefault => string.IsNullOrEmpty(this.Name);
        internal TypedLobby TypedLobby {get;private set;} 

        /// <summary>
        /// gds 包装用，还需调用init
        /// </summary>
        public PhotonTypedLobby(){ TypedLobby = TypedLobby.Default;}
        public void init(string name, LobbyType lobbyType)
        {
            this.Name = name;
            this.Type = lobbyType;
        }


        internal PhotonTypedLobby(TypedLobby typedLobby)
        {
            TypedLobby = typedLobby;
        }

        public static PhotonTypedLobby GetDefault()=>PhotonTypedLobby.Default;
    }
}