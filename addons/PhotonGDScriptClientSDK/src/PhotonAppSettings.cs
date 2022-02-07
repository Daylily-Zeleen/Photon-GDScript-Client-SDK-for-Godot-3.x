using Godot;
using Photon.Realtime;
using ExitGames.Client.Photon;
namespace PhotonGodotWarps.Warps
{
    public class PhotonAppSettings:Reference
    {
        /// <summary>AppId for Realtime or PUN.</summary>
        public string AppIdRealtime{get=>AppSettings.AppIdRealtime;set=>AppSettings.AppIdRealtime=value;}

        /// <summary>AppId for Photon Fusion.</summary>
        public string AppIdFusion{get=>AppSettings.AppIdFusion;set=>AppSettings.AppIdFusion=value;}

        /// <summary>AppId for Photon Chat.</summary>
        public string AppIdChat{get=>AppSettings.AppIdChat;set=>AppSettings.AppIdChat=value;}

        /// <summary>AppId for Photon Voice.</summary>
        public string AppIdVoice{get=>AppSettings.AppIdVoice;set=>AppSettings.AppIdVoice=value;}

        /// <summary>The AppVersion can be used to identify builds and will split the AppId distinct "Virtual AppIds" (important for matchmaking).</summary>
        public string AppVersion{get=>AppSettings.AppVersion;set=>AppSettings.AppVersion=value;}


        /// <summary>If false, the app will attempt to connect to a Master Server (which is obsolete but sometimes still necessary).</summary>
        /// <remarks>if true, Server points to a NameServer (or is null, using the default), else it points to a MasterServer.</remarks>
        public bool UseNameServer {get=>AppSettings.UseNameServer;set=>AppSettings.UseNameServer=value;}

        /// <summary>Can be set to any of the Photon Cloud's region names to directly connect to that region.</summary>
        /// <remarks>if this IsNullOrEmpty() AND UseNameServer == true, use BestRegion. else, use a server</remarks>
        public string FixedRegion {get=>AppSettings.FixedRegion;set=>AppSettings.FixedRegion=value;}

        /// <summary>Set to a previous BestRegionSummary value before connecting.</summary>
        /// <remarks>
        /// This is a value used when the client connects to the "Best Region".</br>
        /// If this is null or empty, all regions gets pinged. Providing a previous summary on connect,
        /// speeds up best region selection and makes the previously selected region "sticky".</br>
        ///
        /// Unity clients should store the BestRegionSummary in the PlayerPrefs.
        /// You can store the new result by implementing <see cref="IConnectionCallbacks.OnConnectedToMaster"/>.
        /// If <see cref="LoadBalancingClient.SummaryToCache"/> is not null, store this string.
        /// To avoid storing the value multiple times, you could set SummaryToCache to null.
        /// </remarks>
        public string BestRegionSummaryFromStorage{get=>AppSettings.BestRegionSummaryFromStorage;set=>AppSettings.BestRegionSummaryFromStorage=value;}

        /// <summary>The address (hostname or IP) of the server to connect to.</summary>
        public string Server{get=>AppSettings.Server;set=>AppSettings.Server=value;}

        /// <summary>If not null, this sets the port of the first Photon server to connect to (that will "forward" the client as needed).</summary>
        public int Port{get=>AppSettings.Port;set=>AppSettings.Port=value;}

        /// <summary>The address (hostname or IP and port) of the proxy server.</summary>
        public string ProxyServer{get=>AppSettings.ProxyServer;set=>AppSettings.ProxyServer=value;}

        /// <summary>The network level protocol to use.</summary>
        public ConnectionProtocol Protocol {get=>AppSettings.Protocol;set=>AppSettings.Protocol=value;}

        /// <summary>Enables a fallback to another protocol in case a connect to the Name Server fails.</summary>
        /// <remarks>See: LoadBalancingClient.EnableProtocolFallback.</remarks>
        public bool EnableProtocolFallback {get=>AppSettings.EnableProtocolFallback;set=>AppSettings.EnableProtocolFallback=value;}

        /// <summary>Defines how authentication is done. On each system, once or once via a WSS connection (safe).</summary>
        public AuthModeOption AuthMode {get=>AppSettings.AuthMode;set=>AppSettings.AuthMode=value;}

        /// <summary>If true, the client will request the list of currently available lobbies.</summary>
        public bool EnableLobbyStatistics{get=>AppSettings.EnableLobbyStatistics;set=>AppSettings.EnableLobbyStatistics=value;}

        /// <summary>Log level for the network lib.</summary>
        public DebugLevel NetworkLogging {get=>AppSettings.NetworkLogging;set=>AppSettings.NetworkLogging=value;}

        /// <summary>If true, the Server field contains a Master Server address (if any address at all).</summary>
        public bool IsMasterServerAddress=>AppSettings.IsMasterServerAddress;

        /// <summary>If true, the client should fetch the region list from the Name Server and find the one with best ping.</summary>
        /// <remarks>See "Best Region" in the online docs.</remarks>
        public bool IsBestRegion=>AppSettings.IsBestRegion;

        /// <summary>If true, the default nameserver address for the Photon Cloud should be used.</summary>
        public bool IsDefaultNameServer=>AppSettings.IsDefaultNameServer;

        /// <summary>If true, the default ports for a protocol will be used.</summary>
        public bool IsDefaultPort=>AppSettings.IsDefaultPort;

        /// <summary>ToString but with more details.</summary>
        public string ToStringFull()=>AppSettings.ToStringFull();


        /// <summary>Checks if a string is a Guid by attempting to create one.</summary>
        /// <param name="val">The potential guid to check.</param>
        /// <returns>True if new Guid(val) did not fail.</returns>
        public static bool IsAppId(string val)=>AppSettings.IsAppId(val);

        public PhotonAppSettings CopyTo(PhotonAppSettings d)
        {
            this.AppSettings.CopyTo(d.AppSettings);
            return d;
        }
        internal AppSettings AppSettings{get;private set;} = new AppSettings();


        public PhotonAppSettings(){}
    }
}