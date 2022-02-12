using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
using ExitGames.Client.Photon;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonOperationResponse:Reference
    {        
        internal static PhotonOperationResponse UniqueRealtimeOpResponse = new PhotonOperationResponse() ;
        internal static PhotonOperationResponse UniqueChatOpResponse = new PhotonOperationResponse() ;
        internal static bool ReuseRealtimeOpResponseInstance {get;set;} = true;
        internal static bool ReuseChatOpResponseInstance {get;set;} = true;
        internal static PhotonOperationResponse GetPhotonRealtimeOpResponse(OperationResponse opResponse)
        {
            if (ReuseRealtimeOpResponseInstance ) 
            {
                UniqueRealtimeOpResponse.OperationResponse = opResponse;
                return UniqueRealtimeOpResponse;
            }
            else return new PhotonOperationResponse(opResponse);
        }
        internal static PhotonOperationResponse GetPhotonChatOpResponse(OperationResponse opResponse)
        {
            if (ReuseChatOpResponseInstance ) 
            {
                UniqueChatOpResponse.OperationResponse = opResponse;
                return UniqueChatOpResponse;
            }
            else return new PhotonOperationResponse(opResponse);
        }

        //
        // 摘要:
        //     The code for the operation called initially (by this peer).
        //
        // 言论：
        //     Use enums or constants to be able to handle those codes, like OperationCode does.
        public byte OperationCode=>OperationResponse.OperationCode;
        //
        // 摘要:
        //     A code that "summarizes" the operation's success or failure. Specific per operation.
        //     0 usually means "ok".
        public short ReturnCode=>OperationResponse.ReturnCode;
        //
        // 摘要:
        //     An optional string sent by the server to provide readable feedback in error-cases.
        //     Might be null.
        public string DebugMessage=>OperationResponse.DebugMessage;
        //
        // 摘要:
        //     A Dictionary of values returned by an operation, using byte-typed keys per value.
        public readonly Dictionary<byte,object> Parameters = new Dictionary<byte,object>();


        //
        // 摘要:
        //     Alternative access to the Parameters, which wraps up a TryGetValue() call on
        //     the Parameters Dictionary.
        //
        // 参数:
        //   parameterCode:
        //     The byte-code of a returned value.
        //
        // 返回结果:
        //     The value returned by the server, or null if the key does not exist in Parameters.
        public object this[byte parameterCode] { get=>Parameters[parameterCode]; set=>Parameters[parameterCode]=value; }

        //
        // 摘要:
        //     ToString() override.
        //
        // 返回结果:
        //     Relatively short output of OpCode and returnCode.
        public override string ToString()=>this.OperationResponse.ToString();
        //
        // 摘要:
        //     Extensive output of operation results.
        //
        // 返回结果:
        //     To be used in debug situations only, as it returns a string for each value.
        public string ToStringFull()=>this.OperationResponse.ToStringFull();

        internal OperationResponse OperationResponse
        {
            get=>operationResponse;
            private set
            {
                operationResponse = value;
                this.Parameters.Clear();
                if (operationResponse.Parameters !=null && operationResponse.Parameters.Count>0)
                {
                    foreach (var kv in operationResponse.Parameters)
                    {
                        
                        this.Parameters[kv.Key] = (kv.Value is IDictionary)? new Dictionary((kv.Value as IDictionary)) :kv.Value;
                    }
                }
            }
        }
        private OperationResponse operationResponse;
        internal PhotonOperationResponse(OperationResponse operationResponse)
        {
            this.OperationResponse = operationResponse;
        }
        
        public PhotonOperationResponse()
        {
            this.OperationResponse = new OperationResponse();
        }
        public PhotonOperationResponse Duplicate()
        {
            return new PhotonOperationResponse(this.operationResponse);
        }
    }
}