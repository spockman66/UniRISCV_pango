软件源代码相关

1. C软件程序
	coremark：CPU跑分程序，修改了coremark_portme.c相关函数
	uart：通过串口打印‘Hello World！’字符
2. python脚本
	conv_bin_to_txt.py：将二进制程序文件转化为RAM初始化文件
3. dat文件
	工程中的DRAM IP模块叫做BRAM，地址线宽度14，数据线宽度32，初始化文件为hex格式
	选择uart_tx_test.dat，编译硬件后可以实现串口输出
	选择coremark_test.dat，编译硬件后可以Coremark跑分测试，用时约为84s