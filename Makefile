install:

		@echo "Installing Unzip"
		sudo apt install unzip

		@echo "Installing AWS CLI"
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		unzip awscliv2.zip
		sudo ./aws/install

		@echo "Installing kubectl"
		sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
		curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
		echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
		sudo apt-get update
		sudo apt-get install -y kubectl

		@echo "Installing eksctl"
		curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
		sudo mv /tmp/eksctl /usr/local/bin
		eksctl version
		@echo "Installing docker"
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
		
		@echo "Installing hadolint"
		wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
		mv hadolint-Linux-x86_64 hadolint
		chmod +x hadolint
		sudo mv hadolint /usr/bin
