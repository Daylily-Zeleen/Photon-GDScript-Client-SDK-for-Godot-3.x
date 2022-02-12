class_name TypedLobbyInfo

## <summary>
## Name of the lobby. Default: null, pointing to the "default lobby".
## </summary>
## <remarks>
## If Name is null or empty, a TypedLobby will point to the "default lobby". This ignores the Type value and always acts as  <see cref="LobbyType.Default"/>.
## </remarks>
var name :String setget _readonly
## <summary>
## Type (and behaviour) of the lobby.
## </summary>
## <remarks>
## An empty or null Name always points to the "default lobby" as special case.
## </remarks>
var type :int setget _readonly
## Count of players that currently joined this lobby.
var player_count:int setget _readonly
## Count of rooms currently associated with this lobby.
var room_count:int setget _readonly


func _to_string() -> String:
	return "[TypedLobbyInfo:%d] '%s' %d rooms:%d players:%d"%[get_instance_id(),name, type, room_count, player_count]



# setget 
func _readonly(v)->void:
	assert(false,"该属性为只读属性")
	
func _init(name:String, type:int , player_count:int, room_count:int) -> void:
	self.name = name
	self.type = type
	self.player_count = player_count
	self.room_count = room_count
