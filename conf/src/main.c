/************************************************************
Copyright (C), 2017-, shenglong Tech. Co., Ltd.
FileName: main.c
Author: zhangpengfei
Version : 1.0
Date:2017年4月17日17:24:12
Description: //C语言生成shell配置文件 
Function List:  主要函数

***********************************************************/


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <dirent.h> 
#include "my_head.h"
int main (void)
{
	int install_select_id=0;
	char ch_fail;
    system("clear");
 if(access("/home/spec2000-all/myrun.sh",F_OK)==-1) 
  {
  	
	  LINE()
  	  printf("%s\n","当前系统还未安装测试工具");
	  LINE()
      
    while(1)
	{   
		printf("1:安装   2:退出\n");
        if( ! test_judgment(&install_select_id,1,1,2))
        continue;
		else
		{
	        switch (install_select_id)
			{
			case INSTALL_ID: {	
				       printf("开始安装....\n");
					system("bash ./all-test/tools_install.sh");
					system("clear");
					   printf("安装完成！\n");
                    goto install_ok;
					break;
				  }
			  case EXIT_START: { 
					
                    test_exit(0);

				  }
			
			}
		}
		
	}
  }	
  
  
 else //已经安装
 {
   install_ok:
   test_start();
   
 }

 return 0;
}



static int test_start(void)
{
  int install_select_id=0;
  
  char ch_fail;
//test_lable:

while(1)
{
  LINE()
  printf("1:标准测试 2:单项测试 3:使用配置 4:退出\n");
  LINE()

     if( ! test_judgment(&install_select_id,1,1,4))
		 continue;
    else
	{
		switch(install_select_id)
		{
	           case STANDARD_ID :  test_standard();      break; 
               case Individual_ID: test_individual();	 break;        
	           case PERSION_ID:    test_persion_conf();  break;//加载个人配置
		case EXIT:   test_exit(1); 

		}
	
	
	}
}
}

/*
  退出
 */

void test_exit(int status)
{
   exit(status);
}

/*
  输入规范
*/

int test_judgment(int * select_id ,int num, int range_small,int range_large)
{
  
	 char ch_fail;
     printf("++++>");
     if(scanf("%d",select_id)!=num)
	{
        system("clear");
        printf("选择输入！\n");
        for(;ch_fail=getchar()!='\n'&&ch_fail!=EOF;)
    	continue;
		return 0;
        }
	if(*select_id<range_small || *select_id>range_large)
	{
	 printf("请按提示输入\n");
	 return 0;
	}
return 1;
}



/*
  判断IP地址是否合法  
 */
int test_check_ip(const char *ip)  
{  
    int i = 0;  
    int count[2] = {0};  
    const char *s = ".";  
    char temp_ip[16];  
    memset(temp_ip, 0, sizeof(temp_ip));  
    int IPAddr[4] = {0};  
    int pos[3] = {0};  
      
    memcpy(temp_ip, ip, sizeof(temp_ip));  
    for(i = 0; i < strlen(temp_ip); i++)  
    {  
        if(temp_ip[0] != '.' && temp_ip[i] == '.'   
            && temp_ip[i+1] != '\0' && temp_ip[i+1] != '.')  
        {  
            count[0]++;  
        }    
        if(!isdigit(temp_ip[i]))  
        {  
            count[1]++;  
        }  
          
    }  
   
    if(count[0] != 3 || count[1] != 3)  
    {  
        return -1;  
    }  
      
    IPAddr[0] = atoi(strtok(temp_ip, s));  
    IPAddr[1] = atoi(strtok(NULL, s));  
    IPAddr[2] = atoi(strtok(NULL, s));  
    IPAddr[3] = atoi(strtok(NULL, s));  
  
    if ((IPAddr[0] >= 0&&IPAddr[0] <= 255)&&(IPAddr[1] >= 0&&IPAddr[1] <= 255)  
        &&(IPAddr[2] >= 0&&IPAddr[2] <= 255)&&(IPAddr[3] >= 0&&IPAddr[3] <= 255))  
    {     
        return 0;         
    }  
    else  
    {  
        return -1;  
    }  
}  



/*
 标准化测试  
 */

