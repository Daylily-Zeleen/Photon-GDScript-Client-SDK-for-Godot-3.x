using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonErrorInfo:Reference
    {
        internal static readonly PhotonErrorInfo UniqueInstance = new PhotonErrorInfo();
        internal static PhotonErrorInfo GetUniqueInstance(ErrorInfo errorInfo)
        {
            UniqueInstance.ErrorInfo = errorInfo;
            return UniqueInstance;
        }
        public string Info =>ErrorInfo.Info;
        internal Photon.Realtime.ErrorInfo ErrorInfo{get;private set;}
        // 不应自行构造
        // 这是给godot对接用的
        public PhotonErrorInfo(){}
        internal PhotonErrorInfo(Photon.Realtime.ErrorInfo errorInfo)
        {
            this.ErrorInfo = errorInfo;
        }
        public override string ToString()
        {
            return this.ErrorInfo.ToString();
        }
        public static PhotonErrorInfo GetUnique()=>PhotonErrorInfo.UniqueInstance;
        
    }
}