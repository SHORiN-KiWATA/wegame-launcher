# wegame-launcher
A simple WeGame laucncher for Linux.

用于在 Linux 上运行 WeGame 的简易启动器（包装器），开箱即用。

所有文件都会放在`~/.wegame-launcher`中；缓存文件放在`~/.cache/wegame-launcher`。

首次使用会自动下载 WE-Proton 和 Steam Linux Runtime（Proton 要在这个运行时里运行，否则音视频解码等会缺库）；电脑上已有 umu 或 Steam 下载的运行时会直接复用。

要在 WeGame 会话里用「TUN 模式」的加速器（如雷神）时，在设置里打开「独立网络命名空间」（需要 `passt`）：整个会话跑在自己的网络命名空间里，WE-Proton 内置的 wintun 能在不需要 root 的情况下建虚拟网卡，加速器选好线路模式点加速即可；会话之外的系统网络不受影响。

如果 WeGame 在使用时卡死，可以用启动器强制退出后宠

![](./pics/showcase.png)

## 许可证

- GPL v3

- 项目内第三方图片资源版权归版权方所有
