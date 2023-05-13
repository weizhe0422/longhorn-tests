import configparser

CONFIG_FILE_PATH = 'settings.ini'

def initialize_variables():
    global RETRY_INTERVAL
    global SSH_CONFIG_PATH
    global CLOUD_PROVIDER
    global K8S_DISTRO
    global LONGHORN_CLIENT_URL

    RETRY_INTERVAL = 5
    SSH_CONFIG_PATH = '~/.ssh/config'
    CLOUD_PROVIDER = 'aws'
    K8S_DISTRO = 'RKE2'
    LONGHORN_CLIENT_URL = 'http://localhost:8080/'

    config = configparser.ConfigParser()
    config.read(CONFIG_FILE_PATH, encoding='utf-8')

    if config['CUSTOM'] in config.sections():
        RETRY_INTERVAL = config["CUSTOM"]["RETRY_INTERVAL"] if config["CUSTOM"]["RETRY_INTERVAL"] != "" else 5
        SSH_CONFIG_PATH = config["CUSTOM"]["SSH_CONFIG_PATH"] if config["CUSTOM"]["SSH_CONFIG_PATH"] != "" else '~/.ssh/config'
        CLOUD_PROVIDER = config["CUSTOM"]["CLOUD_PROVIDER"] if config["CUSTOM"]["CLOUD_PROVIDER"] != "" else 'aws'
        K8S_DISTRO = config["CUSTOM"]["K8S_DISTRO"] if config["CUSTOM"]["K8S_DISTRO"] != "" else 'rke2'
        LONGHORN_CLIENT_URL = config["CUSTOM"]["LONGHORN_CLIENT_URL"] if config["CUSTOM"]["LONGHORN_CLIENT_URL"] != "" else 'http://localhost:8080/'

