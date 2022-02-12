class_name RealtimeAuthenticationValues

## <summary>The type of authentication provider that should be used. Defaults to None (no auth whatsoever).</summary>
## <remarks>Several auth providers are available and CustomAuthenticationType.Custom can be used if you build your own service.</remarks>
var auth_type:int setget _set_auth_type, _get_auth_type 

## <summary>This string must contain any (http get) parameters expected by the used authentication service. By default, username and token.</summary>
## <remarks>
## Maps to operation parameter 216.
## Standard http get parameters are used here and passed on to the service that's defined in the server (Photon Cloud Dashboard).
## </remarks>
var auth_get_parameters:String setget _set_auth_get_parameters,_get_auth_get_parameters 
## <summary>Data to be passed-on to the auth service via POST. Default: null (not sent). Either string or byte[] (see setters).</summary>
## <remarks>Maps to operation parameter 214.</remarks>
var auth_post_data setget _readonly, _get_auth_post_data
## <summary>Internal <b>Photon token</b>. After initial authentication, Photon provides a token for this client, subsequently used as (cached) validation.</summary>
## <remarks>Any token for custom authentication should be set via SetAuthPostData or AddAuthParameter.</remarks>
var token setget _readonly, _get_token
## <summary>The UserId should be a unique identifier per user. This is for finding friends, etc..</summary>
## <remarks>See remarks of AuthValues for info about how this is set and used.</remarks>
var user_id :String setget _set_user_id, _get_user_id





func _init(user_id:String = "")->void:
	if not user_id.empty():
		_base.set_UserId(user_id)
		
## <summary>Sets the data to be passed-on to the auth service via POST.</summary>
## <remarks>AuthPostData is just one value. Each SetAuthPostData replaces any previous value. It can be either a string, a byte[] or a dictionary.</remarks>
## <param name="stringData">String data to be used in the body of the POST request. Null or empty string will set AuthPostData to null.</param>        
func set_auth_post_string_data(string_data:String)->void:
	_base.SetAuthPostStringData(string_data)
## <summary>Sets the data to be passed-on to the auth service via POST.</summary>
## <remarks>AuthPostData is just one value. Each SetAuthPostData replaces any previous value. It can be either a string, a byte[] or a dictionary.</remarks>
## <param name="byteData">Binary token / auth-data to pass on.</param>
func set_auth_post_byte_data(byte_data:PoolByteArray)->void:
	_base.SetAuthPostByteData(byte_data)
## <summary>Sets data to be passed-on to the auth service as Json (Content-Type: "application/json") via Post.</summary>
## <remarks>AuthPostData is just one value. Each SetAuthPostData replaces any previous value. It can be either a string, a byte[] or a dictionary.</remarks>
## <param name="dictData">A authentication-data dictionary will be converted to Json and passed to the Auth webservice via HTTP Post.</param>
func set_auth_post_dict_data(dict_data:Dictionary)->void:
	_base.SetAuthPostDictData(dict_data)
## <summary>Adds a key-value pair to the get-parameters used for Custom Auth (AuthGetParameters).</summary>
## <remarks>This method does uri-encoding for you.</remarks>
## <param name="key">Key for the value to set.</param>
## <param name="value">Some value relevant for Custom Authentication.</param>
func add_auth_parameter(key:String, value:String)->void:
	_base.AddAuthParameter(key,value)
## <summary>
## Make a copy of the current object.
## </summary>
## <param name="copy">The object to be copied into.</param>
## <returns>The copied object.</returns>
func copy_to(copy:RealtimeAuthenticationValues)->RealtimeAuthenticationValues:
	_base.CopyTo(copy._base)
	return copy
	
	
	
func _to_string() -> String:
	return "[RealtimeAuthenticationValues:%d] %s"%[get_instance_id(), _base.ToString()]
	
	


# setget 
func _set_user_id(v:String)->void:
	_base.set_UserId(v)
func _get_user_id()->String:
	return _base.get_UserId()
func _get_token():
	return _base.get_Token()
func _get_auth_post_data():
	return _base.get_AuthPostData()
func _set_auth_get_parameters(v:String)->void:
	_base.set_AuthGetParameters(v)
func _get_auth_get_parameters()->String:
	return _base.get_AuthGetParameters()
func _set_auth_type(v:int)->void:
	assert(v in Photon.CustomAuthenticationType.values(),"非法的验证类型")
	_base.set_AuthType(v)
func _get_auth_type()->int:
	return _base.get_AuthType()
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
	
const _Base = preload("../src/PhotonRealtimeAuthenticationValues.cs")
var _base:_Base = _Base.new()
