vim  auto_ssh.sh 
#!/usr/bin/expect  
set timeout 10  
set username [lindex $argv 0]  
set password [lindex $argv 1]  
set hostname [lindex $argv 2]  
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $username@$hostname
expect {
            #first connect, no public key in ~/.ssh/known_hosts
            "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            expect "password:"
                send "$password\r"
            }
            #already has public key in ~/.ssh/known_hosts
            "password:" {
                send "$password\r"
            }
            "Now try logging into the machine" {
                #it has authorized, do nothing!
            }
        }
expect eof

#测试
./auto_ssh.sh 用户 密码 ip

#以下均为注释

/*
#expect用法
http://www.cnblogs.com/iloveyoucc/archive/2012/05/11/2496433.html
1. ［#!/usr/bin/expect］ 
指明shell，这里的expect其实和linux下的bash、windows下的cmd是一类东西。 
2. ［set timeout 30］
超时时间，单位秒 。timeout -1 为永不超时
3. ［spawn ssh -l username 192.168.1.1］ 
spawn是进入expect环境后才可以执行的expect内部命令，如果没有装expect或者直接在默认的SHELL下执行是找不到spawn命令的。
好比windows里的dir就是一个内部命令，这个命令由shell自带，你无法找到一个dir.com 或 dir.exe 的可执行文件。
它主要的功能是给ssh运行进程加个壳，用来传递交互指令。 
4. ［expect "password:"］ 
这里的expect也是expect的一个内部命令，这个命令的意思是判断上次输出结果里是否包含“password:”的字符串，
如果有则立即返回，否则就等待一段时间后返回，这里等待时长就是前面设置的30秒。
5. ［send "ispass\r"］ 
这里就是执行交互动作，与手工输入密码的动作等效。 温馨提示： 命令字符串结尾别忘记加上“\r”，如果出现异常等待的状态可以核查一下。
6. ［interact］ 
执行完成后保持交互状态，把控制权交给控制台，这个时候就可以手工操作了。
如果没有这一句登录完成后会退出，而不是留在远程终端上。如果你只是登录过去执行 
7.$argv 参数数组
expect脚本可以接受从bash传递过来的参数.可以使用[lindex $argv n]获得，n从0开始，分别表示第一个,第二个,第三个....参数
send_user用来发送内容给用户。
8.expect的命令行参数参考了c语言的，与bash shell有点不一样。其中，$argc为命令行参数的个数，$argv0为脚本名字本身，$argv为命令行参数。[lrange $argv 0 0]表示第1个参数，[lrange $argv 0 4]为第一个到第五个参数。与c语言不一样的地方在于，$argv不包含脚本名字本身。

*/























