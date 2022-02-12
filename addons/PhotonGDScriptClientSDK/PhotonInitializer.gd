extends Node


func _init() -> void:

	RaiseEventOptions._setup_prefeb()

	TypedLobby._setup_prefeb()

	WebFlags._setup_prefeb()
	
	ErrorInfo._setup_internal()
	
	WebRpcResponse._setup_internal()
	
	ChannelCreationOptions._setup_prefeb()
	
	OperationResponse._setup_prefeb()
	
	SendOptions._setup_prefeb()
	
	queue_free()

