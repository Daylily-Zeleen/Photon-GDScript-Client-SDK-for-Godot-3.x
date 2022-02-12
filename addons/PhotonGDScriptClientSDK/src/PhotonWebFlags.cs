using Godot;
using Photon.Realtime;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonWebFlags:Reference
    {
        public readonly static PhotonWebFlags Default = new PhotonWebFlags(WebFlags.Default);
        public byte WebhookFlags {get=>WebFlags.WebhookFlags;set=>WebFlags.WebhookFlags=value;}
        public bool HttpForward {get=>WebFlags.HttpForward;set=>WebFlags.HttpForward=value;}
        public bool SendAuthCookie {get=>WebFlags.SendAuthCookie;set=>WebFlags.SendAuthCookie=value;}
        public bool SendSync {get=>WebFlags.SendSync;set=>WebFlags.SendSync=value;}
        public bool SendState {get=>WebFlags.SendState;set=>WebFlags.SendState=value;}
        internal readonly WebFlags WebFlags = new WebFlags(0);

        public PhotonWebFlags(){}
        
        public void init(byte webhookFlags)
        {
            WebhookFlags = webhookFlags;
        }

        public PhotonWebFlags(byte webhookFlags)
        {
            init(webhookFlags);
        }
        internal PhotonWebFlags(WebFlags webFlags)
        {
            this.WebFlags = webFlags;
        }
        public static PhotonWebFlags GetDefault()=> PhotonWebFlags.Default;
    }
}