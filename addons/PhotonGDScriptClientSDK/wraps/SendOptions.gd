class_name SendOptions
## 也可通过 Photon.SendOptions_SendReliable 获取
## 也可通过 Photon.SendOptions_SendUnreliable 获取
const Prefeb = {
	SEND_RELIABLE = null,
	SEND_UNRELIABLE = null,
}

##  Chose the DeliveryMode for this operation/message. Defaults to Unreliable.
var delivery_mode setget _set_delivery_mode,_get_delivery_mode

## If true the operation/message gets encrypted before it's sent. Defaults to false.
## Before encryption can be used, it must be established. Check PhotonPeer.IsEncryptionAvailable is true.
var encrypt :bool setget _set_encrypt,_get_encrypt

## The Enet channel to send in. Defaults to 0.
## Channels in Photon relate to "message channels". Each channel is a sequence of messages.
var channel:int setget _set_channel,_get_channel

## Sets the DeliveryMode either to true: Reliable or false: Unreliable, overriding any current value.
## Use this to conveniently select reliable/unreliable delivery.
var reliability:bool setget _set_reliability,_get_reliability


## 实例化该类时不该带参
func _init(__base) -> void: #:_Base
	if __base : _base = __base
	else : _base = _Base.new()


	
func _to_string() -> String:
	return "[SendOptions:%d]"%get_instance_id()

# setget

func _set_reliability(v:bool)->void:
	_base.set_Reliability(v)
func _get_reliability()->bool:
	return _base.get_Reliability()
func _set_channel(v:int)->void:
	assert(v>=0 and v<256,"非法的发送通道")
	_base.set_Channel(v)
func _get_channel()->int:
	return _base.get_Channel()
func _set_encrypt(v:bool)->void:
	_base.set_Encrypt(v)
func _get_encrypt()->bool:
	return _base.get_Encrypt()
func _set_delivery_mode(v:int)->void:
	assert(v in Photon.DeliveryMode.values(),"非法的发送模式")
	_base.set_DeliveryMode(v)
func _get_delivery_mode()->int:
	return _base.get_DeliveryMode()


const _Base = preload("../src/PhotonSendOptions.cs")
var _base # :_Base 

static func _setup_prefeb()->void:
	var class_script = load("res://addons/PhotonGDScriptClientSDK/wraps/SendOptions.gd")
	Prefeb.SEND_RELIABLE = class_script.new(_Base.GetSendReliable())
	Prefeb.SEND_UNRELIABLE = class_script.new(_Base.GetSendUnreliable())
