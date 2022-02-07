extends RealtimeClient

func _ready() -> void:
	connect("connected_to_master",self,"_on_connect_to_master")
	connect("room_joined",self,"_on_room_joined")
	connect("event_received",self,"_on_event_received")
	connect("player_room_entered",self,"_on_player_room_entered")
	self.bg_dispatch_interval_ms = 20
	self.bg_send_interval_ms = 20
	self.bg_dispatch = true
	self.bg_send = true
	var setting = AppSettings.new()
	setting.app_id_realtime = "c45c78da-788d-407b-b249-334de949c480"
	setting.app_version = "v0.1"
	setting.fixed_region = "cn"
	setting.server = "ns.photonengine.cn"
	connect_using_settings(setting)

func _on_connect_to_master():
	print("连接到主服务器成功:",name)
	
	var params = EnterRoomParams.new()
	params.room_name = "test_room"
	params.room_options = RoomOptions.new()
	params.room_options.max_players = 2
	op_join_or_create_room(params)

var start_tick :int =0
func _on_room_joined():
	var raise_event_options:=RaiseEventOptions.new()
	raise_event_options.receivers = Photon.ReceiverGroup.All
	start_tick = OS.get_ticks_msec()
	op_raise_event(0, "abc".to_ascii(), raise_event_options, SendOptions.Prefeb.SEND_UNRELIABLE)

func _on_event_received(event_data:EventData):
	if event_data.code == 0:
		print(OS.get_ticks_msec() - start_tick)
	print("接收事件:",name," ",event_data.custom_data )

func _on_player_room_entered(new_player:PhotonPlayer):
	print(new_player)
