## 该类不该自行实例化
## 这是一个低级别的数据类型对象
## 为减少通讯数据对象实例化产生的内存垃圾
## 通过 Photon 的对象获取的 OperationResponse 将始终为同一个对象 
## 如果需要缓存其中的信息，建议自行从中提取信息
class_name OperationResponse

## 摘要:
##     The code for the operation called initially (by this peer).
## 言论：
##     Use enums or constants to be able to handle those codes, like OperationCode does.
var operation_code :int setget _readonly,_get_operation_code

## A code that "summarizes" the operation's success or failure. Specific per operation.
## 0 usually means "ok".
var return_code:int setget _readonly, _get_return_code

## An optional string sent by the server to provide readable feedback in error-cases.
## Might be null(在 Gds 中为 ""，防止报错).
var debug_message:String setget _readonly, _get_debug_message

## A Dictionary of values returned by an operation, using byte-typed keys per value.
var parameters:Dictionary setget _readonly,_get_parameters


## 摘要:
##     Alternative access to the Parameters, which wraps up a TryGetValue() call on
##     the Parameters Dictionary.
##
## 参数:
##   parameterCode:
##     The byte-code of a returned value.
##
## 返回结果:
##     The value returned by the server, or null if the key does not exist in Parameters.
func get_parameter(parameter_code:int):
	assert(parameter_code >=0 and parameter_code <256 ,"非法的参数代号")
	return parameters.get(parameter_code,null)


#func duplicate()->OperationResponse:
#	return _Prefeb._CLASS.new(_base)




func _to_string() -> String:
	return "[OperationResponse:%d] %s" %[get_instance_id(),_base.ToString()]
func to_string_full()->String:
	return "[OperationResponse:%d] %s" %[get_instance_id(),_base.ToStringFull()]




#  内部
func _readonly(v):
	assert(false,"该属性为只读属性")
	
func _get_parameters()->Dictionary:
	return _base.Parameters
func _get_debug_message()->String:
	var tmp = _base.get_DebugMessage()
	return tmp if tmp else "" 
func _get_return_code()->int:
	return _base.get_ReturnCode()
func _get_operation_code()->int:
	return _base.get_OperationCode()
	

func _init(__base:_Base) -> void:
	assert(__base ,"包装对象不能为空")
	_base = __base



const _Prefeb :={
	_UNIQUE = null,
#	_CLASS = null,
}
const _Base = preload("../src/PhotonOperationResponse.cs")
var _base #:_Base

static func _setup_prefeb()->void:
	var _CLASS = load("res://addons/PhotonGDScriptClientSDK/warps/OperationResponse.gd")
	_Prefeb._UNIQUE = _CLASS.new(_Base.new())
