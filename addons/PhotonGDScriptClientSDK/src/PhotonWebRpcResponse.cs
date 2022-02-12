using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
using ExitGames.Client.Photon;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonWebRpcResponse:Reference
    {
        internal static PhotonWebRpcResponse UniqueInstance = new PhotonWebRpcResponse();
        internal static PhotonWebRpcResponse GetUniqueInstance(OperationResponse response)
        {
            UniqueInstance.WebRpcResponse = new WebRpcResponse(response);
            return UniqueInstance;
        }
        public string Name =>WebRpcResponse.Name;
        public int ResultCode=>WebRpcResponse.ResultCode;
        public string Message=>WebRpcResponse.Message;
        public Dictionary<string, object> Parameters
        {
            get
            {
                if (needUpdate)
                {
                    parameters.Clear();
                    foreach (var kv in this.webRpcResponse.Parameters)
                    {
                        parameters.Add(kv.Key,(kv.Value is IDictionary)? new Dictionary(kv.Value as IDictionary) : kv.Value);
                    }
                    needUpdate = false;
                }
                return parameters;
            }
        }
        private Dictionary<string, object> parameters = new Dictionary<string, object>(); 
        public string ToStringFull()=>WebRpcResponse.ToStringFull();
        public override string ToString()=>"{WebRpcResponse}: "+ToStringFull();
            
        internal WebRpcResponse WebRpcResponse
        {
            get=>webRpcResponse;
            private set
            {
                webRpcResponse = value;
                needUpdate = true;
            }
        }
        private bool needUpdate = true;
        private WebRpcResponse webRpcResponse ;
        public PhotonWebRpcResponse(){}
        internal PhotonWebRpcResponse(WebRpcResponse webRpcResponse)
        {
            this.WebRpcResponse = webRpcResponse;
            // Parameters = new Dictionary<string, object>(this.WebRpcResponse.Parameters);
        }
        internal PhotonWebRpcResponse(OperationResponse operationResponse)
        {
            this.WebRpcResponse = new WebRpcResponse(operationResponse);
            // Parameters = new Dictionary<string, object>(this.WebRpcResponse.Parameters);
        }
        public PhotonWebRpcResponse(PhotonOperationResponse photonOperationResponse)
        {
            this.WebRpcResponse = new WebRpcResponse(photonOperationResponse.OperationResponse);
            // Parameters = new Dictionary<string, object>(this.WebRpcResponse.Parameters);
        }
        public static PhotonWebRpcResponse GetUnique()=>PhotonWebRpcResponse.UniqueInstance;
    }
}