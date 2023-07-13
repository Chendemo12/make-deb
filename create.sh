#!/bin/bash
# 创建 DEB 项目

# 删除目录
delete_directories() {
  # 接受待删除的目录名数组作为参数
  local dirs=("$@")

  # 遍历目录数组
  for dir in "${dirs[@]}"; do
    # 检查目录或文件是否存在
    if [[ -e "$dir" ]]; then
      # 删除目录或文件
      rm -rf "$dir"
    fi
  done
}

# Debian控制文件
create_control_file() {
  local text="
    Package: $PROJECT_NAME
    Version: 0.0.1
    Architecture: $ARCH
    Section: utils
    Priority: optional
    Maintainer: apps.com
    Contact: apps.com
    Description: $PROJECT_NAME app.
  "

  echo "$text" | sed 's/^ *//g' | tail -n +2 >project/DEBIAN/control
  echo "- control done."
}

# 创建配置文件
create_conffiles_file() {
  echo "/etc/opt/apps/$PROJECT_NAME/.env" >project/DEBIAN/conffiles
  echo "- conffiles done."
}

create_postinst_file() {
  local text="
    #!/bin/bash
    # 安装完成后所需的配置工作, 一个软件包安装或升级完成后, postinst 脚本驱动命令, 启动或重起相应的服务

    echo \"Running postinst ...\"
    systemctl enable /opt/apps/lib/systemd/${PROJECT_NAME}.service

    exit 0
  "

  echo "$text" | sed 's/^ *//g' | tail -n +2 >project/DEBIAN/postinst
  echo "- postinst done."
}

create_postrm_file() {
  local text="
    #!/bin/bash
    # 修改相关文件或连接, 和/或卸载软件包所创建的文件

    echo \"Running postrm ...\"

    exit 0
  "

  echo "$text" | sed 's/^ *//g' | tail -n +2 >project/DEBIAN/postrm
  echo "- postrm done."
}

create_preinst_file() {
  local text="
    #!/bin/bash
    # 解压前执行的脚本, 为正在被升级的包停止相关服务,直到升级或安装完成

    echo \"Running preinst ...\"

    exit 0
  "

  echo "$text" | sed 's/^ *//g' | tail -n +2 >project/DEBIAN/preinst
  echo "- preinst done."
}

create_prerm_file() {
  local text="
    #!/bin/bash
    # 停止一个软件包的相关进程, 要卸载软件包的相关文件前执行

    echo \"Running prerm ...\"
    systemctl disable ${PROJECT_NAME}.service

    exit 0
  "

  echo "$text" | sed 's/^ *//g' | tail -n +2 >project/DEBIAN/prerm
  echo "- prerm done."
}

create_env_file() {
  mkdir -p project/etc/opt/apps/"$PROJECT_NAME"
  echo "DEBUG=0" >project/etc/opt/apps/"$PROJECT_NAME"/.env

  echo "- envfile done."
}

create_systemd_file() {
  local text="
    [Unit]
    Description=$PROJECT_NAME
    #After=xxx.service
    #Requires=xxx.service

    [Service]
    ExecStart=/opt/apps/bin/$PROJECT_NAME

    [Install]
    WantedBy=multi-user.target
    "

  mkdir -p project/opt/apps/lib/systemd
  echo "$text" | sed 's/^ *//g' | tail -n +2 >project/opt/apps/lib/systemd/"$PROJECT_NAME".service

  echo "- systemd.service done."
}

# 项目名
PROJECT_NAME=$1
if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME="sample"
fi

ARCH=$2
if [[ -z "$ARCH" ]]; then
  ARCH="arm64"
fi

echo "Create Project: '$PROJECT_NAME'"

echo -e "\n+ Create DEBIAN files..."
delete_directories "project/DEBIAN" "project/opt" "project/etc"
mkdir -p project/DEBIAN/
mkdir -p project/opt/apps/bin/

create_conffiles_file
create_control_file
create_postinst_file
create_postrm_file
create_preinst_file
create_prerm_file

echo -e "\n+ Create system files..."
create_env_file
create_systemd_file

echo ""
echo "All Done."
