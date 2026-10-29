# 源自[VIKINGYFY的OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI)
自用云编译[ImmortalWrt固件](https://github.com/immortalwrt/immortalwrt)

包含[Passwall插件](https://github.com/Openwrt-Passwall/openwrt-passwall)以及[dae插件](https://github.com/daeuniverse/openwrt-packages)，支持IPv6。

长期支持设备：x64虚拟机、Cudy TR3000 256m + F50、GL-MT3600BE + F50。

#### PVE8.0以上使用EFI，需要关闭安全启动，且磁盘镜像不能放在zfs上，在zfs上不能使用EFI

![image](https://github.com/shenlijun/OpenWRT-CI/blob/main/PVE.png)

# 目录简要说明：

Depends.txt——环境依赖列表

Scripts——自定义脚本

Config——自定义配置

workflows——自定义CI配置
