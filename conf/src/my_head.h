#ifndef __MY_HEADH_
#define __MY_HEADH_

static int test_start(void);
static int test_individual(void);
static int test_persion(void);
void test_exit(int status);
int  test_judgment(int * select_id ,int num, int range_small,int range_large);
void test_dele_conf(void);
int  test_persion_conf(void);
int test_do_list(char **conf_name);
int test_standard(void);
#define  INSTALL_ID       1
#define  STANDARD_ID      1
#define  Individual_ID    2	       
#define  PERSION_ID       3
#define  EXIT             4
#define  EXIT_START       2
#define  N 128
#define  LINE()           printf("**************************************\n");
#define RESULT test_result
#endif
