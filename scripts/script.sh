ps aux | grep glance | grep -v "grep" | awk '{print $2}' | xargs kill -9
pushd /opt/stack
rm -rf glance
git clone https://github.com/beyondtheclouds/glance -b discovery
pushd glance
sudo python setup.py install
popd
popd
screen -S "g-api" -dm bash start-glance-api.sh
screen -S "g-reg" -dm bash start-glance-registry.sh