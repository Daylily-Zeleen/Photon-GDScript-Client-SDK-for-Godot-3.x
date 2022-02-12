using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
using ExitGames.Client.Photon;

namespace PhotonGodotWraps.Wraps
{
    public class PhotonSendOptions:Reference
    {
        
        //
        // 摘要:
        //     Default SendOptions instance for reliable sending.
        // public static readonly PhotonSendOptions SendReliable = new PhotonSendOptions(SendOptions.SendReliable);
        // //
        // // 摘要:
        // //     Default SendOptions instance for unreliable sending.
        // public static readonly PhotonSendOptions SendUnreliable = new PhotonSendOptions(SendOptions.SendUnreliable);
        //
        // 摘要:
        //     Chose the DeliveryMode for this operation/message. Defaults to Unreliable.
        public DeliveryMode DeliveryMode{get=>sendOptions.DeliveryMode;set=>sendOptions.DeliveryMode=value;}
        //
        // 摘要:
        //     If true the operation/message gets encrypted before it's sent. Defaults to false.
        //
        // 言论：
        //     Before encryption can be used, it must be established. Check PhotonPeer.IsEncryptionAvailable
        //     is true.
        public bool Encrypt {get=>sendOptions.Encrypt;set=>sendOptions.Encrypt=value;}
        //
        // 摘要:
        //     The Enet channel to send in. Defaults to 0.
        //
        // 言论：
        //     Channels in Photon relate to "message channels". Each channel is a sequence of
        //     messages.
        public byte Channel{get=>sendOptions.Channel;set=>sendOptions.Channel=value;}

        //
        // 摘要:
        //     Sets the DeliveryMode either to true: Reliable or false: Unreliable, overriding
        //     any current value.
        //
        // 言论：
        //     Use this to conveniently select reliable/unreliable delivery.
        public bool Reliability{get=>sendOptions.Reliability;set=>sendOptions.Reliability=value;}
        internal SendOptions SendOptions{get=>sendOptions;private set{sendOptions=value;}}


        private SendOptions sendOptions;
        public PhotonSendOptions()
        {
            this.sendOptions = new SendOptions();
        }

        internal PhotonSendOptions(SendOptions sendOptions)
        {
            this.sendOptions = sendOptions;
        }

        public static PhotonSendOptions GetSendReliable() 
        {
            return new PhotonSendOptions(SendOptions.SendReliable);
        }
        public static PhotonSendOptions GetSendUnreliable()
        {
            return new PhotonSendOptions(SendOptions.SendUnreliable);;
        }
    }
}