#!/bin/sh

apk -U --no-progress add gcc musl-dev make

# Build ii
cd /tmp
tar xzvf ii-1.7.tar.gz
cd ii-1.7/
make PREFIX=/usr install
cd /tmp
rm -rf ii-1.7
rm -rf ii-1.7.tar.gz
apk --no-progress del gcc musl-dev make

source /app/gogs/docker/build.sh
mkdir -p /app/gogs/docker/s6/ii/
cat << EOF > /app/gogs/docker/s6/ii/run
#!/bin/sh

if test -f ./setup; then
	    source ./setup
    fi

    exec gosu root /usr/sbin/ii -i /tmp -s irc.oftc.net -n KGB-10
EOF
chmod +x /app/gogs/docker/s6/ii/run

