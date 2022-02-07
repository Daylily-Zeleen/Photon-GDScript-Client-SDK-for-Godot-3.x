using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonRaiseEventOptions:Reference
    {
        public readonly static PhotonRaiseEventOptions Default = new PhotonRaiseEventOptions();

        /// <summary>Defines if the server should simply send the event, put it in the cache or remove events that are like this one.</summary>
        /// <remarks>
        /// When using option: SliceSetIndex, SlicePurgeIndex or SlicePurgeUpToIndex, set a CacheSliceIndex. All other options except SequenceChannel get ignored.
        /// </remarks>
        public EventCaching CachingOption{get=>RaiseEventOptions.CachingOption;set=>RaiseEventOptions.CachingOption=value;}

        /// <summary>The number of the Interest Group to send this to. 0 goes to all users but to get 1 and up, clients must subscribe to the group first.</summary>
        public byte InterestGroup{get=>RaiseEventOptions.InterestGroup;set=>RaiseEventOptions.InterestGroup=value;}

        /// <summary>A list of Player.ActorNumbers to send this event to. You can implement events that just go to specific users this way.</summary>
        public int[] TargetActors{get=>RaiseEventOptions.TargetActors;set=>RaiseEventOptions.TargetActors=value;}

        /// <summary>Sends the event to All, MasterClient or Others (default). Be careful with MasterClient, as the client might disconnect before it got the event and it gets lost.</summary>
        public ReceiverGroup Receivers{get=>RaiseEventOptions.Receivers;set=>RaiseEventOptions.Receivers=value;}

        /// <summary> Optional flags to be used in Photon client SDKs with Op RaiseEvent and Op SetProperties.</summary>
        /// <remarks>Introduced mainly for webhooks 1.2 to control behavior of forwarded HTTP requests.</remarks>
        public PhotonWebFlags Flags 
        {
            get => flags ;
            set
            {
                flags = value;
                RaiseEventOptions.Flags = flags.WebFlags;
            }
        }
        private PhotonWebFlags flags  = PhotonWebFlags.Default;


        internal RaiseEventOptions RaiseEventOptions{get;}=new RaiseEventOptions();

        public PhotonRaiseEventOptions(){}

        public static PhotonRaiseEventOptions GetDefault()=> PhotonRaiseEventOptions.Default;
    }
}