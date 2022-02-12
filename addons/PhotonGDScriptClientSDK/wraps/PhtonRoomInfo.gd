## 不应自行实例化该类
class_name PhtonRoomInfo


## Used in lobby, to mark rooms that are no longer listed (for being full, closed or hidden).
var removed_from_list :bool setget _readonly
## <summary>Read-only "cache" of custom properties of a room. Set via Room.SetCustomProperties (not available for RoomInfo class!).</summary>
## <remarks>All keys are string-typed and the values depend on the game/application.</remarks>
## <see cref="Room.SetCustomProperties"/>
var custom_properties :Dictionary setget _readonly

## The name of a room. Unique identifier for a room/match (per AppId + game-Version).
var name :String setget _readonly

## Count of players currently in room. This property is overwritten by the Room class (used when you're in a Room).
var player_count:int setget _readonly

## <summary>
## The limit of players for this room. This property is shown in lobby, too.
## If the room is full (players count == maxplayers), joining this room will fail.
## </summary>
## <remarks>
## As part of RoomInfo this can't be set.
## As part of a Room (which the player joined), the setter will update the server and all clients.
## </remarks>
var max_players:int setget _readonly

## <summary>
## Defines if the room can be joined.
## This does not affect listing in a lobby but joining the room will fail if not open.
## If not open, the room is excluded from random matchmaking.
## Due to racing conditions, found matches might become closed even while you join them.
## Simply re-connect to master and find another.
## Use property "IsVisible" to not list the room.
## </summary>
## <remarks>
## As part of RoomInfo this can't be set.
## As part of a Room (which the player joined), the setter will update the server and all clients.
## </remarks>
var is_open:bool setget _readonly

## <summary>
## Defines if the room is listed in its lobby.
## Rooms can be created invisible, or changed to invisible.
## To change if a room can be joined, use property: open.
## </summary>
## <remarks>
## As part of RoomInfo this can't be set.
## As part of a Room (which the player joined), the setter will update the server and all clients.
## </remarks>
var is_visible:bool setget _readonly

## Returns most interesting room values as string.
func _to_string() -> String:
	return "[PhotonRoomInfo:%d] %s"%[get_instance_id(),"'%s' %s %s %d/%d" % [name,
			"visible" if is_visible else "hidden",
			"open"if is_open else "closed", player_count, max_players] ]

## Returns most interesting room values as string, including custom properties.
func to_string_full()->String:
	return _to_string() + " \n\tcustom_properties:"+ JSON.print(custom_properties,"\t")







# setget
func _readonly(v)->void:
	assert(false,"该属性为只读属性")


func _init(removed_from_list:bool, custom_properties:Dictionary, name:String, 
		player_count:int, max_players:int, is_open:bool, is_visible:bool) -> void:
	self.removed_from_list = removed_from_list
	self.custom_properties = custom_properties
	self.name = name
	self.player_count = player_count
	self.max_players = max_players
	self.is_open = is_open
	self.is_visible = is_visible
	
