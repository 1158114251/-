#########################################################################
# File Name: tools_test.sh
# Author: ZhangLeJia
# mail: 617545021@qq.com
# Created Time: 2016年10月18日
# Function: 功能及稳定性测试脚本
#########################################################################
#!/bin/bash

CoreNum=4

RESULT_DIR="../test_result"
START_DATA=`date  +%y%m%d%H%M`
CURRENT_DIR="${RESULT_DIR}/${START_DATA}"
LOGDIR="${CURRENT_DIR}/log"

ALL_LOG="${LOGDIR}/all.log"
SPEC2000_LOG="${LOGDIR}/spec2000.log"
SPEC2006_LOG="${LOGDIR}/spec2006.log"
UNIXBENCH_LOG="${LOGDIR}/unixbench.log"
NETPERF_LOG="${LOGDIR}/netperf.log"
X11PERF_LOG="${LOGDIR}/x11perf.log"
IOZONE_LOG="${LOGDIR}/iozone.log"
STREAM_LOG="${LOGDIR}/stream.log"
STRESS_LOG="${LOGDIR}/stress.log"
LTP_LOG="${LOGDIR}/LTP.log"

SPEC2000_RESULT="${CURRENT_DIR}/spec2000"
SPEC2006_RESULT="${CURRENT_DIR}/spec2006"
UNIXBENCH_RESULT="${CURRENT_DIR}/unixbench"
NETPERF_RESULT="${CURRENT_DIR}/netperf"
X11PERF_RESULT="${CURRENT_DIR}/x11perf"
IOZONE_RESULT="${CURRENT_DIR}/iozone"
STREAM_RESULT="${CURRENT_DIR}/stream"
STRESS_RESULT="${CURRENT_DIR}/stress"
LTP_RESULT="${CURRENT_DIR}/LTP"

### create file ###
if [ ! -d ${RESULT_DIR} ]
then
	mkdir ${RESULT_DIR}
fi
mkdir ${CURRENT_DIR}
mkdir ${LOGDIR}

### handle param ###
spec2000_enable=0
spec2006_enable=0
unixbench_enable=0
netperf_enable=0
x11perf_enable=0
iozone_enable=0
stream_enable=0
stress_enable=0
ltp_enable=0
mod1_enable=0
mod2_enable=0
all_enable=0
clear_enable=0

case "$1" in
spec2000)	spec2000_enable=1;;
spec2006)	spec2006_enable=1;;
unixbench)	unixbench_enable=1;;
netperf)	netperf_enable=1;;
x11perf)	x11perf_enable=1;;
iozone)		iozone_enable=1;;
stream)		stream_enable=1;;
stress)		stress_enable=1;;
ltp)		ltp_enable=1;;
mod1)		mod1_enable=1;;
mod2)		mod2_enable=1;;
all)		all_enable=1;;
clear)		clear_enable=1;;
*)			echo "can't find $1 tool" && exit 0;;
esac

if [ $mod1_enable -eq 1 ]
then
	unixbench_enable=1
	netperf_enable=1
	x11perf_enable=1
	iozone_enable=1
	stream_enable=1
	stress_enable=1
fi

if [ $mod2_enable -eq 1 ]
then
	spec2000_enable=1
	spec2006_enable=1
	netperf_enable=1
	iozone_enable=1
	stress_enable=1
	ltp_enable=1
fi

if [ $all_enable -eq 1 ]
then
	spec2000_enable=1
	spec2006_enable=1
	unixbench_enable=1
	netperf_enable=1
	x11perf_enable=1
	iozone_enable=1
	stream_enable=1
	stress_enable=1
	ltp_enable=1
fi

if [ -n "$2" ]
then
	run_times=$2;
else
	run_times=1;
fi

### record start time ###
start_time=`date +%s`

### ALL_LOG title ###
echo "########################################################################" | tee ${ALL_LOG}
printf "Project\t\t\tStart_time\n" | tee -a ${ALL_LOG}
TABLE_LINE="_______________________________________________________________________"
echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
echo "" | tee -a ${ALL_LOG}

