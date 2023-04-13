import configparser

CONFIG_FILE_PATH = 'settings.ini'

def initialize_variables():
    global RETRY_INTERVAL
    global SSH_CONFIG_PATH
    global CLOUD_PROVIDER
    global K8S_DISTRO

    RETRY_INTERVAL = 5
    SSH_CONFIG_PATH = '~/.ssh/config'
    CLOUD_PROVIDER = 'aws'
    K8S_DISTRO = 'RKE2'

    config = configparser.ConfigParser()
    config.read_file(CONFIG_FILE_PATH)
    if config["CUSTOM"] in config.sections:
        RETRY_INTERVAL = config["CUSTOM"]["RETRY_INTERVAL"] if config["CUSTOM"]["RETRY_INTERVAL"] != "" else 5
        SSH_CONFIG_PATH = config["CUSTOM"]["SSH_CONFIG_PATH"] if config["CUSTOM"]["SSH_CONFIG_PATH"] != "" else '~/.ssh/config'
        CLOUD_PROVIDER = config["CUSTOM"]["CLOUD_PROVIDER"] if config["CUSTOM"]["CLOUD_PROVIDER"] != "" else 'aws'
        K8S_DISTRO = config["CUSTOM"]["K8S_DISTRO"] if config["CUSTOM"]["K8S_DISTRO"] != "" else 'rke2'


