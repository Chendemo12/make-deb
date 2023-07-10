# sample

## Usage

1. 克隆仓库到自定义目录：

```shell
# 允许get私有仓库
echo "machine gitlab.cowave.com login chenguang.li@cowave.com password passwordpassword" >~/.netrc

export GOSUMDB=off   # Linux
$Env:GOSUMDB = "off" # Windows only

git clone gitlab.cowave.com/gogo/sample

```

2. `CTRL + Shift + R`修改仓库地址`gitlab.cowave.com/gogo/sample`为实际仓库：`gitlab.cowave.com/xxxx/xxxx`;
3. 修改`goproject.toml`文件相关内容；主要包括`server`, `http`; 若需作为第三方库导入，则必须修改版本号为`vx.y.x`

4. （可选）更新依赖`functools`和`flaskgo`：

```shell
go get -u -v gitlab.cowave.com/gogo/flaskgo
go get -u -v gitlab.cowave.com/gogo/functions # 无需手动更新

go mod tidy
go mod vendor

```