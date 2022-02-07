## 不应实例化该类
## 为减少内存垃圾,默认通过 RealtimeClient 得到的 EventData 都为同一个对象（重用）
## 可通过 EventData.set_reuse_event_instance() 设置是否开启重用
## Custom Events only use Code, Sender and CustomData.
## 自定义事件只需要使用 code, sender , custom_data 三个属性
class_name EventData

## The Parameters of an event is a Dictionary<byte, object>.
var parameters:Dictionary setget _readonly,_get_parameters
## The event code identifies the type of event. (自定义的事件代码 < 200)
var code:int setget _readonly,_get_code
## 摘要:
##     Defines the event key containing the Sender of the event.
##
## 言论：
##     Defaults to Sender key of Realtime API events (RaiseEvent): 254. Can be set to
##     Chat API's ChatParameterCode.Sender: 5.
var sender_key setget _readonly, _get_sender_key
## 摘要:
##     Defines the event key containing the Custom Data of the event.
##
## 言论：
##     Defaults to Data key of Realtime API events (RaiseEvent): 245. Can be set to
##     any other value on demand.
var custom_data_key setget _readonly, _get_custom_data_key

## 摘要:
##     Access to the Parameters of a Photon-defined event. Custom Events only use Code,
##     Sender and CustomData.
## 参数:
##   key:
##     The key byte-code of a Photon event value.
## 返回结果:
##     The Parameters value, or null if the key does not exist in Parameters.
func get_parameter(key:int):
	assert(key >= 0 and key <256,"非法的参数键")
	return parameters.get(key,null)
	
## 摘要:
##     Accesses the Sender of the event via the indexer and SenderKey. The result is cached.
## 言论：
##     Accesses this event's Parameters[CustomDataKey], which may be null. In that case,
##     this returns 0 (identifying the server as sender).
var sender:int setget _readonly,_get_sender
## 摘要:
##     Accesses the Custom Data of the event via the indexer and CustomDataKey. The
##     result is cached.
##
## 言论：
##     Accesses this event's Parameters[CustomDataKey], which may be null.
var custom_data setget _readonly,_get_custom_data




static func set_reuse_event_instance(reuse:bool)->void:
	_Inernal.ReuseEventInstance = reuse
	_Base.set_ReuseRealtimeEventInstance(reuse) #
	
func _to_string() -> String:
	return "[EventData:%d Code: %d] "%[get_instance_id(),self.code]
func to_string_full()->String:
	return "[EventData:%d Code: %d] Params:%s"%[get_instance_id(),self.code, JSON.print(self.parameters)]
	
	
	

#####
func _get_custom_data():
	return _base.get_CustomData()
func _get_sender()->int:
	return _base.get_Sender()
func _get_custom_data_key()->int:
	return _base.get_CustomDataKey()
func _get_sender_key()->int:
	return _base.get_SenderKey()
func _get_code()->int:
	return _base.get_Code()
func _get_parameters()->Dictionary:
	return _base.get_Parameters()
func _readonly(v)->void:
	assert(false,"该属性为只读属性")

func _init(__base) -> void:
	_base = __base

const _Base = preload("../src/PhotonEventData.cs")
var _base #:_Base
const _Inernal = {
	ReuseEventInstance = true,
	SelfClass = null,
	UniqueEventData = null,
}
static func _setup_inernal()->void:
	_Inernal.SelfClass = load("res://addons/PhotonGDScriptClientSDK/warps/EventData.gd")
	_Inernal.UniqueEventData = _Inernal.SelfClass.new(_Base.GetUniqueRealtimeInstance())

static func _get_event_data(photon_event_data)->EventData:#:_Base
	if _Inernal.ReuseEventInstance: return _Inernal.UniqueEventData # 同步
	else : return _Inernal.SelfClass.new(photon_event_data)
