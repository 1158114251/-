###################################################
#Description:  
#Author:zhangpengfei
#Version:1.0  
#CreateTime:2017年4月18日14:21:45
#Function:data analysis
##################################################


#!/bin/bash

PATH_RESULT="/home/ToolsTest_result"
#SINGLE_TEST=`date +%Y-%m-%dT%H%M%S.txt` 
SINGLE_TEST="biaozhun.txt" 

TABLELINE="*******************************************************************************************************************"

PATH_OF_IOZONE="$PATH_RESULT/iozone/iozone_1/results/iozone1.out"
PATH_OF_SPEC2000_CFP="$PATH_RESULT/spec2000/result/CFP2000.001.asc"
PATH_OF_SPEC2000_CINT="$PATH_RESULT/spec2000/result/CINT2000.001.asc"
PATH_OF_STREAM="$PATH_RESULT/stream/avge.log"
PATH_OF_SPEC2006_CFP="$PATH_RESULT/spec2006/result/CFP2006.001.txt"
PATH_OF_SPEC2006_CINT="$PATH_RESULT/spec2006/result/CINT2006.001.txt"
PATH_OF_UnixBench=`ls /home/ToolsTest_result/unixbench/*[0-9]` 
PATH_OF_x11Perf="$PATH_RESULT/x11perf/x11perf_results/x11perf_*"
PATH_OF_Stress="$PATH_RESULT/stress"
PATH_OF_Ltp="$PATH_RESULT/ltp"
####################IOZONE RESULT Analysis############
 

sed -n '/Excel output is below/,/"$"/p' $PATH_OF_IOZONE  | sed 's/\"/\ /g' >temp.txt

sed '1,1c iozone 测试结果 ' temp.txt >temp1.txt
echo "$TABLELINE" >>$SINGLE_TEST
awk -vOFS="\t" '{$1=$1}1' temp1.txt >>$SINGLE_TEST


###############################STREAM RESULT Analysis#################
echo "$TABLELINE" >>$SINGLE_TEST
echo -e " \nstream  测试结果\n" >>$SINGLE_TEST

#sed -n '/Excel output is below/,/"$"/p' iozone1.out  | sed 's/\"/\ /g' >temp.txt

#sed '1,1c iozone 测试结果 ' temp.txt >iozone.txt

awk -vOFS="\t" '{$1=$1}1' $PATH_OF_STREAM >>$SINGLE_TEST


#awk -vOFS="\t" '{print $1,$2,$.......}' temp.txt  

#awk '{printf "%s\t%s\t%s\t%s\t%s\n",$1,$2,$3,$4,$5}' 2.txt >3.txt

############################### Stress  RESULT Analysis #########################

echo "$TABLELINE" >>$SINGLE_TEST
echo -e " \nStress 测试结果\n" >>$SINGLE_TEST
Stress_Result=`grep -rn "mis"  $PATH_OF_Stress`

cmd=${Stress_Result}

if [ -z ${cmd} ];then 
	echo -e "Stress PASS"  >>$SINGLE_TEST
else
	echo -e"Stress FAIL" >>$SINGLE_TEST
fi 




#############################Spec2000 RESULT Analysis #########################


sed -n '/====================/,/Est. SPECfp_rate2000/p' $PATH_OF_SPEC2000_CFP  | sed 's/\"/\ /g' >temp.txt
echo "$TABLELINE" >>$SINGLE_TEST
sed '1,1c  \\n spec2000  浮点测试结果 \n\n  Benchmark    BaseCopies    BaseRuntime    BaseRatio \n' temp.txt >spec2000.txt


sed -n '/===================/,/NOTES/p' $PATH_OF_SPEC2000_CINT  | sed 's/\"/\ /g' >temp1.txt
sed '1,1c \\n spec2000  定点测试结果 \n' temp1.txt >>spec2000.txt


awk -vOFS="\t" '{$1=$1}1' spec2000.txt >>$SINGLE_TEST

# 删除中间文件哦

rm spec2000* -rf


#sed '1,1c  excel of spec2000\n' temp.txt >spec2000.txt
#sed '/Tested by Loongson.cn/d' spec2000.txt >temp.txt


#############################Spec2006 RESULT Analysis #########################

sed -n '/====================/,/Est. SPECfp_rate2006/p' $PATH_OF_SPEC2006_CFP  | sed 's/\"/\ /g' >temp.txt
 echo "$TABLELINE" >>$SINGLE_TEST
sed '1,1c  \\n spec2006  浮点测试结果 \n\n  Benchmark    BaseCopies    BaseRuntime    BaseRatio \n' temp.txt >spec2006.txt


sed -n '/===================/,/Est. SPECint_rate2006/p' $PATH_OF_SPEC2006_CINT  | sed 's/\"/\ /g' >temp1.txt
sed '1,1c \\n spec2006  定点测试结果  \n ' temp1.txt >>spec2006.txt


awk -vOFS="\t" '{$1=$1}1' spec2006.txt >>$SINGLE_TEST

rm spec2006*  -rf

############################### UnixBench  RESULT Analysis #########################  


sed -n '/---------------------------/,/"$"/p'  $PATH_OF_UnixBench  | sed 's/\"/\ /g' >temp.txt
echo "$TABLELINE" >>$SINGLE_TEST
sed '1,1c   \\n UnixBench 测试结果  \n' temp.txt >>$SINGLE_TEST

#awk -vOFS="" '{$1=$1}1' temp1.txt >>$SINGLE_TEST

############################### x11perf  RESULT Analysis #########################

sed -n '/Sync time adjustment/,/"$"/p' $PATH_OF_x11Perf  | sed 's/\"/\ /g' >temp.txt
echo "$TABLELINE" >>$SINGLE_TEST
sed '1,1c  \\n x11perf 测试结果  \n ' temp.txt >>$SINGLE_TEST

#awk -vOFS="\t" '{$1=$1}1' temp1.txt >>$SINGLE_TEST


############################### LTP  RESULT Analysis #########################

echo "$TABLELINE" >>$SINGLE_TEST
echo -e " \nLTP 测试结果\n" >>$SINGLE_TEST

if [ -d ${PATH_OF_Ltp} ]
	then
		echo -e "LTP PASS\n" >>$SINGLE_TEST
	else
	    echo -e "LTP FAIL\n" >>$SINGLE_TEST
fi 
















########################################### FINAL P

rm temp* -rf 



