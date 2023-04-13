from kubernetes import config, client
from longhorn import from_env

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
        longhorn_client_url = os.getenv('LONGHORN_CLIENT_URL')
        longhorn_client = from_env(url=f"{longhorn_client_url}/v1/schemas")
        print(longhorn_client)
        return longhorn_client

    @staticmethod
    def ssh_and_exec_cmd(cls, host, cmd):
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        cls().ssh_connect_with_retry(ssh, host, 0)
        stdin, stdout, stderr = ssh.exec_command(cmd)
        print('fail to execute command:', stderr.read())
    
    def ssh_connect_with_retry(cls, ssh, ip_address, retries):
        if retries > 3:
            return False
        
        try:
            retries += 1
            print('SSH into the instance: {}'.format(ip_address))
            config = paramiko.SSHConfig()
            try:
                config.parse(open(os.path.expanduser(SSH_CONFIG_PATH)))
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
            time.sleep(RETRY_INTERVAL)
            print('Retrying SSH connection to {}'.format(ip_address))
            cls.ssh_connect_with_retry(ssh, ip_address, retries)
    
