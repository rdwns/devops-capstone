## Project Overview

This project contains a capstone project which deals with cloud-native container orchestration. This project is a requirement to graduate for the DevOps Nanodegree at Udacity. The project requires the skills and knowledge which were developed throughout the Cloud DevOps Nanodegree program to set up a pipeline for deploying Kubernetes Cluster running a containerized nodeJS app using Jenkins.

The main tasks involved in the project included:

- Working with AWS CLI
- Using Jenkins to build pipelines implementing Continuous Integration and Continuous Deployment
- Working with CloudFormation to deploy infrastructre
- Building Docker containers in pipelines
- Building Kubernetes clusters
- Deploying the docker containers to the Kubernetes Clusters

Main tools used were:

- AWS CLI
- Jenkins
- `eksctl` for cluster creation
- `kubectl` for managing kubernetes cluster
- `aws cloudformation` for deploying IaC

## Roadmap:

- [x]  Create Cloudformation Template for Network Stack
- [x]  Create Cloudformation Template for deploying Jenkins Server
- [x]  Application Code
- [x]  Containerize the application using Dockerfile
- [x]  Create Jenkinsfile
- [x]  DryTest the Kubernetes Cluster
- [x]  Deploy to AWS

---

## Technological Background

<details>

<summary>### Docker</summary>

Docker is the most widely used container technology and really what most people mean when they refer to containers. Docker is built on [cgroups](https://en.wikipedia.org/wiki/Cgroups) and [namespacing](https://en.wikipedia.org/wiki/Linux_namespaces) provided by the Linux kernel and recently Windows as well.

A Docker container is made up of layers of *images*, binaries packed together into a single package. The base image contains the operating system of the container, which can be different from the OS of the host.

The OS of the container is in the form an image. This is not the full operating system as on the host, and the difference is that the image is just the file system and binaries for the OS while the full OS includes the file system, binaries, and the kernel.

On top of the base image are multiple images that each build a portion of the container. For example, on top of the base image may be the image that contains the `apt-get` dependencies. On top of that may be the image that contains the application binary, and so on.

</details>


<details>
<summary>### Kubernetes<summary>

Making use of Kubernetes requires understanding the different abstractions it uses to represent the state of the system, such as services, pods, volumes, namespaces, and deployments.

- **[Pod**](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) - ****generally refers to one or more containers that should be controlled as a single application. A pod encapsulates application containers, storage resources, a unique network ID and other configuration on how to run the containers. In other words, pods are the smallest deployable units of computing in a cluster.
- **[Service](https://kubernetes.io/docs/concepts/services-networking/service/)** - pods by nature are not reliable. Kubernetes does not guarantee a given physical pod will be kept alive. Therefore, communicating directly with a pod is highly discouraged. Instead, a service represents a logical set of pods and acts as a gateway, allowing pods to send requests to the service without needing to keep track of which physical pods actually make up the service.
- **[Replica Set](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)** - ****is an API Object that helps to manage the scaling of Pods. It ensures that a specified number of pods are always running inside the cluster. As such, it is often used to guarantee the availability of a specified number of identical Pods.
- **[Volume](https://kubernetes.io/docs/concepts/storage/volumes/)** - ****similar to a container volume in Docker, but a Kubernetes volume applies to a whole pod and is mounted on all containers in the pod. Kubernetes guarantees data is preserved across container restarts. The volume will be removed only when the pod gets destroyed. Also, a pod can have multiple volumes (possibly of different types) associated.
- **[Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)** - ****a virtual cluster (a single physical cluster can run multiple virtual ones) intended for environments with many users spread across multiple teams or projects, for isolation of concerns. Resources inside a namespace must be unique and cannot access resources in a different namespace. Also, a namespace can be allocated a [resource quota](https://kubernetes.io/docs/concepts/policy/resource-quotas/) to avoid consuming more than its share of the physical cluster’s overall resources.
- **[Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)** - ****describes the desired state of a pod or a replica set, in a yaml file. The deployment controller then gradually updates the environment (for example, creating or deleting replicas) until the current state matches the desired state specified in the deployment file. For example, if the yaml file defines 2 replicas for a pod but only one is currently running, an extra one will get created. Note that replicas managed via a deployment should not be manipulated directly, only via new deployments.


</details>


### To prepare your local system to use Kubernetes you need to:

You can run `make install`  in the root directory of the project to run through all these installations automatically. Maue sure `make` is installed in your system first

1. Install and configure`aws cli` on your local system. *[Official Docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)*

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Run `aws configure` after successful installation to set up your API keys

2.  Install `kubectl`. *[Official Docs](https://kubernetes.io/docs/tasks/tools/install-kubectl/)*

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

3.  Install `eksctl`. [*Official Docs*](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

4.  Install Docker. *[Official Docs](https://docs.docker.com/engine/install/ubuntu/)*

```bash
sudo apt-get install \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg-agent \
                software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
                "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) \
                stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```

5.  Install hadolint, for liniting Dockerfiles. [*Official Docs*](https://github.com/hadolint/hadolint)

```bash
wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
mv hadolint-Linux-x86_64 hadolint
chmod +x hadolint
sudo mv hadolint /usr/bin
```

## Running this project:

First you need to build the Docker Images for Blue and Green Deployments of the nodeJS app. To do that execute the following in the project root directoy:

```bash
docker build -t yourhubusername/node-docker-green ./green && \
docker build -t yourhubusername/node-docker-blue ./blue
```

Then push the build images to Docker hub:

```bash
docker push yourhubusername/repositoryname
```

Make sure you login to docker before pushing.

Now deploy the Kubernetes cluster which will host the nodeJS app using the eksctl command. It's recommended to use instance `t2.medium` for the nodes.

```bash
eksctl create cluster \
--name udacity-capstone \
--version 1.16 \
--region ap-south-1 \
--nodegroup-name capstone-nodes \
--node-type t2.medium \
--nodes 2 \
--nodes-min 1 \
--nodes-max 2 \
--managed
```

This operation is expected to take around 15-20 minutes.

After the Kubernetes cluster has been deployed. Run the following from the root directory of the project to create the blue-replication controller:

```bash
kubectl apply -f ./blue/blue-controller.yml
```

Repeat the same for the green controller:

```bash
kubectl apply -f green/green-controller.yml

```

Create the blue service to deploy the blue container to the Kubernetes cluster:

```bash
kubectl apply -f ./blue-service.yml
```

This will create a loadbalancer for your kubernetes cluster which you can display by using:

```bash
kubectl get svc
```

To shift the deployment to green, simply apply the green service:

```bash
kubectl apply -f ./green-service.yml
```