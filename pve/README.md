PVE挂载硬盘指令如下：注意，所有指令必需区分大小写。

列出主机硬盘ID：

root@pve:~# ls -l /dev/disk/by-id/

所列出硬盘码凡带part1,2,3等此类，为盘下分区，不是整盘。必需复制其part之上的整盘码。如果不带具体硬盘厂商名称，诸如intel 之类的字样，不是物理整盘，不要挂载到虚拟机中。

把硬盘挂载至具体虚拟机：
root@pve:~#qm set 100 --sata1 /dev/disk/by-id/ata-INTEL_SSDSA2BW160G3H_CVPR1322011V160DGN

ata-INTEL_SSDSA2BW160G3H_CVPR1322011V160DGN  这一串就是完整物理硬盘码，是要复制粘贴的内容（带intel字样，即为intel固态硬盘，但不要把宿主盘挂上去，所以要注意仔细观察区分）。指令中  100  为虚拟机ID，即显示在后台左侧的三位编号数字     sata1硬盘通道类型，1为数字序列，也可以是2，3，4，5，随便你。后面则是粘贴的准备挂载的硬盘码。用键盘快捷键无用，必需使用鼠标右键选择粘贴。

断电无法进入PVE后台处理方法，对已经自动随机启动的虚拟机关停。把虚拟机接显示器与键盘即可操作。先用root用户名与密码登陆，再用如下代码

查看虚拟机状态
root@pve:~#pvesh get /cluster/resources
取得虚拟机当前状态
root@pve:~#pvesh get /nodes/pve/qemu/100/status/current
关闭虚拟机
root@pve:~#pvesh create /nodes/pve/qemu/100/status/stop

命令行中的pve为你的总虚拟机节点名称。100为其下虚拟机ID编号。请对号关闭虚拟机，一般就能解决问题了。
