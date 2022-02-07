using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
using ExitGames.Client.Photon;
namespace PhotonGodotWarps.Warps
{
    /// <summary>
    /// 提取数据，不保留源类
    /// 接收，只读类
    /// </summary>
    public class PhotonEventData:Reference
    {
        internal static PhotonEventData UniqueRealtimeEventData = new PhotonEventData() ;
        internal static PhotonEventData UniqueChatEventData = new PhotonEventData() ;
        internal static bool ReuseRealtimeEventInstance {get;set;} = true;
        internal static bool ReuseChatEventInstance {get;set;} = true;
        internal static PhotonEventData GetPhotonRealtimeEventData(EventData eventData)
        {
            if (ReuseRealtimeEventInstance ) 
            {
                UniqueRealtimeEventData.EventData = eventData;
                return UniqueRealtimeEventData;
            }
            else return new PhotonEventData(eventData);
        }
        internal static PhotonEventData GetPhotonChatEventData(EventData eventData)
        {
            if (ReuseChatEventInstance ) 
            {
                UniqueChatEventData.EventData = eventData;
                return UniqueChatEventData;
            }
            else return new PhotonEventData(eventData);
        }


        // 摘要:
        //     The Parameters of an event is a Dictionary<byte, object>.
        public Dictionary<byte, object> Parameters
        {
            get
            {
                if (needUpdate)
                {
                    parameters.Clear();
                    foreach (var kv in this.eventData.Parameters)
                    {
                        parameters.Add(kv.Key, (kv.Value is IDictionary)?new Dictionary(kv.Value as IDictionary) : kv.Value);
                    }
                    needUpdate = false;
                }
                return parameters;
            }
        } 
        private Dictionary<byte, object> parameters = new Dictionary<byte, object>();
        //
        // 摘要:
        //     The event code identifies the type of event.
        public byte Code=>EventData.Code;//{get=>EventData.Code;set=>EventData.Code=value;}
        //
        // 摘要:
        //     Defines the event key containing the Sender of the event.
        //
        // 言论：
        //     Defaults to Sender key of Realtime API events (RaiseEvent): 254. Can be set to
        //     Chat API's ChatParameterCode.Sender: 5.
        public byte SenderKey=>EventData.SenderKey;
        //
        // 摘要:
        //     Defines the event key containing the Custom Data of the event.
        //
        // 言论：
        //     Defaults to Data key of Realtime API events (RaiseEvent): 245. Can be set to
        //     any other value on demand.
        public byte CustomDataKey=>EventData.CustomDataKey;


        //
        // 摘要:
        //     Access to the Parameters of a Photon-defined event. Custom Events only use Code,
        //     Sender and CustomData.
        //
        // 参数:
        //   key:
        //     The key byte-code of a Photon event value.
        //
        // 返回结果:
        //     The Parameters value, or null if the key does not exist in Parameters.
        public object this[byte key] { get=>Parameters[key]; }

        //
        // 摘要:
        //     Accesses the Sender of the event via the indexer and SenderKey. The result is
        //     cached.
        //
        // 言论：
        //     Accesses this event's Parameters[CustomDataKey], which may be null. In that case,
        //     this returns 0 (identifying the server as sender).
        public int Sender =>EventData.Sender;
        //
        // 摘要:
        //     Accesses the Custom Data of the event via the indexer and CustomDataKey. The
        //     result is cached.
        //
        // 言论：
        //     Accesses this event's Parameters[CustomDataKey], which may be null.
        public object CustomData => EventData.CustomData;

        //
        // 摘要:
        //     ToString() override.
        //
        // 返回结果:
        //     Short output of "Event" and it's Code.
        public override string ToString()=>EventData.ToString();
        //
        // 摘要:
        //     Extensive output of the event content.
        //
        // 返回结果:
        //     To be used in debug situations only, as it returns a string for each value.
        public string ToStringFull()=>EventData.ToStringFull();


        private bool needUpdate=true;
        internal EventData EventData
        {
            get=>eventData;
            private set
            {
                eventData = value;
                needUpdate = true;
            }
        }
        private EventData eventData ;
        internal PhotonEventData(EventData eventData)
        {
            this.EventData = eventData;
        }
        public PhotonEventData()
        {
            this.EventData = new EventData();
        }
        static PhotonEventData GetUniqueRealtimeInstance()=>PhotonEventData.UniqueRealtimeEventData;
    }
}