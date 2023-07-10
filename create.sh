#!/bin/bash

# 创建 DEB 项目

# 项目名
PROJECT_NAME=$1
if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME="sample"
fi

echo "Create Project: $PROJECT_NAME"
echo ""

mkdir -p project/DEBIAN/
echo "+ Create DEBIAN files..."
echo "/etc/opt/apps/$PROJECT_NAME/project.env" >project/DEBIAN/conffiles
echo "- conffiles done." # 创建配置文件

echo "Package: $PROJECT_NAME
Version: 0.0.1
Architecture: armhf
Section: embedded
Priority: optional
Maintainer: apps.com
Contact: apps.com
Description: apps $PROJECT_NAME." >project/DEBIAN/control
echo "- control done." # 创建说明文件

echo "#!/bin/bash
# 安装完成后所需的配置工作, 一个软件包安装或升级完成后，postinst 脚本驱动命令, 启动或重起相应的服务

echo \"Running postinst ...\"

exit 0" >project/DEBIAN/postinst
echo "- postinst done."

echo "#!/bin/bash
# 修改相关文件或连接, 和/或卸载软件包所创建的文件

echo \"Running postrm ...\"

exit 0" >project/DEBIAN/postrm
echo "- postrm done."

echo "#!/bin/bash
# 解压前执行的脚本, 为正在被升级的包停止相关服务,直到升级或安装完成

echo \"Running preinst ...\"

exit 0" >project/DEBIAN/preinst
echo "- preinst done."

echo "#!/bin/bash
# 停止一个软件包的相关进程, 要卸载软件包的相关文件前执行

echo \"Running prerm ...\"

systemctl disable $PROJECT_NAME

exit 0" >project/DEBIAN/prerm
echo "- prerm done."

echo ""
echo "+ DEBIAN Done."

echo ""
echo "+ Create env..."

mkdir -p "project/etc/opt/apps/$PROJECT_NAME"
echo "DEBUG=0" >project/etc/opt/apps/$PROJECT_NAME/project.env

echo ""
echo "+ Create systemd.service..."
echo ""
mkdir -p "project/opt/apps/lib/systemd"

echo "[Unit]
Description=$PROJECT_NAME
#After=xxx.service
#Requires=xxx.service

[Service]
ExecStart=/opt/apps/bin/$PROJECT_NAME

[Install]
WantedBy=multi-user.target" >project/opt/apps/lib/systemd/$PROJECT_NAME.service

echo "All Done."
