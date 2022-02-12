using Godot;
using Photon.Chat;
using ExitGames.Client.Photon;
using Godot.Collections;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonChatAppSettings:Reference
    {
        
        /// <summary>AppId for the Chat Api.</summary>
        public string AppIdChat { get=>ChatAppSettings.AppIdChat; set=>ChatAppSettings.AppIdChat=value;}

        /// <summary>The AppVersion can be used to identify builds and will split the AppId distinct "Virtual AppIds" (important for the users to find each other).</summary>
        public string AppVersion{ get=>ChatAppSettings.AppVersion; set=>ChatAppSettings.AppVersion=value;}

        /// <summary>Can be set to any of the Photon Cloud's region names to directly connect to that region.</summary>
        public string FixedRegion { get=>ChatAppSettings.FixedRegion; set=>ChatAppSettings.FixedRegion=value;}

        /// <summary>The address (hostname or IP) of the server to connect to.</summary>
        public string Server { get=>ChatAppSettings.Server; set=>ChatAppSettings.Server=value;}

        /// <summary>If not null, this sets the port of the first Photon server to connect to (that will "forward" the client as needed).</summary>
        public ushort Port { get=>ChatAppSettings.Port; set=>ChatAppSettings.Port=value;}

        /// <summary>The network level protocol to use.</summary>
        public ConnectionProtocol Protocol { get=>ChatAppSettings.Protocol; set=>ChatAppSettings.Protocol=value;}

        /// <summary>Enables a fallback to another protocol in case a connect to the Name Server fails.</summary>
        /// <remarks>See: LoadBalancingClient.EnableProtocolFallback.</remarks>
        public bool EnableProtocolFallback { get=>ChatAppSettings.EnableProtocolFallback; set=>ChatAppSettings.EnableProtocolFallback=value;}

        /// <summary>Log level for the network lib.</summary>
        public DebugLevel NetworkLogging { get=>ChatAppSettings.NetworkLogging; set=>ChatAppSettings.NetworkLogging=value;}

        /// <summary>If true, the default nameserver address for the Photon Cloud should be used.</summary>
        public bool IsDefaultNameServer =>ChatAppSettings.IsDefaultNameServer;


        internal ChatAppSettings ChatAppSettings {get; private set;} = new ChatAppSettings();
        public PhotonChatAppSettings(){}
    }
}