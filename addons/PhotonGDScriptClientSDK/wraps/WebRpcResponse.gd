# 不应该自行实例化
# 通过 RealtimeClient 得到的 WebRpcResponse 始终为同一对象
class_name WebRpcResponse

## <summary>Reads an operation response of a WebRpc and provides convenient access to most common values.</summary>
## <remarks>
## See LoadBalancingClient.OpWebRpc.<br/>
## Create a WebRpcResponse to access common result values.<br/>
## The operationResponse.OperationCode should be: OperationCode.WebRpc.<br/>
## </remarks>
var name:String setget _readonly,_get_name
## <summary>ResultCode of the WebService that answered the WebRpc.</summary>
## <remarks>
##  0 is: "OK" for WebRPCs.<br/>
## -1 is: No ResultCode by WebRpc service (check <see cref="OperationResponse.ReturnCode"/>).<br/>
## Other ResultCode are defined by the individual WebRpc and service.
## </remarks>
var result_code :int setget _readonly, _get_result_code
## Might be empty or null.
var message:String setget _readonly, _get_message
## Other key/values returned by the webservice that answered the WebRpc.
var parameters:Dictionary setget _readonly,_get_parameters


func _to_string() -> String:
	return "[WebRpcResponse%d]"%[get_instance_id()]
func to_string_full()->String:
	return "[WebRpcResponse%d] %s"%[get_instance_id(), _base.ToStringFull()]




# setget 
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
func _get_name()->String:
	return _base.get_Name()
func _get_result_code()->int:
	return _base.get_ResultCode()
func _get_message()->String:
	var tmp = _base.get_Message()
	return tmp if tmp else ""
func _get_parameters()->Dictionary:
	return _base.get_Parameters()

const _Base = preload("../src/PhotonWebRpcResponse.cs")
var _base:_Base = _Base.GetUnique() as _Base
const _Internal ={
	UniqueInstance = null,
}
static func _setup_internal()->void:
	_Internal.UniqueInstance = load("res://addons/PhotonGDScriptClientSDK/wraps/WebRpcResponse.gd").new()

