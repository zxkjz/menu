#!/bin/bash

# 显示菜单
show_menu() {
    echo "===== 脚本菜单 ====="
    echo "1. 下载pm2"
    echo "2. 续期脚本下载"
    echo "3. 退出"
    echo "===================="
}

# 下载pm2
download_pm2() {
    echo "正在下载pm2脚本..."
    bash <(curl -s https://raw.githubusercontent.com/k0baya/alist_repl/main/serv00/install-pm2.sh)
    if [ $? -eq 0 ]; then
        echo "pm2脚本下载成功！"
    else
        echo "pm2脚本下载失败！"
    fi
}

# 创建auto-renew.sh脚本
create_auto_renew_script() {
    echo "创建auto-renew.sh脚本..."

    # 提示用户输入密码
    read -p "请输入密码: " password

    # 提示用户输入用户名
    read -p "请输入用户名: " username

    # 提示用户输入服务器地址
    read -p "请输入服务器地址: " server_address

    # 将用户输入填入脚本中
    cat > auto-renew.sh << EOF
#!/bin/bash

while true; do
  sshpass -p '$password' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $username@$server_address "exit" &
  sleep 259200  # 30天为259200秒
done
EOF

    # 赋予权限
    chmod +x auto-renew.sh
    echo "auto-renew.sh脚本创建成功！"
}

# 主循环
while true; do
    show_menu

    # 提示用户选择
    read -p "请选择操作（输入1-3）: " choice
    echo

    case $choice in
        1)
            download_pm2
            ;;
        2)
            create_auto_renew_script
            ;;
        3)
            echo "退出终端连接"
            exit
            ;;
        *)
            echo "无效的选项，请重新输入！"
            ;;
    esac

    echo
done
