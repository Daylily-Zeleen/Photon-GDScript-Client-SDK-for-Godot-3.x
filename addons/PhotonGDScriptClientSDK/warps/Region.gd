# 该类不应自行实例化
class_name Region

var code:String setget _readonly
## Unlike the CloudRegionCode, this may contain cluster information.
var cluster:String setget _readonly 
var host_and_port:String setget _readonly
var ping:int setget _readonly
var was_pinged:bool setget _readonly



func _to_string() -> String:
	var regionCluster:String = code
	if cluster == "": 
		regionCluster += "/"
		regionCluster += cluster
	
	return "[ErrorInfo:%d] %s"%[get_instance_id(),"%s[%s]: %dms"%[regionCluster,host_and_port,ping]]



# setget 
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
func _init(code:String, cluster:String, host_and_port:String, ping:int, was_pinged:bool) -> void:
	self.code = code
	self.cluster = cluster
	self.host_and_port = host_and_port
	self.ping = ping
	self.was_pinged = was_pinged
