#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    clear
    echo "错误：本脚本需要 root 权限执行。" 1>&2
    exit 1
fi



install_soga(){
	echo "正在安装soga . . ."
	bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
	rm -f /etc/soga/soga.conf
	rm -f /etc/soga/blockList
    echo -e "soga安装完毕，初始化环境已就绪！>> 进入soga初始化对接！"
	shon_online
}

download_trojan(){
	echo "开始安装trojan配置文件 . . ."
	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/Unicorn-Auto/main/conf/trojan-soga.conf -O soga.conf
    echo -e "trojan配置文件已下发完成！"
	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/Unicorn-Auto/main/BlockList
    echo -e "soga审计规则已下发完成！"
    wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/Unicorn-Auto/main/certificates/ip172666023.mobgslb.tbcache.com_chain.crt
    wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/Unicorn-Auto/main/certificates/ip172666023.mobgslb.tbcache.com_key.key
    echo -e "TLS证书配置已下发完成！"
    echo "开始进行soga对接 . . ."
	cd /etc/soga
	printf "请输入节点ID："
	read -r nodeId <&1
	sed -i "s/ID_HERE/$nodeId/" soga.conf
    soga restart
	echo -e "正在重启soga服务端！"
	shon_online
}

add_shenji(){
	echo "正在添加审计 . . ."
    	rm -f /etc/soga/blockList
    	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/unicorn/main/unicorn-config/blockList
        echo -e "soga审计规则已下发完成！"
	shon_online
}

start_unicorn(){
	echo "正在启动soga . . ."
	soga start
	shon_online
}

restart_unicorn(){
	echo "正在重启soga . . ."
	soga restart
	shon_online
}

shon_online(){
echo "请选择您需要进行的操作:"
echo "1) 安装 soga"
echo "2) 配置 trojan"
echo "3) 启动 soga"
echo "4) 重启 soga"
echo "5) 查看 soga状态"
echo "6) 查看 soga日志"
echo "7) 添加审计"
echo "8) 退出脚本"
echo "   Version：3.0.0"
echo ""
echo -n "   请输入编号: "
read N
case $N in
  1) install_soga ;;
  2) download_trojan ;;
  3) start_unicorn ;;
  4) restart_unicorn ;;
  5) soga status ;;
  6) soga log ;;
  7) add_shenji ;;
  8) exit ;;
  *) echo "Wrong input!" ;;
esac 
}

shon_online


#ss


ask_if()
{
    read -p "开启隧道,是否继续？(y/n)" para

    case $para in 
    [yY])
    input_soga
    echo -e "已添加隧道配置~"
    ;;
    [nN])
    sed -i '$a tunnel_enable=false' /etc/soga/soga.conf
    echo -e "已关闭隧道配置~"
    ;;
    *)
    echo "输入错误"
    exit 1
    ;;
    esac # end case
}

input_soga()
{
     sed -i '$a tunnel_enable=true' /etc/soga/soga.conf
     sed -i '$a tunnel_type=ws-tunnel' /etc/soga/soga.conf
     sed -i '$a tunnel_password=3a00afbc-302f-41a5-986c-7bcdda0c83a7' /etc/soga/soga.conf
     sed -i '$a tunnel_method=aes-256-gcm' /etc/soga/soga.conf
     sed -i '$a tunnel_ws_path=/' /etc/soga/soga.conf
}