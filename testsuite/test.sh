#!/usr/bin/env bash

PWD="$(pwd)"

if [ $# -eq 0 ]
then if [ -f test.cfg ]
     then COUCHDB_TEST_CFG="${PWD}/test.cfg"
     else echo "Error: no configuration file found." && exit 1
     fi
else if [ -f $1 ]
     then COUCHDB_TEST_CFG=$1
     else echo "Error: file not found (\"$1\")."
     fi
fi

echo ""
echo "Preparing tests"
echo "---------------"
cd utils
echo -n "Compiling \"test_cfg_register.c\" ... "
gcc -o test_cfg_register -g -O2 test_cfg_register.c > /dev/null 2>&1
if [ -e test_cfg_register ] ; then echo "test_cfg_register" ; else echo "error" && exit 1 ; fi
echo -n "Injecting data in \"test_util.hrl\" ... " &&
echo "" > test_util.hrl &&
for var in "COUCHDB_TEST_ETAP_PATH" \
           "COUCHDB_TEST_PATH" \
           "COUCHDB_TEST_LIB_PATH" \
           "COUCHDB_TEST_ETC_PATH" \
           "COUCHDB_TEST_SHARE_PATH" \
           "COUCHDB_TEST_VARLIB_PATH" \
           "COUCHDB_TEST_EXTRA" \
           "COUCHDB_TEST_VERSION" \
           "COUCHDB_TEST_ETAP_VERSION" \
           "COUCHDB_TEST_EJSON_VERSION" \
           "COUCHDB_TEST_ERLANG_OAUTH_VERSION" \
           "COUCHDB_TEST_IBROWSE_VERSION" \
           "COUCHDB_TEST_MOCHIWEB_VERSION" \
           "COUCHDB_TEST_SNAPPY_VERSION" \
           "COUCHDB_TEST_EBIN"
do cat ${COUCHDB_TEST_CFG} | grep ${var} | awk '{printf("-define(%s,%s).\n",$1,$2);}' >> test_util.hrl
done
if [ X"$(cat test_util.hrl)" != "X" ] ; then echo "done" ; else echo "error" && exit 1 ; fi
echo -n "Compiling \"test_util.erl\" ... "
erlc test_util.erl
if [ -f test_util.beam ] ; then echo "test_util.beam" ; else echo "error" && exit 1 ; fi
echo -n "Compiling \"test_web.erl\" ... "
erlc test_web.erl
if [ -f test_web.beam ] ; then echo "test_web.beam" ; else echo "error" && exit 1 ; fi
mv -f test_cfg_register ../tests/
mv -f test_util.beam ../tests/
mv -f test_web.beam ../tests/
cd ../
echo "---------------"
echo ""
echo "Executing tests"
echo "---------------"
cd $(cat ${COUCHDB_TEST_CFG} | grep "COUCHDB_TEST_ETAP_PATH" | awk '{print substr($2,2,length($2)-2);}')
prove *.t
cd ../
echo "---------------"
echo ""
echo "End of tests."
echo ""
cd ${PWD}
