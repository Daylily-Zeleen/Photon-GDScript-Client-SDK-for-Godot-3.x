# 该类不应自行实例化
class_name RegionHandler

## <summary>A list of region names for the Photon Cloud. Set by the result of OpGetRegions().</summary>
## <remarks>
## Implement ILoadBalancingCallbacks and register for the callbacks to get OnRegionListReceived(RegionHandler regionHandler).
## You can also put a "case OperationCode.GetRegions:" into your OnOperationResponse method to notice when the result is available.
## </remarks> 包含 Region 的一个数组
var enabled_regions:Array setget _readonly , _get_enabled_regions
## When PingMinimumOfRegions was called and completed, the BestRegion is identified by best ping.
var best_region:Region setget _readonly, _get_best_region
## <summary>
## This value summarizes the results of pinging currently available regions (after PingMinimumOfRegions finished).
## </summary>
## <remarks>
## This value should be stored in the client by the game logic.
## When connecting again, use it as previous summary to speed up pinging regions and to make the best region sticky for the client.
## </remarks>
var summary_to_cache:String setget _readonly, _get_summary_to_cache

var is_pinging:bool setget _readonly, _get_is_pinging

func get_result()->String:
	return _base.GetResults()

func _to_string() -> String:
	return "[RegionHandler:%d]"
	


# setget 
func _readonly(v)->void:
	assert(false,"该属性为只读属性")

func _get_is_pinging()->bool:
	return _base.get_IsPinging()
func _get_enabled_regions()->Array:
	return _base.EnabledRegions
func _get_best_region()->Region:
	return _base.get_BestRegion()
func _get_summary_to_cache()->String:
	return _base.get_SummaryToCache()


#const _Base = preload("../src/PhotonRegionHandler.cs")
var _base#:_Base

func _init(__base) -> void:#:_Base
	assert(Engine.editor_hint or __base ,"不能为空")
	_base = __base
	
