extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text""res://addons/Photon/src/"
#const _PhotonRealtimeClient = preload("res://addons/Photon/src/RealtimeClient.cs")
#const _RealtimeClient = preload("res://addons/Photon/gds/RealtimeClient.gd")
#var _client:_PhotonRealtimeClient = _PhotonRealtimeClient.GetNew()

#var a 
#var b :_PhotonRealtimeClient
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var xml := XMLParser.new()
	if xml.open("Photon 3 .x.csproj"):
		pass
