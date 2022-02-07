# Photon GDScript Client SDK for Godot3.X
  A warps of Photon C# Client SDK for GDScript.Contain Photon Realtime Client and Photon Chat Client.    
  Because of the lack of time, I can't complete a perfect description in both script and document.    
  But the usage of this SDK is similar to Photon C# Client SDK, basically you can refer to the [official document](https://doc.photonengine.com/en-us/realtime/current/getting-started/realtime-intro).    
  
  The most importance class are in "addons\addons\PhotonGDScriptClientSDK\core", the others data class and object represent class are in "addons\addons\PhotonGDScriptClientSDK\warps"

# How to use:
  You must use Godot 3.x mono. 
  1. Install this addon like others addon. 
  2. Build you project at least once to generate the .csproj file.
  3. Include Photon C# SDK's .dll to you C# project.
  4. Enable this addon.
  If you do not how to include C# SDK's .dll, you can add follow text as a xml tiem under "Project" item in .csproj file:
  for debug：  
  
    <ItemGroup>
	    <Reference  Include="addons\\PhotonGDScriptClientSDK\\dependents\\libs\\Debug\\netstandard2.0\\Photon-NetStandard.dll" />
    </ItemGroup> 

  for release：
  
    <ItemGroup>
	    <Reference  Include="addons\\PhotonGDScriptClientSDK\\dependents\\libs\\Release\\netstandard2.0\\Photon-NetStandard.dll" />
    </ItemGroup> 
    
# The differences between C# SDK are as follow:    
1. The key word 'LoadingBalancing' in C# SDK is equal to 'Realtime' in GDScript SDK( the reson of using 'LoadingBalancing' in C# SDK is to compatible the old implementation, but now is a new implementation for GDScript , so I replace it by 'Realtime' in GDScript SDK ).
2. You should access Photon's enum by Photon.<EnumName>.<EnumItemName> in GDScript SDK.
3. Player, Room and RoomInfo in C# SDK are renamed as PhotonPlayer, PhotonRoom and PhotonRoomInfo.
3. You should access data class's default or prefeb static intance by <DataClassName>.Prefeb.<Default/PrefebName>.
4. The Callback Interfaces' methods and Client Events in C# SDK are implement in GDScript SDK as follow:
    - Overridable methods( are called realtime, used in extends case);
    - Signals(are used in all case, are called later than Overridable methods );
    - Group's objects callback methods( are called defer as default, you can code '(RealtimeClient/ChatClient).notify_when_idle = false' to set they called realtime, but they are still called later than signal);
