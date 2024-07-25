#This is a simple python script that auto upload files to my hackintosh which use to compile this tweak.Written by ChatGPT.
#放置在项目文件夹内然后python执行，自动上传并编译安装

import os
import paramiko
import scp
import sys
import re

# 定义目标机器的连接信息
remote_host = ''
remote_user = ''
remote_pass = ''
remote_tmp_dir = ''
remote_PATH = '/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin'

def upload_files(local_dir, remote_dir, scp_client):
    for item in os.listdir(local_dir):
        local_path = os.path.join(local_dir, item)
        remote_path = os.path.join(remote_dir, item).replace('\\', '/')
        if os.path.isfile(local_path):
            scp_client.put(local_path, remote_path)
        elif os.path.isdir(local_path):
            scp_client.put(local_path, remote_path, recursive=True)

def remove_ansi_codes(text):
    """ 移除 ANSI 颜色转义码 """
    ansi_escape = re.compile(r'\x1b\[[0-9;]*m')
    return ansi_escape.sub('', text)

def execute_make_do(ssh_client, remote_dir):
    # 显式设置PATH变量，并使用交互式zsh来执行命令并加载环境变量
    command = f'zsh -c "export PATH={remote_PATH};export THEOS=~/theos && cd {remote_dir} && make do"'
    stdin, stdout, stderr = ssh_client.exec_command(command)
    for line in iter(stdout.readline, ""):
        print(remove_ansi_codes(line), end="")  # 实时输出日志并移除颜色代码
    for line in iter(stderr.readline, ""):
        print(remove_ansi_codes(line), end="", file=sys.stderr)

def delete_remote_directory(ssh_client, remote_dir):
    ssh_client.exec_command(f'rm -rf {remote_dir}')

def ensure_remote_directory(ssh_client, remote_dir):
    stdin, stdout, stderr = ssh_client.exec_command(f'mkdir -p {remote_dir}')
    stdout.channel.recv_exit_status()  # Wait for the command to complete

def main():
    local_dir = os.getcwd()
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(remote_host, username=remote_user, password=remote_pass)
    
    scp_client = scp.SCPClient(ssh_client.get_transport())
    
    try:
        ensure_remote_directory(ssh_client, remote_tmp_dir)
        upload_files(local_dir, remote_tmp_dir, scp_client)
        execute_make_do(ssh_client, remote_tmp_dir)
    finally:
        delete_remote_directory(ssh_client, remote_tmp_dir)
        scp_client.close()
        ssh_client.close()

if __name__ == "__main__":
    main()