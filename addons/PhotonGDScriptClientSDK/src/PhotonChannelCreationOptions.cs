using Godot;
using Photon.Chat;
using ExitGames.Client.Photon;
namespace PhotonGodotWarps.Warps
{
    public class PhotonChannelCreationOptions:Reference
    {
        /// <summary>Default values of channel creation options.</summary>
        public static PhotonChannelCreationOptions Default = new PhotonChannelCreationOptions(ChannelCreationOptions.Default);
        /// <summary>Whether or not the channel to be created will allow client to keep a list of users.</summary>
        public bool PublishSubscribers { get=>options.PublishSubscribers; set=>options.PublishSubscribers=value; }
        /// <summary>Limit of the number of users subscribed to the channel to be created.</summary>
        public int MaxSubscribers { get=>options.MaxSubscribers; set=>options.MaxSubscribers = value; }

        #if CHAT_EXTENDED
        public Godot.Collections.Dictionary<string, object> CustomProperties { get; set; }
        #endif
        internal ChannelCreationOptions Options
        {
            get
            {
                #if CHAT_EXTENDED
                options.CustomProperties = new System.Collections.Generic.Dictionary<string, object>(CustomProperties);
                #endif
                return options;
            }
        } 
        private readonly ChannelCreationOptions options ;
        public PhotonChannelCreationOptions()
        {
            options = new ChannelCreationOptions();
        }
        internal PhotonChannelCreationOptions(ChannelCreationOptions options)
        {
            this.options = options;
        }
        public static PhotonChannelCreationOptions GetDefaultOptions()=>PhotonChannelCreationOptions.Default;
        
    }
}