#!/bin/sh

# This script setup minikube, builds Docker images, and create pods
# Users and Passwords
# SSH: User: ssh_user, Password: password
# FTPS: User: ftps_user, Password: password
# GRAFANA: User: grafana_user, Password: password
# PHPMYADMIN: User: wp_user, Password: password
# WORDPRESS DATABASE NAME: wordpress


# Directories
srcs=./srcs
dir_goinfre=/goinfre/$USER # /goinfre/$USER at 42 or /sgoinfre - /Users/$USER at home on Mac
docker_destination=$dir_goinfre/docker
dir_minikube=$dir_goinfre/minikube
dir_archive=$dir_goinfre/images-archives
volumes=$srcs/volumes

# install_virtualbox()
install_virtualbox()
{
if [ "$(VboxManage > /dev/null && echo $?)" == "0" ]; then
		printf "✅ : VirtualBox installed\n"
else
	printf "❗ : Please install ${Light_red}VirtualBox"
	printf "for Mac from the MSC (Managed Software Center)${Default_color}\n"
	open -a "Managed Software Center"
	# read -p ❗\ :\ Press\ $'\033[0;34m'RETURN$'\033[0m'\ when\ you\ have\ successfully\ installed\ VirtualBox\ for\ Mac\ ...
	# printf "\n"
	exit
fi
}

move_docker_goinfre()
{
	rm -rf ~/Library/Containers/com.docker.docker ~/.docker
	mkdir -p $docker_destination/{com.docker.docker,.docker}
	ln -sf $docker_destination/com.docker.docker ~/Library/Containers/com.docker.docker
	ln -sf $docker_destination/.docker ~/.docker
}

# install_docker()
install_docker()
{
if [ -d "/Applications/Docker.app" ]; then
	if [ "$(ls -la ~ | grep .docker | cut -d " " -f 18-99)" != ".docker -> /Volumes/Storage/goinfre/$USER/docker/.docker" ] || [ ! -d "/Volumes/Storage/goinfre/$USER/.docker" ]; then
		move_docker_goinfre
	# else
	# 	# open -a Docker && sleep 5
	fi
else
	printf "❗ : Please install ${Light_red}Docker"
	printf "for Mac from the MSC (Managed Software Center)${Default_color}\n"
	open -a "Managed Software Center"
	# read -p ❗\ :\ Press\ $'\033[0;34m'RETURN$'\033[0m'\ when\ you\ have\ successfully\ installed\ Docker\ for\ Mac\ ...
	# move_docker_goinfre
	exit
fi
echo "🐳 : Docker installed"
}

#check install brew
install_brew()
{
if [ "$(brew list > /dev/null 2>&1 && echo $?)" != "0" ]; then
	rm -rf $HOME/.brew &
	git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew &
	echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc &
	source $HOME/.zshrc &
	brew update
fi
echo "🤖 : Brew installed"
}

move_minikube_goinfre()
{
	mkdir -p $dir_minikube
	ln -sf $dir_minikube /Users/$USER/.minikube
}

install_minikube()
{
if [ "$(brew list | grep minikube)" != "minikube" ]; then
	echo "🤖 : Install Minikube"
	brew install minikube 
	move_minikube_goinfre
elif [ "$(ls -la ~ | grep .minikube | cut -d " " -f 18-99)" != ".minikube -> /Volumes/Storage/goinfre/$USER/.minikube" ] || [ ! -d "/Volumes/Storage/goinfre/$USER/.minikube" ]; then
	move_minikube_goinfre
fi
}

main()
{
	#Check if virtualBox is installed
	install_virtualbox
	#Check if docker is installed
	install_docker
	#Check if brew is installed
	install_brew
	#Check if minikube is installed
	install_minikube
}

main 


minikube start --vm-driver=virtualbox --disk-size=5000MB
eval $(minikube docker-env)
echo "🐳 : Minikube installed"
server_ip=`minikube ip`
echo -ne "\033[1;33m+>\033[0;33m IP : $server_ip \n"

#INSTALLING ADDONS
sleep 3
minikube addons enable metrics-server
minikube addons enable logviewer
minikube addons enable dashboard

#INSTALLING LOAD BALANCER
printf  "\e[1;31m🏂  Installing Load Balancer \n\e[0m"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml > /dev/null
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml > /dev/null
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > /dev/null
kubectl apply -f srcs/config/metallb.yaml > /dev/null
 
#INSTALLING SECRETS
printf  "\e[1;31m🕵  Installing Secrets \n\e[0m"
kubectl apply -f srcs/config/secret.yaml > /dev/null

#INSTALLING PERSISTENT VOLUMES∫
printf  "\e[1;31m💾 Installing Persistent Volumen Claim for SQL y INFLUXDB \n\e[0m"
kubectl apply -f srcs/config/pvolumeclaim.yaml > /dev/null

#BUILDING IMAGES
#images="ftps grafana nginx mysql wordpress phpmyadmin influxdb telegraf"
images="ftps grafana nginx mysql wordpress phpmyadmin influxdb telegraf"
printf  "\e[1;31m🗂  Building Images  \n\e[0m"
for image in $images
do
	printf "\e[0;31m📁 docker build image   [$image]\n\e[0m"
	docker build -t alpine_$image srcs/$image > /dev/null
done

#DEPLOY SERVICES
printf "\e[1;36m🐳  Deploying Services  \n\e[0m"
#services="ftps grafana nginx mysql wordpress phpmyadmin influxdb telegraf"
services="ftps grafana nginx mysql wordpress phpmyadmin influxdb telegraf"
for service in $services
do
	printf "\e[0;36m🐳 : kubernetes deployment [$service]\n\e[0m"
	kubectl apply -f srcs/$service/"$service"-deployment.yaml > /dev/null
done
kubectl get svc 
minikube service list
echo " ---------------------------------------------------------------------------------------"