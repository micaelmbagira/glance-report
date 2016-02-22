sudo service redis-server stop
sudo rm /var/lib/redis/dump.rdb
sudo service redis-server start

pushd devstack
./unstack.sh
./clean.sh
./stack.sh

source openrc
OUTPUT=$(nova secgroup-list | grep default)

if [ "$OUTPUT" == "" ]; then
    nova secgroup-create default "default group"
fi

popd
