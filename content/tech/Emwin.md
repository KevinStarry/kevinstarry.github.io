---
title: "Emwin"
date: 2021-01-26T22:39:09+08:00
Description: ""
Tags: []
Categories: []
DisableComments: false
---
# GUI工具说明
emwin有自己的的GUI设计工具，uCGUIBuilder是基于emwin开发的，使用uCGUIBuilder即可。

# 快速上手
官网下载emwin，如SeggerEval_WIN32_MSVC_MinGW_GUI_V616，压缩包里的文件解压后找到后缀.sln的文件，直接运行（VisualStudio)就会加载项目，这个时候可以看到项目中有很多文件，直接在VisualStudio中点击本地Windows调试，就会出现官方的显示界面，此时说明基本不存在缺少文件的问题，可以安心使用了。

为什么直接运行Windows调试就会有结果呢？因为在工程项目Application文件夹下有一个GUIDEMO_Start.c文件，这个文件含有入口函数。

使用uCGUIBuilder图形化界面设计布局，应该很容易就能上手，随便绘制一个界面，添加点控件，然后保存。随后使用VisualStudio将文件保存到某个位置。正常会输出三个文件。将其中的.c文件直接复制到VisualStudio中的emwin项目下，然后从项目中删除GUIDEMO_Start.c文件，本地Windows调试就可以看到刚刚设计的界面。当然，也许有些细节问题，不过这不重要，因为整个流程已经走完了。细节的问题，自然是要深入去理解。

# GUI比对
对于初学者来说，emwin官方提供的GUIBuilder.exe和uCGUIBuilder.exe设计产生的.c文件是有些区别的，官方GUIBuilder设计产生的.c文件不能直接在项目中运行，需要进行一些操作。

# 版本问题
不同的emwin版本对应的Visual Studio版本不一样，并非越新的越好，入门遇见这种问题可能会不知所以然。

# uCGUIBuilder设计的空界面代码浅析
以下所有分析均为个人理解，不代表正确观点，可能有很多错误
``` C
#include <stddef.h>
#include "GUI.h"
#include "DIALOG.h"

#include "WM.h"
#include "BUTTON.h"
#include "CHECKBOX.h"
#include "DROPDOWN.h"
#include "EDIT.h"
#include "FRAMEWIN.h"
#include "LISTBOX.h"
#include "MULTIEDIT.h"
#include "RADIO.h"
#include "SLIDER.h"
#include "TEXT.h"
#include "PROGBAR.h"
#include "SCROLLBAR.h"
#include "LISTVIEW.h"

static const GUI_WIDGET_CREATE_INFO _aDialogCreate[] = {
    { FRAMEWIN_CreateIndirect,  "Caption",           0,                       0,  0,  320,240,FRAMEWIN_CF_MOVEABLE,0}
};

void PaintDialog(WM_MESSAGE * pMsg)
{
    WM_HWIN hWin = pMsg->hWin;

}

void InitDialog(WM_MESSAGE * pMsg)
{
    WM_HWIN hWin = pMsg->hWin;
    //
    //FRAMEWIN
    //
    FRAMEWIN_AddCloseButton(hWin, FRAMEWIN_BUTTON_RIGHT, 0);
    FRAMEWIN_AddMaxButton(hWin, FRAMEWIN_BUTTON_RIGHT, 1);
    FRAMEWIN_AddMinButton(hWin, FRAMEWIN_BUTTON_RIGHT, 2);

}

static void _cbCallback(WM_MESSAGE * pMsg) 
{
    int NCode, Id;
    WM_HWIN hWin = pMsg->hWin;
    switch (pMsg->MsgId) 
    {
        case WM_PAINT:
            PaintDialog(pMsg);
            break;
        case WM_INIT_DIALOG:
            InitDialog(pMsg);
            break;
        case WM_KEY:
            switch (((WM_KEY_INFO*)(pMsg->Data.p))->Key) 
            {
                case GUI_KEY_ESCAPE:
                    GUI_EndDialog(hWin, 1);
                    break;
                case GUI_KEY_ENTER:
                    GUI_EndDialog(hWin, 0);
                    break;
            }
            break;
        case WM_NOTIFY_PARENT:
            Id = WM_GetId(pMsg->hWinSrc); 
            NCode = pMsg->Data.v;        
            switch (Id) 
            {
                case GUI_ID_OK:
                    if(NCode==WM_NOTIFICATION_RELEASED)
                        GUI_EndDialog(hWin, 0);
                    break;
                case GUI_ID_CANCEL:
                    if(NCode==WM_NOTIFICATION_RELEASED)
                        GUI_EndDialog(hWin, 0);
                    break;

            }
            break;
        default:
            WM_DefaultProc(pMsg);
    }
}


void MainTask(void) 
{ 
    GUI_Init();
    WM_SetDesktopColor(GUI_WHITE);      /* Automacally update desktop window */
    WM_SetCreateFlags(WM_CF_MEMDEV);  /* Use memory devices on all windows to avoid flicker */
    //PROGBAR_SetDefaultSkin(PROGBAR_SKIN_FLEX);
    //FRAMEWIN_SetDefaultSkin(FRAMEWIN_SKIN_FLEX);
    //PROGBAR_SetDefaultSkin(PROGBAR_SKIN_FLEX);
    //BUTTON_SetDefaultSkin(BUTTON_SKIN_FLEX);
    //CHECKBOX_SetDefaultSkin(CHECKBOX_SKIN_FLEX);
    //DROPDOWN_SetDefaultSkin(DROPDOWN_SKIN_FLEX);
    //SCROLLBAR_SetDefaultSkin(SCROLLBAR_SKIN_FLEX);
    //SLIDER_SetDefaultSkin(SLIDER_SKIN_FLEX);
    //HEADER_SetDefaultSkin(HEADER_SKIN_FLEX);
    //RADIO_SetDefaultSkin(RADIO_SKIN_FLEX);
	while(1)
	{
        GUI_ExecDialogBox(_aDialogCreate, GUI_COUNTOF(_aDialogCreate), &_cbCallback, 0, 0, 0);
	}
}

```

