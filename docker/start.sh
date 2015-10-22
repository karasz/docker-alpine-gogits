#!/bin/sh

# Cleanup s6 event folder on start and on shutdown
# in case container has been killed
rm -rf $(find /app/gogs/docker/s6/ -name 'event')

# Create VOLUME subfolder
for f in /data/gogs/data /data/gogs/conf /data/gogs/log /data/git /data/ssh /data/ii; do
	if ! test -d $f; then
		mkdir -p $f
	fi
done

# Exec CMD or S6 by default if nothing present
if [ $# -gt 0 ];then
	exec "$@"
else
	exec /usr/bin/s6-svscan /app/gogs/docker/s6/
fi
