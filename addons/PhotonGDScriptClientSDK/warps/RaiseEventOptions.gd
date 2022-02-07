class_name RaiseEventOptions

const Prefeb={
	DEFAULT = null,
}

## Defines if the server should simply send the event, put it in the cache or remove events that are like this one.
## When using option: SliceSetIndex, SlicePurgeIndex or SlicePurgeUpToIndex, set a CacheSliceIndex. All other options except SequenceChannel get ignored.
var caching_option :int setget _set_caching_option,_get_caching_option 
## The number of the Interest Group to send this to. 0 goes to all users but to get 1 and up, clients must subscribe to the group first.
var interest_group:int setget _set_interest_group,_get_interest_group
## A list of Player.ActorNumbers to send this event to. You can implement events that just go to specific users this way.
var target_actors:PoolIntArray setget _set_target_actors,_get_target_actors 
## Sends the event to All, MasterClient or Others (default). Be careful with MasterClient, as the client might disconnect before it got the event and it gets lost.
var receivers:int setget _set_receivers,_get_receivers 
## Optional flags to be used in Photon client SDKs with Op RaiseEvent and Op SetProperties.
## Introduced mainly for webhooks 1.2 to control behavior of forwarded HTTP requests.
var flags:WebFlags setget _set_web_flags, _get_web_flags 


## 实例化该类时不该带参
func _init(__base:_Base = null) -> void:
	if __base: _base = __base
	else: _base = _Base.new()
	





# setget
func _set_web_flags(v:WebFlags)->void:
	flags = v
	_base.set_Flags(v._base)
func _get_web_flags()->WebFlags:
	return flags
func _set_receivers(v:int)->void:
	assert(v in Photon.ReceiverGroup.values(),"非法的兴趣组")
	_base.set_Receivers(v)
func _get_receivers()->int:return _base.get_Receivers()
func _set_target_actors(v:PoolIntArray)->void: _base.set_TargetActors(v)
func _get_target_actors()->PoolIntArray:return _base.get_TargetActors()
func _set_interest_group(v:int)->void:
	assert(v>=0 and v<256,"非法的兴趣组")
	_base.set_InterestGroup(v)
func _get_interest_group()->int:return _base.get_InterestGroup()
func _set_caching_option(v:int)->void:
	assert(v in Photon.EventCaching.values(), "非法的缓存选项")
	_base.set_CachingOption(v)
func _get_caching_option()->int:return _base.get_CachingOption()

const _Base = preload("../src/PhotonRaiseEventOptions.cs") 
var _base : _Base

static func _setup_prefeb()->void:
	Prefeb.DEFAULT = load("res://addons/PhotonGDScriptClientSDK/warps/RaiseEventOptions.gd").new(_Base.GetDefault())
