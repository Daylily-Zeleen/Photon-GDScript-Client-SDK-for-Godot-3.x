extends RealtimeClient

# 连接到服务器
func _ready() -> void:
	var setting = AppSettings.new()	
	# 这是光子云中国区的 AppSettings 设置, 如果要使用中国区，请取消下方注释，并注释掉非中国区的设置
#	setting.app_id_realtime = "<your-photon-app-id-here>" # 替换成你的 realtime appid
#	setting.app_version = "v0.1"
#	setting.fixed_region = "cn"
#	setting.use_name_server = true
#	setting.server = "ns.photonengine.cn"
	
	# If your are not in China, use setting as below.
	setting.app_id_realtime = "<your-photon-app-id-here>" # Replace as your realtime appid.
	setting.fixed_region = "eu" 	# Default is "eu", you can replace it , such as "us", "au" and so on.
					# Or remove this line to let your client find the best region automatically( but I have not test it , because I'm in China and can't connect other region).
	
	connect_using_settings(setting)
	
# 每帧处理网络
func _physics_process(delta: float) -> void:
	service()

# 连接到服务器时加入房间
func _on_connected_to_master()->void:
	var params = EnterRoomParams.new()
	params.room_name = "ping_test_room"
	params.room_options = RoomOptions.new()
	params.room_options.max_players = 2 # 限定两名玩家，只做 ping test
	op_join_or_create_room(params)
	
var ping_start:int
func _on_room_joined()->void:
	print("进入房间")
	# 由后加入的玩家向房主进行测试
	if not self.local_player.is_master_client:
		# 记录 开始时间戳
		ping_start = OS.get_ticks_msec()
		# 发送
		if not op_raise_event(0,"",RaiseEventOptions.Prefeb.DEFAULT,SendOptions.Prefeb.SEND_RELIABLE):
			printerr("发送失败")

var timeout := 1.0
func _process(delta: float) -> void:
	if ping_start != 0:
		timeout -= delta
		if timeout <=0:
			var interval := OS.get_ticks_msec() - ping_start
			if interval > 1000:
				printerr("-- 超过 %s ms 未接受到回复--"%interval)
			timeout = 1
			
func _on_event_received(event_data: EventData)->void:
	if event_data.code == 0:
		# 回复
		if not op_raise_event(1,"",RaiseEventOptions.Prefeb.DEFAULT, SendOptions.Prefeb.SEND_RELIABLE):
			printerr("回复失败")
	elif event_data.code == 1:
		# 接收回复
		print("与房主往返延迟: %d ms"%(OS.get_ticks_msec() - ping_start))
		ping_start = 0
		# 2秒后再次发送
		yield(get_tree().create_timer(2.0),"timeout")
		# 记录 开始时间戳
		ping_start = OS.get_ticks_msec()
		# 发送
		if not op_raise_event(0,"",RaiseEventOptions.Prefeb.DEFAULT,SendOptions.Prefeb.SEND_RELIABLE):
			printerr("发送失败")


	

