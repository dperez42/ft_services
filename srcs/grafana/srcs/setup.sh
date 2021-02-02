set -x # Print commands and their arguments as they are executed
openrc
touch /run/openrc/softlevel
openrc default
cd /grafana/bin/ 
./grafana-server