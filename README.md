# [源自VIKINGYFY的OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI)
自用云编译[ImmortalWrt固件](https://github.com/immortalwrt/immortalwrt)

仅包含[homeproxy](https://github.com/immortalwrt/homeproxy)、UPnP 以及 uugamebooster。

[支持Intel x550自动协商2.5G&5G速率](https://github.com/shenlijun/openwrt-x550-nbase-t)

#### PVE8.0上需要使用非EFI固件，否则报错无法读取硬盘

# 固件简要说明：

固件每天早上4点自动编译，X64与MT1300两种

# 目录简要说明：

Depends.txt——环境依赖列表

Scripts——自定义脚本

Config——自定义配置

workflows——自定义CI配置
