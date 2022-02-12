using System.ComponentModel;
using System;
using System.Collections.Generic;
using System.Threading;
namespace PhotonGodotWraps
{
    /// <summary>
    /// 后台线程配置。
    /// 即使实例化多个 Photon 客户端 且都启用后台线程功能，
    /// 也只会公用一个额外的后台线程。
    /// </summary>
    public class PhotonClientBackgroundThreadConfig //Godot.Reference
    {
        /// <summary>
        /// 是否启用后台发送
        /// </summary>
        /// <value></value>
        public bool BGSend 
        {
            get=>bgSend;
            set
            {
                bgSend = value;
                OnBGConditionChanged();
            }
        } 
        /// <summary>
        /// 是否启用后台接收分配
        /// </summary>
        /// <value></value>
        public bool BGDispatch 
        {
            get=>bgDispatch;
            set
            {
                bgDispatch = value;
                OnBGConditionChanged();
            }
        }

        /// <summary>
        /// 是否启动单次发送
        /// 通常都需要全部发送
        /// 如果你将其设置为 true, 请确保你清楚在做什么。
        /// </summary>
        /// <value>
        /// true 每次发送只会发送最多1个数据包
        /// false 每次发送会将本地缓冲的所有发送指令全部发送 
        /// </value>
        public bool SendSingle {get;set;} = false;
        /// <summary>
        /// 是否启动单次接收分配
        /// 通常都需要全部分配
        /// 如果你将其设置为 true, 请确保你清楚在做什么。
        /// </summary>
        /// <value>
        /// true 每次只会分配一个接收到的指令
        /// false 每次发送会将本地缓冲的所有接受指令全部分配
        /// </value>
        public bool DispatchSingle {get;set;} = false;

        /// <summary>
        /// 发送间隔(单位 ms)
        /// </summary>
        /// <value>
        /// 默认 50 ms
        /// 必须大于0，推荐范围为 20 ~ 50 ms。
        /// 如果不在这个范围内，请确保你的服务器、房间等相关配置不会导致响应超时。
        /// </value>
        public int MsSendInterval 
        {
            get=>msSendInterval;
            set { if(value>0)msSendInterval =value; else Godot.GD.PushError("MsSendInterval must greater than 0."); }
        }
        /// <summary>
        /// 接收分配间隔(单位 ms)
        /// </summary>
        /// <value>
        /// 默认 50 ms
        /// 必须大于0，推荐范围为 20 ~ 50 ms。
        /// 如果不在这个范围内，请确保你的服务器、房间等相关配置不会导致响应超时。
        /// </value>
        public int MsDispathcInterval 
        {
            get => msDispathcInterval;
            set { if(value>0)msDispathcInterval =value; else Godot.GD.PushError("MsDispathcInterval must greater than 0."); }
        }

        private bool bgSend = false;
        private bool bgDispatch = false;


        private int msSendInterval = 50;
        private int msDispathcInterval = 50;
        internal PhotonClientBackgroundThreadConfig(Func<bool> sendDelegate, Func<bool> dispatchDelegate)
        {
            this.sendDelegate = sendDelegate;
            this.dispatchDelegate = dispatchDelegate;
            PhotonBackgroundThreadManager.Instance.AddConfig(this);
        }
        ~ PhotonClientBackgroundThreadConfig()
        {
            PhotonBackgroundThreadManager.Instance.RemoveConfig(this);
        }


        private Func<bool> sendDelegate ;//= new Func<bool>();
        private Func<bool> dispatchDelegate ; 
        private int msLastSendTick ;
        private int msLastDispatchTick ;


        internal Action OnBGConditionChanged;
        
        internal void Run()
        {
            if (BGSend && (Environment.TickCount - msLastSendTick) > MsSendInterval)
            {
                if (SendSingle) sendDelegate();
                else while(sendDelegate());
                msLastSendTick = Environment.TickCount;
            }
            
            if (BGDispatch && (Environment.TickCount - msLastDispatchTick) > MsDispathcInterval)
            {
                if (DispatchSingle) dispatchDelegate();
                else while(dispatchDelegate());
                msLastDispatchTick = Environment.TickCount;
            }
        }
    }
    
    
    internal class PhotonBackgroundThreadManager : BackgroundWorker
    {
        // 单例
        internal static PhotonBackgroundThreadManager Instance = new PhotonBackgroundThreadManager(); 
        private PhotonBackgroundThreadManager()
        {
            WorkerSupportsCancellation = true;
            WorkerReportsProgress = false;
        }

        ~PhotonBackgroundThreadManager()
        {
            if (!CancellationPending)
            {
                CancelAsync();
                Godot.GD.Print("CancelAsync");
            }
        }
        private List<PhotonClientBackgroundThreadConfig> configs = new List<PhotonClientBackgroundThreadConfig>();



        internal void AddConfig(PhotonClientBackgroundThreadConfig config)
        {
            if (!configs.Contains(config))
            {
                config.OnBGConditionChanged += OnBGConditionChanged;
                configs.Add(config);
                OnBGConditionChanged();
            }
        }
        internal void RemoveConfig(PhotonClientBackgroundThreadConfig config)
        {
            if (configs.Contains(config)) 
            {
                config.OnBGConditionChanged -= OnBGConditionChanged;
                configs.Remove(config);
                OnBGConditionChanged();
            }
        }

        // 检查后台线程的开启状态
        internal void OnBGConditionChanged()
        {
            foreach (var config in configs)
            {
                if (config.BGSend || config.BGDispatch) // 存在需要后台线程的配置
                {
                    if(!IsBusy) RunWorkerAsync();
                    return;
                }
            }

            // 没有一个配置要求后台线程运行, 请求取消
            if (!CancellationPending)
            {
                CancelAsync();
            }
        }

        protected override void OnRunWorkerCompleted(RunWorkerCompletedEventArgs e)
        {
            base.OnRunWorkerCompleted(e);
            if(e.Error != null) Godot.GD.PrintErr("后台线程抛出异常");
            if (e.Cancelled)
            {
                // 由于后台线程异步操作，确认取消后需再次检查是否有启动需求
                OnBGConditionChanged();
                Godot.GD.Print("cancled");
            }
            else 
            {
                Thread.Sleep(5);
                if(!IsBusy) RunWorkerAsync();
            }//Godot.GD.PrintErr("后台线程非取消式结束");
        }
        protected override void OnDoWork(DoWorkEventArgs e)
        {
            // base.OnDoWork(e);
            if (CancellationPending)
            {
                e.Cancel = true;
                return;
            }
            foreach (var config in configs)
            {
                config.Run();
            }
        }
    }
}