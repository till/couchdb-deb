couchdb-deb
===========

Ubuntu Package for Ubuntu

Launchpad repository: [https://launchpad.net/~till-php/+archive/couchdb](https://launchpad.net/~till-php/+archive/couchdb)

### Building

This might be helpful:

    export LANG=en_US.UTF-8
    export PPA=ppa:till-php/couchdb
    export PACKAGE=apache-couchdb
    export VERSION=1.2.0

Steps:

 1. extract source: tar zxvf apache-couchdb...
 2. copy debian to source: mv apache-couchdb/debian/ ./apache-couchdb...
 3. rm -rf apache-couchdb
 4. mv apache-couchdb... apache-couchdb
 5. cd apache-couchdb/
 6. debuild -S [-sa]
 7. cd ..
 8. dput $PPA apache-couchdb_*_source.changes
