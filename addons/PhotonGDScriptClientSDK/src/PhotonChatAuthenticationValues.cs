using Godot;
using Photon.Chat;
// using System.Collections.Generic;
using Godot.Collections;
namespace PhotonGodotWarps.Warps
{
    public class PhotonChatAuthenticationValues:Reference
    {
        /// <summary>The type of authentication provider that should be used. Defaults to None (no auth whatsoever).</summary>
        /// <remarks>Several auth providers are available and CustomAuthenticationType.Custom can be used if you build your own service.</remarks>
        public CustomAuthenticationType AuthType
        {
            get =>AuthenticationValues.AuthType;
            set =>AuthenticationValues.AuthType=value;
        }

        /// <summary>This string must contain any (http get) parameters expected by the used authentication service. By default, username and token.</summary>
        /// <remarks>
        /// Maps to operation parameter 216.
        /// Standard http get parameters are used here and passed on to the service that's defined in the server (Photon Cloud Dashboard).
        /// </remarks>
        public string AuthGetParameters { get => AuthenticationValues.AuthGetParameters; set => AuthenticationValues.AuthGetParameters=value; }

        /// <summary>Data to be passed-on to the auth service via POST. Default: null (not sent). Either string or byte[] (see setters).</summary>
        /// <remarks>Maps to operation parameter 214.</remarks>
        public object AuthPostData => AuthenticationValues.AuthPostData;

        /// <summary>Internal <b>Photon token</b>. After initial authentication, Photon provides a token for this client, subsequently used as (cached) validation.</summary>
        /// <remarks>Any token for custom authentication should be set via SetAuthPostData or AddAuthParameter.</remarks>
        public object Token => AuthenticationValues.Token;

        /// <summary>The UserId should be a unique identifier per user. This is for finding friends, etc..</summary>
        /// <remarks>See remarks of AuthValues for info about how this is set and used.</remarks>
        public string UserId { get => AuthenticationValues.UserId; set => AuthenticationValues.UserId=value; }


        /// <summary>Creates empty auth values without any info.</summary>
        public PhotonChatAuthenticationValues()
        {
            this.AuthenticationValues = new AuthenticationValues(); 
        }

        /// <summary>Creates minimal info about the user. If this is authenticated or not, depends on the set AuthType.</summary>
        /// <param name="userId">Some UserId to set in Photon.</param>
        public PhotonChatAuthenticationValues(string userId)
        {
            this.AuthenticationValues = new AuthenticationValues(userId); 
        }

        /// <summary>Sets the data to be passed-on to the auth service via POST.</summary>
        /// <remarks>AuthPostData is just one value. Each SetAuthPostData replaces any previous value. It can be either a string, a byte[] or a dictionary.</remarks>
        /// <param name="stringData">String data to be used in the body of the POST request. Null or empty string will set AuthPostData to null.</param>
        public virtual void SetAuthPostStringData(string stringData) => AuthenticationValues.SetAuthPostData(stringData);

        /// <summary>Sets the data to be passed-on to the auth service via POST.</summary>
        /// <remarks>AuthPostData is just one value. Each SetAuthPostData replaces any previous value. It can be either a string, a byte[] or a dictionary.</remarks>
        /// <param name="byteData">Binary token / auth-data to pass on.</param>
        public virtual void SetAuthPostByteData(byte[] byteData) => AuthenticationValues.SetAuthPostData(byteData);

        /// <summary>Sets data to be passed-on to the auth service as Json (Content-Type: "application/json") via Post.</summary>
        /// <remarks>AuthPostData is just one value. Each SetAuthPostData replaces any previous value. It can be either a string, a byte[] or a dictionary.</remarks>
        /// <param name="dictData">A authentication-data dictionary will be converted to Json and passed to the Auth webservice via HTTP Post.</param>
        public virtual void SetAuthPostDictData(Dictionary<string, object> dictData) => 
            AuthenticationValues.SetAuthPostData(new System.Collections.Generic.Dictionary<string, object>(dictData));

        /// <summary>Adds a key-value pair to the get-parameters used for Custom Auth (AuthGetParameters).</summary>
        /// <remarks>This method does uri-encoding for you.</remarks>
        /// <param name="key">Key for the value to set.</param>
        /// <param name="value">Some value relevant for Custom Authentication.</param>
        public virtual void AddAuthParameter(string key, string value) =>
            AuthenticationValues.AddAuthParameter(key,value);

        /// <summary>
        /// Transform this object into string.
        /// </summary>
        /// <returns>string representation of this object.</returns>
        public override string ToString() =>AuthenticationValues.ToString();

        /// <summary>
        /// Make a copy of the current object.
        /// </summary>
        /// <param name="copy">The object to be copied into.</param>
        /// <returns>The copied object.</returns>
        public PhotonChatAuthenticationValues CopyTo(PhotonChatAuthenticationValues copy)
        {
            this.AuthenticationValues.CopyTo(copy.AuthenticationValues);
            return copy;
        }

        internal AuthenticationValues AuthenticationValues{get;set;}
        
    }
}