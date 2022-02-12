class_name WebFlags

const Prefeb = {
	DEFAULT = null,
}

var webhook_flags :int setget _set_webhook_flags, _get_webhook_flags
var http_forward:bool setget _set_http_forward, _get_http_forward
var send_auth_cookie:bool setget _set_send_auth_cookie, _get_send_auth_cookie
var send_sync:bool setget _set_send_sync, _get_send_sync
var send_state:bool setget _set_send_state, _get_send_state


func _init(webhook_flags:int = 0) -> void:
	assert(webhook_flags >=0 and webhook_flags< 256,"非法的网络钩标志字节")
	_base.set_WebhookFlags(webhook_flags)


func _to_string() -> String:
	return "[WebFlags:%d]"%[get_instance_id()]

# setget 
func _set_send_state(v:bool)->void:_base.set_SendState(v)
func _get_send_state()->bool:return _base.get_SendState()
func _set_send_sync(v:bool)->void:_base.set_SendSync(v)
func _get_send_sync()->bool:return _base.get_SendSync()
func _set_send_auth_cookie(v:bool)->void:_base.set_SendAuthCookie(v)
func _get_send_auth_cookie()->bool:return _base.get_SendAuthCookie()
func _set_http_forward(v:bool)->void:_base.set_HttpForward(v)
func _get_http_forward()->bool:return _base.get_HttpForward()
func _set_webhook_flags(v:int)->void:_base.set_WebhookFlags(v)
func _get_webhook_flags()->int:return _base.get_WebhookFlags()

	
	
const _Base = preload("../src/PhotonWebFlags.cs")
var _base:_Base = _Base.new()

static func _setup_prefeb()->void:
	Prefeb.DEFAULT = load("res://addons/PhotonGDScriptClientSDK/wraps/WebFlags.gd").new()
	Prefeb.DEFAULT._base = _Base.GetDefault()