说明：删除了多余的注释文字，这是使用uCGUIBuilder.exe新建的一个空窗体的代码

## 分析
对于C语言，我们首先看主函数，末尾的MainTask()函数就是整个项目的入口函数，如果之前有看过GUIDEMO_Start.c文件，就可以发现，里面也有一个MainTask().

MainTask函数中GUI_Init()，望文生义即初始化。下面的一堆代码，包含注释的代码都可以删掉，最精简的MainTask()可以只留GUI_Init,和while里面的循环体。while中的GUI_ExecDialogBox(_aDialogCreate, GUI_COUNTOF(_aDialogCreate), &_cbCallback, 0, 0, 0);最重要的地方在于回调函数_cbCallback。

先看_aDialogCreate，这个在最前面，可以看到里面有FRAMEWIN_CreateIndirect,这个表示的是一个框架，如果想创建一个空白的界面那么应该使用Window_CreateIndirect,后面的具体参数查参考手册，大概是这样的`Window_CreateIndirect,  "Caption",0, 0,  0,  320,240, 0 ,0 ,0` ，这里要注意，在InitDialog函数中，还有FRAMEWIN的三个按钮控件，如果使用Window_CreateIndirect, 请删除InitDialog中的相关控件。320，240表示的是窗口的宽高。

仿真器的宽高参数在项目Config文件夹中的LCDconf.c中，找到`#define XSIZE_PHYS  240 #define YSIZE_PHYS  320 `修改即可。

如果使用uCGUIBuilder创建的控件，如Text，Button等，则在_aDialogCreate中会出现TEXT_CreateIndirect，BUTTON_CreateIndirect等代码。

从上往下看，PaintDialog，这个函数里字面理解就是绘制类的代码了，2D绘图，矩形框，圆形，多边形，等等。

InitDialog函数中，写一些基本的初始化控件。

最后看回调函数，_cbCallback，之里面只需要关注上面出现的函数，在WM_PAINT,WM_INIT_DIALOG,中出现了上面的两个函数，也就是说，其实里面的内容是可以直接在这里面写的，但是以函数的方式写更易于阅读，便于理解。

整个文件除了MainTask,和回调函数，以及_aDialogCreate，其他的是都可以删除的。

## 改进
实际中我们自己的代码可以都在PaintDialog中写，比如文本的创建，查API手册我们可以找到
```
原型
TEXT_Handle TEXT_CreateEx(int x0, int y0,
 int xsize, int ysize,
 WM_HWIN hParent, int WinFlags,
 int ExFlags, int Id,
 const char * pText);
```
怎么理解这段代码呢？后面的许多控件都有类似的表达，例如按钮是BUTTON_Handle.编辑框是EDIT_Handle.这个是用来创建句柄的，和后面的函数相关，例如我需要对某个文本框调整颜色，调整字体，调整位置，怎么做呢？查API手册会得到
`void TEXT_SetFont(TEXT_Handle hObj, const GUI_FONT * pFont); void TEXT_SetText(TEXT_Handle hObj, const char * s); `
这些都该怎么用呢？这里其实是有两套体系的。直接使用uCGUIBuilder.exe设计好布局，然后看代码，就会明白，这里就不多做说明。
在PaintDialog函数中有WM_HWIN hWin = pMsg - > hWin;这段代码的意思因当时指针指向当前窗口，在下面写我们要写的代码。

如我想创建一个文本框，然后设置字体。
```C
TEXT_Handle hText1;
hText1 = TEXT_CreateEx(100,120,30,20,0,WM_CF_SHOW,TEXT_CF_HCENTER|TEXT_CF_VCENTER,GUI_ID_TEXT1, "文本框1");
//事实上，我们在创建TEXT_CreateEx时候已经对文本进行了位置调整，和设置文本框文字
TEXT_SetFont(hText1,&GUI_Font8_1);
//hText1 就是我们创建的ID为GUI_ID_TEXT1文本框的句柄，当然也可通过窗口函数，以及ID获取句柄，不过没有必要。
````
对于一个新手来说，直接在PaintDialog函数中写就好了，当然，不喜欢这个函数名自己改就是了，在回调函数中修改为你改后的名字就好了。

# 番外
很多时候，有些函数即使我们设置了，但是并不一定会生效，例如设置窗口背景色，设置button颜色。这些有各种各样的原因，需要自行搜索获取答案，也有些答案是找不到的。这种时候，除了看官方的API手册就只能请教他人或者自行理解了。

在项目工程文件中有一个Sample文件夹，里面有一个Tutorial文件夹，里面有非常多的官方例程源码，只需鼠标右键点击教程文件中的某个.c文件，找到属性，在Visul Studio弹出的对话框中，找到常规，找到从生成项目中排除，选择否。然后运行就可以观看官方例程的效果图。这里注意整个项目只能有一个MainTask函数，换句话说，如果之前自己写的MainTask需要暂时从项目中排除，才可以展示官方代码效果。

# 提高
1. 字体的导入以及使用，字体抗锯齿处理
2. 图片的导入以及使用
3. 2D绘制各种图形
4. 官方附带Tool文件夹中含有各种工具，有不同的用途

# 参考
安富莱5.4.2教程，里面不仅仅有API手册参考，还告诉你很多东西怎么去使用。

