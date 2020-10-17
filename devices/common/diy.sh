#!/bin/bash
#=================================================
# Description: Build OpenWrt using GitHub Actions 
# Lisence: MIT
# 参考以下资料：
# Frome: https://github.com/garypang13/Actions-OpenWrt
# Frome: https://github.com/P3TERX/Actions-OpenWrt
# Frome: https://github.com/Lienol/openwrt-actions
# Frome: https://github.com/svenstaro/upload-release-action
# By LEDE 2020 https://ledewrt.com
# https://github.com/ledewrt
#=================================================
#添加固件版本描述。
rm -Rf package/default-settings/files/zzz-default-settings
rm -Rf package/lean/luci-app-ssr-plus
#rm -Rf package/diy/OpenAppFilter
rm -Rf package/diy/luci-app-adguardhome
# 修改登陆地址
sed -i 's/192.168.1.1/192.168.168.1/g' package/base-files/files/bin/config_generate
# 内核显示增加自己个性名称（281677160 build $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些为后期增加）
sed -i "s/OpenWrt /LedeWrt N $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt From Lienol /g" package/default-settings/files/zzz-default-settings
# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
#添加luci版本。
sed -i 's/"18.06 Lienol"/"openwrt-19.07 branch "/g' feeds/luci/luci.mk
# 关闭禁止解析IPv6 DNS 记录
sed -i '/option filter_aaaa 1/d' package/network/services/dnsmasq/files/dhcp.conf

#修改网络连接数
#sed -i 's/net.netfilter.nf_conntrack_max=65535/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#添加自定义插件1。
git clone https://github.com/vernesong/OpenClash.git package/diy/luci-app-openclash
git clone https://github.com/garypang13/openwrt-adguardhome.git package/diy/openwrt-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git  package/diy/luci-app-adguardhome
sed -i '/resolvfile=/d' package/diy/luci-app-adguardhome/root/etc/init.d/AdGuardHome
sed -i 's/DEPENDS:=/DEPENDS:=+AdGuardHome /g' package/diy/luci-app-adguardhome/Makefile
#argon主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git  package/diy/luci-theme-argon

git clone https://github.com/ledewrt/luci-app-eqos.git  package/diy/luci-app-eqos
git clone https://github.com/jefferymvp/luci-app-koolproxyR.git  package/diy/luci-app-koolproxyR
git clone https://github.com/tty228/luci-app-serverchan.git package/diy/luci-app-serverchan
#git clone https://github.com/destan19/OpenAppFilter.git package/diy/OpenAppFilter
#git clone https://github.com/fw876/helloworld.git package/diy/luci-app-ssr-plus
git clone https://github.com/siwind/luci-app-ttyd.git package/diy/luci-app-ttyd
#git clone https://github.com/docker/docker-ce.git package/diy/luci-app-docker-ce
cd package
svn co https://github.com/xiaorouji/openwrt-package/trunk/lienol/luci-app-passwall

cd -
./scripts/feeds update -a
./scripts/feeds install -a

#date=`date +%Y.%m.%d`
#sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='LedeWrt N%C From Lienol'/g" package/base-files/files/etc/openwrt_release
#sed -i "s/# REVISION:=x/REVISION:= $date/g" include/version.mk
