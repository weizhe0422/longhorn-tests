from kubernetes import client


class Objects:

    def __init__(self):
        return

    @classmethod
    def create_service_for_stateful_set(cls):
        service = client.V1Service(
            api_version="v1",
            kind="Service",
            metadata=client.V1ObjectMeta(name="nginx", labels={"app":"nginx"}),
            spec=client.V1ServiceSpec(ports=[client.V1ServicePort(name="web", port=80)],
                                      selector={"app":"nginx"},
                                      type="NodePort")
        )
        return service
        
    @classmethod
    def create_stateful_set_object(cls, replicas):
        container = client.V1Container(
            name="nginx",
            image="registry.k8s.io/nginx-slim:0.8",
            liveness_probe=client.V1Probe(
                _exec=client.V1ExecAction(command=["/bin/sh", "ls", "/usr/share/nginx/html/lost+found"]),
                initial_delay_seconds=5,
                period_seconds=5),
            ports=[client.V1ContainerPort(container_port=80, name="web")],
            volume_mounts=[client.V1VolumeMount(name="www", mount_path="/usr/share/nginx/html")],
        )
        
        # Template
        template = client.V1PodTemplateSpec(
            metadata=client.V1ObjectMeta(labels={"app": "nginx"}),
            spec=client.V1PodSpec(restart_policy="Always",
                                  termination_grace_period_seconds=10,
                                  containers=[container])
            )
        
        # Spec
        spec = client.V1StatefulSetSpec(
            selector=client.V1LabelSelector(
                match_labels={"app": "nginx"}),
            service_name="nginx",
            replicas=int(replicas),
            template=template,
            volume_claim_templates=[client.V1PersistentVolumeClaim(
                metadata=client.V1ObjectMeta(name="www"),
                spec=client.V1PersistentVolumeClaimSpec(access_modes=["ReadWriteOnce"],
                                                        storage_class_name="longhorn",
                                                        resources=client.V1ResourceRequirements(requests={"storage":"1Gi"})))
                                    ]
            )
        
        # StatefulSet
        statefulset = client.V1StatefulSet(
            api_version="apps/v1",
            kind="StatefulSet",
            metadata=client.V1ObjectMeta(name="web"),
            spec=spec)

        return statefulset
    
    @classmethod
    def create_service_for_deployment(cls):
        return client.V1Service(
            api_version="v1",
            kind="Service",
            metadata=client.V1ObjectMeta(name="mysql", labels={"app":"mysql"}),
            spec=client.V1ServiceSpec(ports=[client.V1ServicePort(port=3306)],
                                      selector={"app":"mysql"},
                                      cluster_ip="None")
        )
    
    @classmethod
    def create_pvc_for_deployment(cls):
        pvc = client.V1PersistentVolumeClaim(
            api_version="v1",
            kind="PersistentVolumeClaim",
            metadata=client.V1ObjectMeta(name="mysql-pvc"),
            spec=client.V1PersistentVolumeClaimSpec(access_modes=["ReadWriteOnce"],
                                                    storage_class_name="longhorn",
                                                    resources=client.V1ResourceRequirements(requests={"storage":"2Gi"}))
        )
        
        return pvc
        
        
    @classmethod
    def create_deployment_objects(self, replicas):
        container = client.V1Container(
            image="mysql:5.6",
            name="mysql",
            liveness_probe=client.V1Probe(
                _exec=client.V1ExecAction(command=["/bin/sh", "ls", "/var/lib/mysql/lost+found"]),
                initial_delay_seconds=5,
                period_seconds=5),
            ports=[client.V1ContainerPort(container_port=3306, name="mysql")],
            volume_mounts=[client.V1VolumeMount(name="mysql-volume", mount_path="/var/lib/mysql")],
            env=[client.V1EnvVar(name="MYSQL_ROOT_PASSWORD", value="rancher")]
        )
        
        template = client.V1PodTemplateSpec(
            metadata=client.V1ObjectMeta(labels={"app": "mysql"}),
            spec=client.V1PodSpec(restart_policy="Always",
                                  containers=[container],
                                  volumes=[client.V1Volume(name="mysql-volume",
                                                           persistent_volume_claim=client.V1PersistentVolumeClaimVolumeSource(claim_name="mysql-pvc"))])         
        )
        
        spec = client.V1DeploymentSpec(
            replicas=replicas,
            selector=client.V1LabelSelector(match_labels={"app": "mysql"}),
            strategy=client.V1DeploymentStrategy(type="Recreate"),
            template=template
        )
        
        deployment = client.V1Deployment(
            api_version="apps/v1",
            kind="Deployment",
            metadata=client.V1ObjectMeta(name="mysql",
                                         labels={"app": "mysql"}),
            spec=spec
        )
        
        return deployment
    
    
