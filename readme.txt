1.在运行顶层目录的start的时候会编译c语言并执行
2.执行的时候，根据用户输入在conf下生成一个ecc的文件，该文件内容主要是各个测试项的开关，以及参数
3.ecc文件被包入到all-test文件夹下的tools_test脚本，在执行单项测试的时候开始测试的时候C语言会调用tools_test开始执行。
执行的结果会放到当我目录下的test_result
4.标准测试，C语言会调用all-test下的tools_biao_test.sh
结果在home目录下，但是会调用\conf\data_process\excel.sh进行结果处理，处理结果生成在当前目录，名字为biaozhun.txt


——————————————
待解决问题

1.图形化测试结果重定向还未解决

2.张雨生版的测试方法还未整合

3.netperf测试方法有待确定



