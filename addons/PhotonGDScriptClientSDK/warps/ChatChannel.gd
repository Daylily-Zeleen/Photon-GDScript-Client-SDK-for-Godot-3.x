## 不应自行实例化
## 可通过 ChatChannel[i] 获取频道中缓存的信息 [sender :str , message : str]
## 可也通过 for 像数组一样进行迭代迭代
## ChatChannel.size() => 频道内缓存的信息数量 等价于 ChatChannel.message_count
class_name ChatChannel

## Name of the channel (used to subscribe and unsubscribe).
var name:String setget _readonly ,_get_name
## If greater than 0, this channel will limit the number of messages, that it caches locally.
var message_limit:int setget _set_message_limit,_get_message_limit
## Unique channel ID.
var channel_id:int setget _set_channel_id, _get_channel_id
## Is this a private 1:1 channel?
var is_private:bool setget _readonly,_get_is_private
## Count of messages this client still buffers/knows for this channel.
var message_count:int setget _readonly, size
## ID of the last message received.
var last_msg_id:int setget _readonly, _get_last_msg_id
## Whether or not this channel keeps track of the list of its subscribers.
var publish_subscribers :bool setget _readonly,  _get_publish_subscribers
## Maximum number of channel subscribers. 0 means infinite.
var max_subscribers :int setget _readonly, _get_max_subscribers
## Subscribers( Array<string>  )
var subscribers:Array setget _readonly, _get_subscribers


## <summary>Provides a string-representation of all messages in this channel.</summary>
## <returns>All known messages in format "Sender: Message", line by line.</returns>
func to_string_messages()->String:
	return _base.ToStringMessages()
func _to_string() -> String:
	return "[ChatChannel:%d]"%get_instance_id()

## 暂不可用
func _try_get_custom_channel_property(property_key:String):
	return _base.TryGetCustomChannelProperty(property_key)











# 迭代器
var _current_iter_idx:int = 0

func _iter_init(arg)->bool:
	_current_iter_idx = 0
	return _current_iter_idx < self.message_count

func _iter_next(arg):
	_current_iter_idx += 1
	return _current_iter_idx < self.message_count

func _iter_get(arg):
	return [_base.GetSender(_current_iter_idx), _base.GetMessage(_current_iter_idx)]




# setget 
func _get_subscribers()->Array:
	return _base.get_Subscribers()
func _get_max_subscribers()->int:
	return _base.get_MaxSubscribers()
func _get_publish_subscribers()->bool:
	return _base.get_PublishSubscribers()
func _get_last_msg_id()->int:
	return _base.get_LastMsgId()
func size()->int:
	return _base.get_MessageCount()
func _get_is_private()->bool:
	return _base.get_IsPrivate()
func _set_channel_id(v:int)->void:
	_base.set_ChannelID(v)
func _get_channel_id()->int:
	return _base.get_ChannelID()
func _set_message_limit(v:int)->void:
	_base.set_MessageLimit(v)
func _get_message_limit()->int:
	return _base.get_MessageLimit()
func _get_name()->String:
	return _base.get_Name()

func _readonly(v)->void:
	assert(false,"该属性为只读属性")

func _init(__base) -> void:#:_Base
	assert(Engine.editor_hint or __base,"不能为空")
	_base == __base
#const _Base = preload("../src/PhotonChatChannel.cs")
var _base #:_Base
