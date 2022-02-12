using Godot;
using Photon.Realtime;
using System.Collections;
using Godot.Collections;
namespace PhotonGodotWraps.Wraps
{
    public class PhotonRegion:Reference
    {
        public string Code =>Region.Code;

        public string Cluster =>Region.Cluster;

        public string HostAndPort =>Region.HostAndPort;

        public int Ping { get=>Region.Ping; set=>Region.Ping=value; }

        public bool WasPinged => Region.WasPinged;

        public PhotonRegion(string code, string address)
        {
            this.Region = new Region(code,address);
        }

        public PhotonRegion(string code, int ping)
        {
            this.Region = new Region(code,ping);
        }
        public override string ToString()
        {
            return Region.ToString();
        }

        public string ToString(bool compact = false)
        {
            return Region.ToString(compact);
        }

        internal Region Region{get;private set;}
        internal PhotonRegion(Region region)
        {
            this.Region =region;
        }
    }
}