#include <nds.h>
#include <dswifi7.h>

void vBlankHandler(void)
{
	Wifi_Update();
}

void vCountHandler()
{
	inputGetAndSend();
}

void powerButtonHandler()
{
	fifoSendValue32(FIFO_USER_03, 0xfe);
}

int main()
{
	irqInit();
	fifoInit();

	while (1)
	{
		swiWaitForVBlank();
	}
	return 0;
}
