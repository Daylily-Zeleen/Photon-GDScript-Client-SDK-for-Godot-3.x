using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonRegionHandler:Reference
    {
        public static System.Type PingImplementation{get=>RegionHandler.PingImplementation; set=>RegionHandler.PingImplementation=value;}

        /// <summary>A list of region names for the Photon Cloud. Set by the result of OpGetRegions().</summary>
        /// <remarks>
        /// Implement ILoadBalancingCallbacks and register for the callbacks to get OnRegionListReceived(RegionHandler regionHandler).
        /// You can also put a "case OperationCode.GetRegions:" into your OnOperationResponse method to notice when the result is available.
        /// </remarks>
        public readonly Array<Reference> EnabledRegions = new Array<Reference>(); 

        /// <summary>
        /// When PingMinimumOfRegions was called and completed, the BestRegion is identified by best ping.
        /// </summary>
        public Reference BestRegion {get;private set;}
        /// <summary>
        /// This value summarizes the results of pinging currently available regions (after PingMinimumOfRegions finished).
        /// </summary>
        /// <remarks>
        /// This value should be stored in the client by the game logic.
        /// When connecting again, use it as previous summary to speed up pinging regions and to make the best region sticky for the client.
        /// </remarks>
        public string SummaryToCache => RegionHandler.SummaryToCache;

        public string GetResults()
        {
            return RegionHandler.GetResults();
        }

        // public void SetRegions(OperationResponse opGetRegions)
        // {
        //     RegionHandler.SetRegions(opGetRegions);
        // }
        public bool IsPinging=>RegionHandler.IsPinging;


        public PhotonRegionHandler(ushort masterServerPortOverride = 0)
        {
            this.RegionHandler = new RegionHandler(masterServerPortOverride);
        }


        // public bool PingMinimumOfRegions(System.Action<PhotonRegionHandler> onCompleteCallback, string previousSummary)
        // {
        //     return this.RegionHandler.PingMinimumOfRegions(onCompleteCallback, previousSummary);
        // }

        private static GDScript GDSRegionClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/Region.gd");
        private static GDScript GDSRegionHandlerClass = GD.Load<GDScript>("res://addons/PhotonGDScriptClientSDK/warps/RegionHandler.gd");
        private readonly WeakRef regionHandlerRef ;
        internal Reference GDSRegionHandler {get=>regionHandlerRef.GetRef() as Reference;}
        internal RegionHandler RegionHandler{get;private set;}
        public PhotonRegionHandler(){
           regionHandlerRef = WeakRef(GDSRegionHandlerClass.New(this) as Reference);
        }
        internal PhotonRegionHandler(RegionHandler regionHandler):this()
        {
            init(regionHandler);
        }
        internal void init(RegionHandler regionHandler)
        {
            this.RegionHandler = regionHandler; 

            var _best = RegionHandler.BestRegion; // 触发排序

            this.EnabledRegions.Clear();
            foreach (var region in this.RegionHandler.EnabledRegions)
            {
                this.EnabledRegions.Add(
                        GDSRegionClass.New(  (region.Code == null)? "" : region.Code ,
                                        (region.Cluster == null)? "" : region.Cluster , 
                                        (region.HostAndPort == null)? "" : region.HostAndPort , 
                                        region.Ping , 
                                        region.WasPinged 
                                        ) as Reference);
            }

            BestRegion = (this.EnabledRegions.Count>0)? this.EnabledRegions[0] : null;
        }
    }
}