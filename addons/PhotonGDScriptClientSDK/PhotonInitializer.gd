extends Node


func _init() -> void:
	SendOptions._setup_prefeb()

	RaiseEventOptions._setup_prefeb()

	TypedLobby._setup_prefeb()

	WebFlags._setup_prefeb()

	EventData._setup_inernal()
	
	ErrorInfo._setup_internal()
	
	WebRpcResponse._setup_internal()
	
	ChannelCreationOptions._setup_prefeb()
	
	queue_free()
