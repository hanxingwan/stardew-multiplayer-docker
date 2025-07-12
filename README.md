# 星露谷物语多人游戏Docker Compose

该项目旨在尽可能简单地自动启动星露谷物语多人游戏服务器。



## 更新记录
* 更新 dockerfile 支持读取本地的文件去构建镜像（下载太慢的问题,可以手动下载好放在docker/install_packages文件下 分别为:dotnet.tar.gz, nexus.zip 和 Stardew_1.6.15.tar.gz）
* 更新Alwayer on server 版本 （出货问题）
* 更新chatcommands
* 更新环境变量不可读的问题
* 更新镜像配置挂载（现在会暴露出mods文件夹）


## 设置

### Docker-Compose
 
```
git clone https://github.com/printfuck/stardew-multiplayer-docker

docker compose up
```

### 后台运行
```
docker compose up -d
```
### Ansible !已弃用!

创建一个包含您的主机的清单文件

```
ansible -i <your_inventori> playbook.yml
```

### Terraform（使用Hetzner Cloud）!已弃用!

在`terraform/vars.auto.tfvars`中输入您的API令牌，并根据您的喜好修改`main.tf`中的资源部分，然后运行以下脚本：

```
./terra.sh
```

## 游戏设置

最初，您必须通过VNC或Web界面创建或加载游戏。之后，每次重新启动或重建容器时，自动加载模块都会跳转到先前加载的保存游戏。自动加载模块的配置文件默认被挂载为卷，因为它保留了正在进行的保存游戏的状态，但您也可以将现有的保存游戏复制到`Saves`卷中，并在环境变量中定义保存游戏的名称。

### VNC

使用Windows上的`TightVNC`或任何Linux发行版上的`vncviewer`等VNC客户端连接到服务器。您可以在`.env`文件中修改VNC端口和IP地址以及密码等等。

### Web界面 

容器内的端口5800上有一个Web界面。这比仅有VNC界面更容易访问。虽然您将被要求输入VNC密码，但我不建议将端口暴露给外部世界。

![img](https://store.eris.cc/uploads/859865e1ab5b23fb223923d9a7e4806b.PNG)

## 工作原理

游戏将从我的服务器上拉取（我假设您已经拥有游戏 - 因为您正在寻找多人游戏 - 所以请不要从那里剥离它），并且在构建容器时，将从Github上拉取模组加载器（SMAPI）。您可以使用`docker-compose.yml`文件中的环境变量来控制模组的设置。

## 使用的模组

* [自动加载游戏](https://www.nexusmods.com/stardewvalley/mods/2509)
* [始终在线](https://community.playstarbound.com/threads/updating-mods-for-stardew-valley-1-4.156000/page-20#post-3353880)
* [无限玩家](https://www.nexusmods.com/stardewvalley/mods/2213)
* 还有一些...

## 故障排除

### 控制台中的错误消息

通常，您应该能够忽略那里的任何消息。如果游戏无法启动或出现任何错误，您应该寻找类似“无法打开显示”的消息，这很可能表明权限错误。

### VNC

通过VNC访问游戏，以便最初加载或启动预生成的保存游戏。您可以从那里控制服务器或编辑配置文件夹中的config.json文件。

### 性能

我建议使用至少四个逻辑CPU和4GB内存的VPS/机器，否则会出现严重的卡顿。我认为，对于两到四个玩家，可以接受的最低配置是两个逻辑CPU和1GB内存。


## 感谢
 - 感谢Novex的精彩配置脚本和jlesage的天才基础镜像，现在看起来好多了
 - 感谢 printfuck 的配置文件