int test_standard(void)
{

  system("bash all-test/tools_biao_test.sh");
 /*
  *  数据处理
  */
  system("bash ./conf/data_process/excel.sh");
  system("clear");
  printf("标准测试结果已经生成（当前目录下）\n");
  return 0; 

}

void test_dele_conf(void)
{ 

  system("rm conf/ecc -rf");
  system("cat ./conf/enable.default >conf/ecc");
}



/*
 单项测试
 */
test_individual()
{
  int single_select_id=0,iozone_count=0,stream_core_num=0,StreamRun_num=0;
  int StressMem_num=0,StressTime_num=0,LtpTime_num=0,Unixbench_CoreNum=0;
  char ipaddr_num[128]={0},save_name[128]={0};
  char cmd[1024]={0};
  while(1)
  {
  		printf("单项测试 1:iozone 2:stream 3:stress 4:ltp \n         5:netperf 6:x11perf 7:unixbench 8:spec2000\n 9:spec2006 10: 重新配置 11:存为模版   12:运行      13:直接退出\n");

/*
    加入选项就ok，注意修改test_judgment的最后一个参数
*/

        if( ! test_judgment(&single_select_id,1,1,13))
        continue;
		else
		{
			switch(single_select_id)
			{
				case 1:{ 
						   while(1)
						   {
					   			printf("请输入要测试的次数：\n");
								if( ! test_judgment(&iozone_count,1,1,10000))
                         		continue;
								else
								{   sprintf(cmd,"echo IozoneRun=%d>>conf/ecc",iozone_count);
								    system(cmd);
						            system("echo 'iozone_enable=1'>>conf/ecc");
									break;
								}
						   }break;
					   }
				case 2:{
						   
						   while(1)
						   {
					   			printf("请输入要测试的核心数 和 测试次数：\n");
								if( ! test_judgment(&stream_core_num,1,1,10000)) 
                         		continue;
                                if( ! test_judgment(&StreamRun_num,1,1,10000))
                                continue;
								else
								{   sprintf(cmd,"echo STREAM_CoreNum=%d>>conf/ecc",stream_core_num);
                                    system(cmd);
                                    sprintf(cmd,"echo StreamRun=%d>>conf/ecc",StreamRun_num);
								    system(cmd);
						            system("echo  'stream_enable=1' >>conf/ecc");
									break;
								}
						   }break;
						   
					   } 
						   
						   
				case 3:{

                          while(1)
                           {
                                printf("请输入要测试的内存大小 和 测试次数：\n");
                                if( ! test_judgment(&StressMem_num,1,1,10000)) 
                                continue;
                                if( ! test_judgment(&StressTime_num,1,1,10000))
                                continue;
                                else
                                {   sprintf(cmd,"echo StressMem=%d>>conf/ecc",StressMem_num);
                                    system(cmd);
                                    sprintf(cmd,"echo StressTime=%d>>conf/ecc",StressTime_num);
                                    system(cmd);
                                    system("echo  'stream_enable=1' >>conf/ecc");
                                    break;
                                }
                           }break;

                        }


				case 4:{

                         while(1)
                           {
                                printf("请输入要测试的时间：\n");
                                if( ! test_judgment(&LtpTime_num,1,1,10000))
                                continue;
                                else
                                {  
                                    sprintf(cmd,"echo LtpTime=%d>>conf/ecc",LtpTime_num);
                                    system(cmd);
                                    system("echo 'ltp_enable=1' >>conf/ecc");
                                    break;
                                }
                           }break;


                  
                }
				case 5:{
                          
                          while(1)
                           {
                                printf("请输入配置IP 例如 192.168.1.1：\n");
                                scanf("%s",ipaddr_num);
                               if(test_check_ip(ipaddr_num)<0 ) 
                               {

                                printf("ip输入不合法,重新输入：\n");
                                continue;

                               }
                                
                            else
                                {  
                                    sprintf(cmd,"echo IPaddr=%s>>conf/ecc",ipaddr_num);
                                    system(cmd);
                                    system("echo 'netperf_enable=1' >>conf/ecc");
                                    break;
                                }
                           }break;


                       }


				case 6:{

                             system("echo 'x11perf_enable=1' >>conf/ecc");
                       }


				case 7:{
                           while(1)
                           {
                                  printf("请输入要测试的核心数：\n");
                                if( ! test_judgment(&Unixbench_CoreNum,1,1,10000))
                                continue;
                                else
                                {  
                                    sprintf(cmd,"echo Unixbench_Core=%d>>conf/ecc",Unixbench_CoreNum);

                                    /*
                                    
                                      注意这里的脚本修改

                                     */
                                    system(cmd);
                                    system("echo 'unixbench_enable=1' >>conf/ecc");
                                    break;
                                }
                           }break;


                        }
                                   
                   
				case 8:{
                         printf("默认测试核心为4核,全测试：\n");      
                         system("echo 'spec2000_enable=1'>>conf/ecc");
                         break;
                       }

				case 9:{

                         printf("默认测试核心为4核：\n");      
                         system("echo 'spec2006_enable=1'>>conf/ecc");
                         break;
                       }

			    case 10:{

                        test_dele_conf();
                        break;

                       }

                case 11:{
                            char*save_name_temp=(char*)malloc(256*(sizeof(char)));
                            printf("请输入保存后的文件名：");
                            scanf("%s",save_name);
                            sprintf(save_name_temp, "./conf/save/%s", save_name);
                            if(access(save_name_temp,F_OK)!=-1)
                            {
                                printf("请更换名字，或者到conf/save/删除同名文件n");
                            }
                            else
                            {
                                printf("%s保存成功！\n",save_name);
                                sprintf(save_name_temp, "cp ./conf/ecc ./conf/save/%s", save_name);
                                system(save_name_temp);
                            }
                            free(save_name_temp);
                            save_name_temp=NULL;
                            break;
                       }

                 
			    case 12:{
                        
                          system("bash all-test/tools_test.sh");

                       }break;
            
			    case 13:{
                        
                        test_exit(1);

                       }
			}

		}
  }		
}

