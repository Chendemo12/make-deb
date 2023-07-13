# make-deb

- 创建`deb`包的模板文件；
- 对于可执行程序：被固定安装到`/opt/apps/bin/`目录；
- 对于源码程序：被固定安装到`/opt/apps/NAME/`目录；
- 程序配置文件被固定安装到`/etc/opt/apps/NAME/`目录；

## Usage

- 对于需要编译的`go`项目来说，可以将`go`源码放置在与`project`同级的任意目录，如`src`, 同时在`packer.sh`同级目录下创建编译脚本`build.sh`；
- 对于源码不是的`python`项目，可将源码放置在`project`的一级目录下；
- `deb`打包时，尽会复制`project`目录;
