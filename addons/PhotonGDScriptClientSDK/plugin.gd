tool
extends EditorPlugin


const LOADBALANCING_API_PATH := "res://addons/PhotonGDScriptClientSDK/dependents/PhotonLoadbalancingApi/"
const CHAT_API_PATH :="res://addons/PhotonGDScriptClientSDK/dependents/PhotonChatApi/"
const LOADVALANCING_API_FILES_COUNT = 18
const CHAT_API_FILES_COUNT =15

func _enter_tree() -> void:
	add_autoload_singleton("PhotonInitializer","res://addons/PhotonGDScriptClientSDK/PhotonInitializer.gd")
	check()
	
func _exit_tree() -> void:
	remove_autoload_singleton("PhotonInitializer")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_FOCUS_IN:
		check()

func check() -> void:
	if _check() == false:
		printerr("""- Phton SDK Error-
== 如果你的 C# 项目未包含 Photon Sdk 的 dll, 可将以下文本置于你的 .csproj 文件中的 <Project> </Project> 标签之中：
用于调试：
  <ItemGroup>
	<Reference  Include="addons\\PhotonGDScriptClientSDK\\dependents\\libs\\Debug\\netstandard2.0\\Photon-NetStandard.dll" />
</ItemGroup> 

用于发布：
  <ItemGroup>
	<Reference  Include="addons\\PhotonGDScriptClientSDK\\dependents\\libs\\Release\\netstandard2.0\\Photon-NetStandard.dll" />
</ItemGroup> 
==""")
	
func _check()->bool:
	var dir := Directory.new()
	if dir.open("res://") ==OK:
		if dir.list_dir_begin() ==OK:
			var f = dir.get_next()
			var included:=false
			while not f.empty():
				if not f.empty() and not dir.current_is_dir():
					if f.ends_with(".csproj"):
						included = check_csproj_include(dir.get_current_dir().plus_file(f))
						if not included:
							printerr("项目 %s 未包含 Photon Sdk: 根目录下可能存在多个 .csproj 或你的 C# 项目未包含 Photon SDK")
				f = dir.get_next()
			dir.list_dir_end()
			if included :
				if dir.dir_exists(LOADBALANCING_API_PATH) and dir.dir_exists(CHAT_API_PATH):
					if _get_file_count(LOADBALANCING_API_PATH) == LOADVALANCING_API_FILES_COUNT and \
							_get_file_count(CHAT_API_PATH) == CHAT_API_FILES_COUNT:
						return true
				else:
					printerr("目录 'res://addons/PhotonGDScriptClientSDK/dependents/' 下未包含 PhotonLoadbalancingApi 和 PhotonChatApi")
	return false
	
func check_csproj_include(csproj_path:String)->bool:
	if csproj_path.is_abs_path() or csproj_path.is_rel_path():
		var xml := XMLParser.new()
		var open = xml.open(csproj_path) 
		if open == OK:
			while true:
				if xml.read() ==OK:
					if xml.get_node_type() in [XMLParser.NODE_ELEMENT, XMLParser.NODE_ELEMENT_END] :
						if xml.get_node_name() == "Reference":
							for i in xml.get_attribute_count():
								if xml.get_attribute_name(i) == "Include":
									var value:=xml.get_attribute_value(i)
	#								if value.begins_with("addons\\Photon\\dependents\\libs\\"):
									if value.ends_with("Photon-NetStandard.dll") or \
										value.ends_with("Photon-DotNet.dll") or \
										value.ends_with("Photon-Uwp.dll") :
										return true
				else:return false
	return false


func _get_file_count(path:String)->int:
	var dir :Directory = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var count :=0
		var f := dir.get_next()
		while not f.empty():
			if not dir.current_is_dir():
				count +=1
			f = dir.get_next()
		dir.list_dir_end()
		return count
	return 0