/*
    目录获取
*/

  int test_do_list(char **conf_name)
{
    DIR *dirp;
    struct dirent *mydir;
    char buf[N] = {0};
    int num_id=0,file_num=0;

    if((dirp = opendir("./conf/save")) == NULL)
    {
       printf("fail to opendir\n");
    }
    
    while((mydir = readdir(dirp)) != NULL)
    {
        if(mydir->d_name[0] == '.')
        {
            continue;
        }
        printf("%d:%s   ",++num_id ,mydir->d_name);
        conf_name[num_id]=(char*)mydir->d_name;  //地址拿到 2017年4月17日15:42:53 debug
        if(num_id==100)
        {
            printf("配置文件太多,请手动清除/conf/save/下的文件！，否则自动清除\n");
           
        }
         if(num_id==120)
         {
              printf("配置文件太多,已经清除/conf/save/下的文件！\n");
               system("rm /conf/save/* -rf");

         }
        
    }

   if(num_id)
    printf("配置文件加载完毕！\n");
   else
   {
    printf("您当前还没有配置文件哦！返回重新选择\n"); //调回
    return 0;
   }
    return num_id;   
}



/*
  加载个人配置 
 */

int test_persion_conf(void)
{
   int test_persion_num=0,install_select_id=0,file_num_id;
   char * conf_name[128]={0};
   char cmd[512]={0};

   LINE()
   printf("当前已经保存的配置文件有：\n");
   LINE()
  if( !(file_num_id=test_do_list(conf_name)))
  {
  
   return 0;
  }
   printf("请您输入配置文件前面的数字选定配置文件\n");
   while(1)
   {
     if(!test_judgment(&test_persion_num,1,1,file_num_id))
     continue;
     else break;
   }
   system("rm conf/ecc -rf");
   sprintf(cmd ,"cp ./conf/save/%s ./conf/ecc ",conf_name[test_persion_num]);
   system(cmd);
   system("clear");
   int i=0;
   LINE()
   while(1)
    {   
       while(i++!=100) {
           printf("\r %d%%", i);
           usleep(2000);
           fflush(NULL);
       }//only test
       
       printf("您选定的配置/文件加载完毕！\n 运行 请按：1 退出 请按：2\n");
       LINE()
        if( ! test_judgment(&install_select_id,1,1,2))
        continue;
        else
        {
            switch (install_select_id)
            {
            case 1: {  
                    
                    printf("开始运行....\n");
                    system("bash all-test/tools_test.sh");
                    break;
                    }
            case 2: { 
                    
                    test_exit(0);

                    }
            
            }
        }
        
    }


}

