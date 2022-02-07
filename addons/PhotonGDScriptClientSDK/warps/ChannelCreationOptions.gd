class_name ChannelCreationOptions

const Prefeb ={
	## Default values of channel creation options.
	Default = null,
}
## Whether or not the channel to be created will allow client to keep a list of users.
var publish_subscribers:bool setget _set_publish_subscribers,_get_publish_subscribers
## Limit of the number of users subscribed to the channel to be created.
var max_subscribers:int setget _set_max_subscribers, _get_max_subscribers

## 暂不可用
## <string, object>
var custom_properties:Dictionary setget _set_custom_properties,_get_custom_properties 

func _to_string() -> String:
	return "[ChannelCreationOptions:%d]"%[get_instance_id()]



# setget 
const _Base = preload("../src/PhotonChannelCreationOptions.cs")
var _base = _Base.GetDefaultOptions()
func _set_custom_properties(v:Dictionary)->void:
	if _base and _base.has_method("set_CustomProperties"):
		_base.set_CustomProperties(v)
func _get_custom_properties()->Dictionary:
	if _base and _base.has_method("get_CustomProperties"):
		return _base.get_CustomProperties()
	else : return {}
func _set_max_subscribers(v:int)->void:
	_base.set_MaxSubscribers(v)
func _get_max_subscribers()->int:
	if _base: return _base.get_MaxSubscribers()
	else: return 0
func _set_publish_subscribers(v:bool)->void:
	_base.set_PublishSubscribers(v)
func _get_publish_subscribers()->bool:
	if _base: return _base.get_PublishSubscribers()
	return false
func _readonly(v)->void:
	assert(false,"该属性为只读属性")




static func _setup_prefeb()->void:
	Prefeb.Default = load("res://addons/PhotonGDScriptClientSDK/warps/ChannelCreationOptions.gd").new()
#	print(Prefeb.Default._base)
#	Prefeb.Default._base.free()#call_deferred("free")
	Prefeb.Default._base = _Base.GetDefaultOptions()