5. The argument's type of callback 'web_rpc_responsed' in GDScript is different to C# SDK, it is WebRpcResponse( In C#, it is OperationResponse). 
6. You can't access the PhotonPeer( a underlying implementation for RealtimeClient and ChatClient ), you don't need to access it in common usage. If you has necessary to access it，please commit an issue to describe the necessity. 
7. Because this SDK is a warps of C# SDK, in order to maximaize performance, I set the property PhotonPeer.ReuseEventInstance to true. You can control it by in RealtimeClient.reuse_event_instance and ChatClient.reuse_event_instance in GDScript version. 
8. As the same reson as above, the instances which their class are named ErroInfo, OperationResponse and WebRpcResponse, which got from RealtimeClient and ChatClient, are always the same intance, event if got from defferent Client instance. If you need to cache infos which in these intances, please extract infos every time you get them.
9. I‘m not expose the property ChatClient.UseBackgroundWorkerForSending for GDSctipt SDK. Instead, I implement a backgound thread system to send outgoing commands and dispatch incoming commands for both RealtimeClient and ChatClient:
    - use 'bg_send' to control the ability of send outgoing commands;
    - use 'bg_dispatch' to control the ability of dispatch incoming commands;
    - use 'bg_send_interval_ms' to control the interval of send outgoing commands( in millisecond)；
    - use 'bg_dispatch_interval_ms' to control the interval of dispatch incoming commands( in millisecond)；
    - use 'bg_send_single' to control whether send all cached outgoing commands or send single cached outgoing commond per send cycle( default false, if you modiy it, please make sure you know what you're doing).
    - use 'bg_dispatch_single' to control whether dispatch all cached incoming commands or dispatch single cached incoming commond per dispatch cycle( default false, if you modiy it, please make sure you know what you're doing).
    - all RealtimeClient and ChatClient instances are useing the same background thread to manipulate, even if you game have multiple Clients instance.
 10. I expose the methods send_outgoing_commands() and dispatch_incoming_commands() from PhotonPeer. Please to learn how to use them if you need to control the timing of send and dispatch commonds flexibly. Commonly, if you don't want to background thread system, just call service() regularly to process netcode.

  
# Additional：
  Again, because of the lack of time, I can't do many test for this SDK. I hope everybody can participate in the development of this SDK. If you encounter bug, please try to fix it or improve it, then submit a pull request. 
  In addition，I will be grateful if you try to fix bugs or make document.
  
# TODO:
  1. Make doc.
  2. Waiting for Godot 4.0's GDExtension to build GDScrip 2.0 SDK base on cpp.

# Other:
To get the Photon C# Client SDK in Photon official websit, you must to sign up to download it. But I integrate it to this sdk, if this way may cause some legal issues，please notify me, I will remove C# SDK files and add description for how to integrate it manually.

  =======================================================================

# Photon GDScript Client SDK for Godot3.X

用于GDScript 的 Photon 客户端 SDK, 具体实现是将 C# SDK 的重要对象包装为Godot识别的对象给 GDScript 进行对接。包含光子实时客户端(Photon Realtime Client) 和 光子聊天客户端( Photon Chat Client) 。

由于时间不够，我无法在脚本和文档中做完善的描述,但是这个SDK的用法与光子C#客户端SDK类似，基本上你可以参考[官方文档](https://doc.photonengine.com/en-us/realtime/current/getting-started/realtime-intro)进行开发.

最重要的类在“addons\addons\PhotonGDScriptClientSDK\core”中，另外一些数据类和对象表示类在“addons\addons\PhotonGDScriptClientSDK\warps”中

# 如何使用:
  你必须使用 Godot 3.x mono. 
  1. 像其他插件一样安装该插件； 
  2. 为了生成 .csproj 文件，你必须只少构建一次你的项目.
  3. 将C# SDK 的 .dll 包含到 C# project.
  4. 启用该插件.
  如果你不清楚如何包含C# SDK 的 .dll,你可以把以下内容作为一个xml项目置于 .cspro 中的 “Project”项目下：
  
  调试用：  
     
    <ItemGroup>
      <Reference  Include="addons\\PhotonGDScriptClientSDK\\dependents\\libs\\Debug\\netstandard2.0\\Photon-NetStandard.dll" />
    </ItemGroup> 

  发布用：
  
    <ItemGroup>
      <Reference  Include="addons\\PhotonGDScriptClientSDK\\dependents\\libs\\Release\\netstandard2.0\\Photon-NetStandard.dll" />
    </ItemGroup> 
# 与 C# SDK 之间的区别如下：

1. C# SDK中的关键字“LoadingBalling”等同于GDScript SDK中的“Realtime”（在C# SDK中使用“LoadingBalling”的原因是为了兼容旧的实现，但现在是GDScript的新实现，所以我用GDScript SDK中直接使用"Realtime"进行描述）。

2.你应该通过 Photon.<EnumName>.<EnumItemName> 来访问 Phton 的枚举。

3. C# SDK中的 Player、Room 和 RoomInfo 在 GDScript 中被重命名为 PhotonPLayer、PhotonRoom 和 PhotonRoomInfo。

3. 你应该通过 <DataClassName>.Prefeb.<Default/PrefebName> 来访问数据类的预置对象, 等同于 C# SDK 的中的相关类的预置静态变量（ 如 C# SDK 中的 TypedLobby.Default 等同于 GDScript SDK 中的 TypedLobby.Prefeb.Default)。

4. C# SDK 的回调接口中的方法 和 客户端事件在GDScript SDK中实现如下：

    - 可重写的方法（实时调用，用于扩展客户端情况）；

    - 信号（适用于任何在可重写方法之后调用）；

    - 组对象回调方法（默认情况下称为延迟调用，您可以通过设置”(RealtimeClient/ChatClient).notify_when_idle = false"，以让它们在事实调用，但它们仍然在信号之后被调用）；

5. GDScript中，回调“web_rpc_responsed"的参数类型是 WebrpResponse, 不同于C# SDK（在C#中，它是OperationResponse）。

6. 你不能访问 PhotonPeer（RealtimeClient和ChatClient的底层实现），常用情况下你不需要访问它。如果您有必要访问它，请提交issue来描述其必要性。

7. 因为这个SDK是C# SDK的包装，为了尽量提高性能，我将 PhotonPeer.ReuseEventInstance 默认设置为 true 。在 GDScript SDK 中你可以通过 RealtimeClient.reuse_event_instance 和 ChatClient.reuse_event_instance 来控制它。

8. 遇上一条相同的原因，从 RealtimeClient和ChatClient 获取到的类名为ErroInfo、OperationResponse 和 WebRPResponse 的实例总是同一个对象, 即使是从不同的客户端实力对象中获取，同样的数据类型总是同一个对象。如果您需要缓存其中的信息，请在每次获取时提取这些信息。

9. 我没有将属性 ChatClient.UseBackgroundWorkerForSending 暴露给 GDSctipt SDK。我实现了一个后台线程系统来取代它, 用于 RealtimeClient 和 ChatClient 在后台线程中发送传出命令和调度传入命令：
    - 使用“bg_send”控制是否通过后台线程发送传出命令；

    - 使用“bg_调度”控制是否通过后台线程调度传入命令；

    - 使用“bg_send_interval_ms”控制发送传出命令的间隔（毫秒）

    - 使用“bg_dispatch_interval_ms”控制调度传入命令的间隔（毫秒）

    - 使用“bg_send_single”来控制是一次性发送所有被缓存的传出命令，还是每个发送周期发送单个被缓存的传出命令（默认为false，如果您修改了它，请确保您知道自己在做什么）。

    - 使用“bg_dispatch_single”控制是一次性调度所有被缓存的传入命令，还是每个调度周期调度单个被缓存的传入commond（默认为false，如果您修改它，请确保您知道自己在做什么）。
    
    - 所有的 RealtimeClient 和 ChatClient 实例在你应用中公用一个后台线程。
10. 我将 send_outgoing_commands() 和 dispatch_incoming_commands() 从 PhotonPeer 中暴露给 GDScript SDK 中的 RealtimeClient 和 ChatClient，以让你灵活控制 发送 和 调度 的时机，但你必须学会如何准确的使用它们以避免错误。通常情况下，如果你不希望通过后台线程来发送和调度命令，只需要以你的方式有规律的频繁调用 RealtimeClient.service() 和 ChatClient.service() 即可。




# 更多：

同样，由于时间不够，我不能为这个SDK做很多测试。我希望大家都能参与这个SDK的开发。如果遇到错误，请尝试修复或改进，然后提交请求。

此外，如果您尝试修复错误或制作文档，我将不胜感激。



# 待办事项：

1.完善文档。

2.等待Godot 4.0的GDExtension，在cpp基础上构建GDScrip 2.0 SDK。



# 其他：
要在光子官方网站上获得光子C#Client SDK，您必须注册登录并下载。但我将其集成到这个sdk中，如果这种方式可能会引起一些法律问题，请通知我，我将删除C# sdk相关文件，并添加如何手动集成的说明。