############ UnixBench ###########
if [ ${unixbench_enable} -eq 1 ]
then
	TEST_PROJECT="UnixBench"
	TestDir="/home/UnixBench"
	TestResult="${TestDir}/results"
	TestCmd="${TestDir}/Run -c ${CoreNum}"
	LogDir=${UNIXBENCH_LOG}
	ResultDir=${UNIXBENCH_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ X11perf ###########
if [ ${x11perf_enable} -eq 1 ]
then
	TEST_PROJECT="X11perf"
	TestDir="/opt/x11perf-1.5.4"
	TestResult="${TestDir}/x11perf_results"
	TestCmd="${TestDir}/run_x11perf"
	LogDir=${X11PERF_LOG}
	ResultDir=${X11PERF_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ Stream ###########
if [ ${stream_enable} -eq 1 ]
then
	### get CoreNum ###
	if [ -n "$3" ]
	then
		CoreNum=$3
	fi
	### get StreamRun ###
	if [ -n "$4" ]
	then
		StreamRun=$4
	else
		StreamRun=10
	fi

	TEST_PROJECT="Stream"
	TestDir="/home/stream"
	TestResult="${TestDir}"
	TestCmd="${TestDir}/stream.sh ${CoreNum} ${StreamRun}"
	LogDir=${STREAM_LOG}
	ResultDir=${STREAM_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/all.log
		rm -rf ${TestResult}/avge.log
		rm -rf ${TestResult}/sum.log
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/all.log ${ResultDir}/all_${i}.log
		cp -rf ${TestResult}/avge.log ${ResultDir}/avge_${i}.log
		cp -rf ${TestResult}/sum.log ${ResultDir}/sum_${i}.log
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ Iozone ###########
if [ ${iozone_enable} -eq 1 ]
then
	### get IozoneRun ###
	if [ -n "$3" ]
	then
		IozoneRun=$3
	else
		IozoneRun=1
	fi

	TEST_PROJECT="Iozone"
	TestDir="/opt/iozone3_326"
	TestResult="${TestDir}/results"
	TestCmd="${TestDir}/iozone.sh ${IozoneRun}"
	LogDir=${IOZONE_LOG}
	ResultDir=${IOZONE_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		mount /dev/sda5 /mnt
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}
		umount /mnt -fl

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ Netperf ###########
if [ ${netperf_enable} -eq 1 ]
then
	### get IPaddr ###
	if [ -n "$3" ]
	then
		IPaddr=$3
	else
		IPaddr=192.168.1.3
	fi
	### get NetperfRun ###
	if [ -n "$4" ]
	then
		NetperfRun=$4
	else
		NetperfRun=10
	fi

	TEST_PROJECT="Netperf"
	TestDir="/opt/netperf-2.4.5"
	TestResult="${TestDir}/netperf_result"
	TestCmd="${TestDir}/netperf.sh ${IPaddr} ${NetperfRun}"
	LogDir=${NETPERF_LOG}
	ResultDir=${NETPERF_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ Spec2000 ###########
if [ ${spec2000_enable} -eq 1 ]
then
	TEST_PROJECT="Spec2000"
	TestDir="/home/spec2000-all"
	TestResult="${TestDir}/result"
	TestCmd="bash ${TestDir}/myrun.sh"
	LogDir=${SPEC2000_LOG}
	ResultDir=${SPEC2000_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ Spec2006 ###########
if [ ${spec2006_enable} -eq 1 ]
then
	TEST_PROJECT="Spec2006"
	TestDir="/home/spec2006-loongson"
	TestResult="${TestDir}/result"
	TestCmd="bash ${TestDir}/myrun.sh"
	LogDir=${SPEC2006_LOG}
	ResultDir=${SPEC2006_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ Stress ###########
if [ ${stress_enable} -eq 1 ]
then
	### get StressMem ###
	if [ -n "$3" ]
	then
		StressMem=$3
	else
		StressMem=7700
	fi
	### get StressTime ###
	if [ -n "$4" ]
	then
		StressTime=$4
	else
		StressTime=72
	fi

	TEST_PROJECT="Stress"
	TestDir="/home/stress"
	TestResult="${TestDir}/Result"
	TestCmd="bash ${TestDir}/stress.sh ${StressMem} ${StressTime}"
	LogDir=${STRESS_LOG}
	ResultDir=${STRESS_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


############ LTP ###########
if [ ${ltp_enable} -eq 1 ]
then
	### get LtpTime ###
	if [ -n "$3" ]
	then
		LtpTime=$3
	else
		LtpTime=1
	fi

	TEST_PROJECT="LTP"
	TestDir="/opt/ltp/testscripts"
	TestResult="/tmp"
	TestCmd="ltpstress.sh -d  /tmp/ltpstress.data -l /tmp/ltpstress.log -t ${LtpTime} -i 60 -p -S -n"
	LogDir=${LTP_LOG}
	ResultDir=${LTP_RESULT}

	### create result file ###
	if [ ! -d ${ResultDir} ]
	then
		mkdir ${ResultDir}
	fi
	
	for (( i = 0; i < run_times; i++ ))
	do
		tool_start=`date  +%y-%m-%d_%H:%M`
		echo "${TEST_PROJECT}			${tool_start}" | tee -a ${ALL_LOG}
		
		### Remove last result ###
		rm -rf ${TestResult}/ltpstress.*
		
		### Start new test ###
		cd ${TestDir}
		echo "#################### test${i} #########################" >> ${LogDir}
		${TestCmd} &>> ${LogDir}

		### Cp result ###
		cp -rf ${TestResult}/ltpstress.* ${ResultDir} 
		
		### end test ###
		echo "${TABLE_LINE}" | tee -a ${ALL_LOG}
		echo "" | tee -a ${ALL_LOG}
	done
fi
#################################


########## Clear Result ###########
if [ ${clear_enable} -eq 1 ]
then
	rm -rf ${RESULT_DIR}
	echo "All result was removed"
fi
###################################
