## lvm
- 创建lvm的基本步骤  

1)物理磁盘被格式化为pv，空间被划分为一个个的pe#pv包含pe    
2)不同的pv加入到同一个VG中,(不同PV的PE全部进入到VG的PE池内)#VG包含PV  
3)在VG中传教LV逻辑卷，基于PE创建，（组成LV的PE可能来自不同的物理磁盘）#LV基于PE创建  
4)LV直接可以格式化后挂载使用 #格式化挂载使用  
5)LV的扩充缩减实际上就是增加或减少组成该LV的PE数量，其过程不会丢失原始数据  

- lvm常用的命令  

功能	PV管理命令	VG管理命令	LV管理命令  
scan 扫描	pvscan	vgscan	lvscan  
create 创建	pvcreate	vgcreate	lvcreate  
display显示	pvdisplay	vgdisplay	lvdisplay  
remove 移除	pvremove	vgremove	lvremove  
extend 扩展		vgextend	lvextend  
reduce减少		vgreduce	lvreduce  

- 下面的操作会用的一些查看命令： 

查看卷名	简单对应卷信息的查看	扫描相关的所有的对应卷	详细对应卷信息的查看  
物理卷	pvs	pvscan	pvdisplay  
卷组	vgs	vgscan	vgdisplay  
逻辑卷	lvs	lvscan	lvdisplay

### 1.创建并使用LVM逻辑卷
```
fdisk /dev/sdd
lsblk
pvcreate /dev/sdd1
vgcreate data /dev/sdd1
lvcreate -n lv01 -L 49G data
mkfs.xfs /dev/data/lv01 
mkdir /data/lv01 -p
mount /dev/data/lv01 /data/lv01/
## 扩容
df -Th
lsblk
fdisk /dev/sde
pvcreate /dev/sde1
vgextend data /dev/sde1
vgdisplay 
lvextend -L +50G /dev/data/lv01 
xfs_growfs /dev/data/lv01 
df -TH
```
### 2.使用ssm创建一个可动态扩容的存储池
```bash
yum -y install system-storage-manager
# 列出设备信息
ssm list dev
# 存储池信息
ssm list pool
mkdir /mail-lv
# ssm  create  -s  lv大小  -n  lv名称  --fstype  lv文件系统类型 -p 卷组名  设备 挂载点
ssm create -s 1G -n mail-lv --fstype xfs -p mail /dev/sdb[1-3] /mail-lv

# 动态扩容
fdisk /dev/sdc # n创建分区,t设置分区类型,8e LVM类型
vgextend mail /dev/sdc1
lvextend -L +49G /dev/mail/mail-lv
xfs_growfs /dev/mail/mail-lv
```
