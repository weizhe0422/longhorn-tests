from kubernetes import config, client
from longhorn import from_env
from utility import globals

import string
import random
import os
import paramiko
import time

class Utility:

    def generate_volume_name(cls):
        return "vol-" + \
            ''.join(random.choice(string.ascii_lowercase + string.digits)
                    for _ in range(6))

    def init_k8s_api_client(cls):
        print('init_k8s_api_client')
        # to make it easier to develop and debug
        # run test in local environment instead of in-cluster
        # our existing test is running in in-cluster environment
        # it makes us always need to build new docker image to test our code
        config.load_kube_config()  # for local environment
        # config.load_incluster_config()  # for in-cluster environment
    
    @classmethod
    def get_k8s_core_api_client(cls):
        print('get_k8s_api_client')
        cls().init_k8s_api_client()
        return client.CoreV1Api()
        
    def get_longhorn_client(cls):
        print('get_longhorn_client')
        # manually expose longhorn client node port
        # otherwise the test is needed to be run in in-cluster environment
        # to access longhorn manager cluster ip
        longhorn_client_url = globals.LONGHORN_CLIENT_URL ##os.getenv('LONGHORN_CLIENT_URL')
        longhorn_client = from_env(url=f"{longhorn_client_url}/v1/schemas")
        return longhorn_client

    @classmethod
    def ssh_and_exec_cmd(cls, host, cmd):
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        cls().ssh_connect_with_retry(ssh, host, 0)
        chan = ssh.get_transport().open_session()
        
        print(f'command to exectue:{cmd}')
        chan.exec_command(cmd)

        isExecCommand = True
        while isExecCommand:
            if chan.recv_ready():
                print('response of command: ', chan.recv(4096).decode('ascii'))
            
            if chan.exit_status_ready():
                if chan.recv_stderr_ready() and chan.recv_exit_status() != 0:
                    raise Exception('fail to execute command:', chan.recv_stderr(4096).decode('ascii'))

                isExecCommand = False
                print(f'success of command execution: {chan.recv_exit_status()}')
                ssh.close()
    
    def ssh_connect_with_retry(cls, ssh, ip_address, retries):
        if retries > 3:
            return False
        
        try:
            retries += 1
            print('SSH into the instance: {}'.format(ip_address))
            config = paramiko.SSHConfig()
            try:
                config.parse(open(os.path.expanduser(globals.SSH_CONFIG_PATH)))
            except IOError:
                # No file found, so empty configuration
                pass
            # machine_config is a dict with only relevant properties set
            host_conf = config.lookup(ip_address)
            cfg = {}
            if host_conf:
                if 'user' in host_conf:
                    cfg['username'] = host_conf['user']
                if 'identityfile' in host_conf:
                    cfg['key_filename'] = host_conf['identityfile']
                if 'hostname' in host_conf:
                    cfg['hostname'] = host_conf['hostname']

            ssh.connect(**cfg)
            return True
        except Exception as e:
            print(e)
            time.sleep(globals.RETRY_INTERVAL)
            print('Retrying SSH connection to {}'.format(ip_address))
            cls.ssh_connect_with_retry(ssh, ip_address, retries)
    
