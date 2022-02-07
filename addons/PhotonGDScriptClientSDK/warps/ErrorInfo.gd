# 不应该自行实例化
# 通过 RealtimeClient 得到的 ErroInfo 始终为同一对象
class_name ErrorInfo

var info :String setget _readonly, _get_info


func _to_string() -> String:
	return "[ErrorInfo:%d] %s"%[get_instance_id(),_base.ToString()]



# internal 
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
func _get_info()->String:
	return _base.get_Info()

const _Base = preload("../src/PhotonErrorInfo.cs")
var _base:_Base = _Base.GetUnique() as _Base
const _Internal ={
	UniqueInstance = null,
}
static func _setup_internal()->void:
	_Internal.UniqueInstance = load("res://addons/PhotonGDScriptClientSDK/warps/ErrorInfo.gd").new()
	
