#!/bin/bash

logfile="result"
savelog(){
	sed "s/^/$(echo -n `date "+%Y-%m-%d %H:%M:%S"`)\t/" | tee -a $logfile
}

SHELL_DIR=$PWD"/sh"
BIN_DIR=$PWD"/bin"
MOD_DIR=$PWD"/mod"
TESTLIST=$PWD"/test_list"
LOG_DIR=$PWD"/log"
export SHELL_DIR
export BIN_DIR
export MOD_DIR
export LOG_DIR
export MODULE_LOG


if [ ! -f "$TESTLIST" ]; then
	echo "Nothing to do!"
else
	cat $TESTLIST | sed "/^#/d; s/#.*$//g" | while read line
	do
		MODULE_LOG="${line%%.*}_$(echo -n `date "+%Y_%m_%d_%H_%M_%S"`).log"	
		touch "${LOG_DIR}/${MODULE_LOG}"
		chmod 755 $SHELL_DIR"/"$line
		$SHELL_DIR"/"$line
		if [ $? -eq 0 ] ; then
			echo "${line%%.*} test success!" | savelog
		else
			echo "${line%%.*} test fail!" | savelog
		fi
	done
fi
