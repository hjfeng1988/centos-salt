### 1.master配置

```
[root@salt-master ~]# grep -Ev "^$|#" /etc/salt/master 
interface: 0.0.0.0
file_roots:
  base:
    - /srv/salt/base
  prod:
    - /srv/salt/prod
pillar_roots:
  base:
    - /srv/pillar/base
  prod:
    - /srv/pillar/prod
[root@salt-master ~]# cat /etc/salt/roster 
host101:
  host: 192.168.1.101
  user: root
  passwd: password

host102:
  host: 192.168.1.102
  user: root
  passwd: password
```

### 2.安装minion客户端
> 因host.only使用salt-repo-2017.7，因watch_any使用salt-repo-latest-2 ，master最好也需要此版本

`salt-ssh -i \* state.sls minion`

### 3.master接受客户端

`salt-key -a 'host101,host102'`

### 4.minion环境初始化
> init前替换好自己的公钥至salt/base/init/config/root.pub

`salt \* state.sls init`

### 5.minion安装软件

`salt host101 state.sls install.jdk saltenv=prod`


