;	GarbelFish 
;	Copyright (C) 2021 p4yy
;
;	This program is free software: you can redistribute it and/or modify
;	it under the terms of the GNU Affero General Public License as published
;	by the Free Software Foundation, either version 3 of the License, or
;	(at your option) any later version.
;
;	This program is distributed in the hope that it will be useful,
;	but WITHOUT ANY WARRANTY; without even the implied warranty of
;	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;	GNU Affero General Public License for more details.
;
;	You should have received a copy of the GNU Affero General Public License
;	along with this program.  If not, see <http:;www.gnu.org/licenses/>.

;	This for 1windows like windows 7 superlite run on vmware and run 2 growtopia.exe inside it 
;	and from 1 active growtopia.exe window search all image in folder image-1/image-shiny to control Growtopia window1 and image-2/image-shiny to control Growtopia window2
#NoEnv
#SingleInstance Off
#NoTrayIcon
Gui,Add,Button,x10 y10 w100 h25 gSelectWindow1,Select Window 1
Gui,Add,Edit,x+10 h25 w120 vGrowtopiaPID1 
Gui,Add,Button,x10 y+10 w100 h25 gSelectWindow2,Select Window 2
Gui,Add,Edit,x+10 h25 w120 vGrowtopiaPID2 
Gui,Add,Button,x10 y+10 w100 h25 gSelectWater1,Select WATER 1
Gui,Add,Edit,x+10  h25 w120 vWaterCoords1 
Gui,Add,Button,x10 y+10 w100 h25 gSelectWater2,Select WATER 2
Gui,Add,Edit,x+10  h25 w120 vWaterCoords2 
Gui,Add,Button,x10 y+10 h25 w100 vSelectBaitButton1 gSelectBait1,Select Bait 1
Gui,Add,Edit,x+10 h25 w120 vSelectBaitEdit1
Gui,Add,Button,x10 y+10 h25 w100 vSelectBaitButton2 gSelectBait2,Select Bait 2
Gui,Add,Edit,x+10 h25 w120 vSelectBaitEdit2
Gui,Add,Button,x10 y+15 h25 w100 gOnEquipment, On DETO
Gui,Add,Button,x+10 h25 w100 gOffEquipment, Off DETO
Gui,Add,Button,x10 y+10 h25 w100 Disabled vSelectEquipmentButton1 gSelectEquipment1,DETO/DRILL 1
Gui,Add,Edit,x+10 h25 w120 Disabled vEquipmentEdit1
Gui,Add,Button,x10 y+10 h25 w100 Disabled vSelectEquipmentButton2 gSelectEquipment2,DETO/DRILL 2
Gui,Add,Edit,x+10 h25 w120 Disabled vEquipmentEdit2
Gui,Add,Button,x10 y+15 w100 h35 gStart vStartButton,Start
Gui,Add,Button,x+10 w120 h35 Disabled vStopButton gStop,Stop
gui,show,,GarbelFish
fishing := "shiny"
return

GuiClose:
	ExitApp
return

OnEquipment:
	fishing := "deto"
	GuiControl,Enabled,SelectEquipmentButton1
	GuiControl,Enabled,SelectEquipmentButton2
	GuiControl,Enabled,EquipmentEdit1
	GuiControl,Enabled,EquipmentEdit2
return

OffEquipment:
	fishing := "shiny"
	GuiControl,Disabled,SelectEquipmentButton1
	GuiControl,Disabled,SelectEquipmentButton2
	GuiControl,Disabled,EquipmentEdit1
	GuiControl,Disabled,EquipmentEdit2
return

SelectEquipment1:
	CoordMode,Mouse,Client
	isPress:=0
	i:= 0
	Loop
	{
		LMouse:=GetKeyState("LButton")
		WinGetTitle,Title,A
		ToolTip,Click to see coord in active window `n window:%Title%
		If(LMouse==False&&isPress==0)
		{
			isPress:=1
		}
		Else If(LMouse==True&&isPress==1)
		{
			i++,isPress:=0
			if(i>=2)
			{
				MouseGetPos,Equipment1X,Equipment1Y
				GuiControl,,EquipmentEdit1,%Equipment1X%`,%Equipment1Y%
				ToolTip,
				Gui,Submit,NoHide
				break
			}
		}
	}
return

SelectEquipment2:
	CoordMode,Mouse,Client
	isPress:=0
	i:= 0
	Loop
	{
		LMouse:=GetKeyState("LButton")
		WinGetTitle,Title,A
		ToolTip,Click to see coord in active window `n window:%Title%
		If(LMouse==False&&isPress==0)
		{
			isPress:=1
		}
		Else If(LMouse==True&&isPress==1)
		{
			i++,isPress:=0
			if(i>=2)
			{
				MouseGetPos,Equipment2X,Equipment2Y
				GuiControl,,EquipmentEdit2,%Equipment2X%`,%Equipment2Y%
				ToolTip,
				Gui,Submit,NoHide
				break
			}
		}
	}
return


SelectBait1:
	CoordMode,Mouse,Client
	isPress:=0
	i:= 0
	Loop
	{
		LMouse:=GetKeyState("LButton")
		WinGetTitle,Title,A
		ToolTip,Click to see coord in active window `n window:%Title%
		If(LMouse==False&&isPress==0)
		{
			isPress:=1
		}
		Else If(LMouse==True&&isPress==1)
		{
			i++,isPress:=0
			if(i>=2)
			{
				MouseGetPos,Bait1X,Bait1Y
				GuiControl,,SelectBaitEdit1,%Bait1X%`,%Bait1Y%
				ToolTip,
				Gui,Submit,NoHide
				break
			}
		}
	}
return

SelectBait2:
	CoordMode,Mouse,Client
	isPress:=0
	i:= 0
	Loop
	{
		LMouse:=GetKeyState("LButton")
		WinGetTitle,Title,A
		ToolTip,Click to see coord in active window `n window:%Title%
		If(LMouse==False&&isPress==0)
		{
			isPress:=1
		}
		Else If(LMouse==True&&isPress==1)
		{
			i++,isPress:=0
			if(i>=2)
			{
				MouseGetPos,Bait2X,Bait2Y
				GuiControl,,SelectBaitEdit2,%Bait2X%`,%Bait2Y%
				ToolTip,
				Gui,Submit,NoHide
				break
			}
		}
	}
return


Start:
	status:="Start"
	GuiControl,Enabled,StopButton
	GuiControl,Disabled,StartButton
	While (status=="Start")
	{
		while (fishing=="shiny")
		{
			while (status=="Start")
			{
				; GrowopiaPID 1 ====================================================
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-shiny\captha.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlSend,,{escape},ahk_pid %GrowtopiaPID1%
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-shiny\water.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%Bait1X% Y%Bait1Y% NA
					Sleep,2000
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA 
					Sleep,2500
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-shiny\block.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA 
					Sleep,2500
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA  
					Sleep,3000
				}
				Else{
					Sleep,0
				}
				; GrowopiaPID 2 ====================================================
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-shiny\captha.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlSend,,{escape},ahk_pid %GrowtopiaPID2%
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-shiny\water.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%Bait2X% Y%Bait2Y% NA
					Sleep,2000
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA 
					Sleep,2500
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-shiny\block.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA 
					Sleep,2500
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA  
					Sleep,3000
				}
				Else{
					Sleep,0
				}
				;===================================================
			}
		}
		while (fishing=="deto")
		{
			while (status=="Start")
			{
				;======================= DETO 1
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-deto\captha.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlSend,,{escape},ahk_pid %GrowtopiaPID1%
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-deto\deto.png
				If (ErrorLevel = 2){
					Sleep,0
				}
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%Equipment1X% Y%Equipment1Y% NA
					Sleep,1000
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA
					Sleep,2000
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%Bait1X% Y%Bait1Y% NA 
					Sleep,1000
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA 
					Sleep,3000
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-deto\water-deto.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%Bait1X% Y%Bait1Y% NA
					Sleep,2000
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA 
					Sleep,2500
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-1\image-deto\block.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA 
					Sleep,2500
					ControlClick,,ahk_pid %GrowtopiaPID1%,,Left,1,X%water1X% Y%Water1Y% NA  
					Sleep,3000
				}
				Else{
					Sleep,0
				}
				;========================== DETO 2
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-deto\captha.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlSend,,{escape},ahk_pid %GrowtopiaPID2%
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-deto\deto.png
				If (ErrorLevel = 2){
					Sleep,0
				}
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%Equipment2X% Y%Equipment2Y% NA
					Sleep,1000
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA
					Sleep,2000
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%Bait2X% Y%Bait2Y% NA 
					Sleep,1000
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA 
					Sleep,3000
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-deto\water-deto.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					Sleep,0
				}
				Else{
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%Bait2X% Y%Bait2Y% NA
					Sleep,2000
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA 
					Sleep,2500
				}
				ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, window-2\image-deto\block.png
				If (ErrorLevel = 2){
					Sleep,0
				} 
				Else If (ErrorLevel = 1){
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA 
					Sleep,2500
					ControlClick,,ahk_pid %GrowtopiaPID2%,,Left,1,X%water2X% Y%Water2Y% NA  
					Sleep,3000
				}
				Else{
					Sleep,0
				}
			}
		}
	}
return

Stop:
	status:="Stop"
	fishing:="Stop"
	GuiControl,Enabled,StartButton
	GuiControl,Disabled,StopButton
return

SelectWindow1:
    TargetWindow := SetWindow1(TargetWindow)
    GuiControl,,GrowtopiaPID1,%TargetWindow%
    Gui,Submit,NoHide
return 

SelectWindow2:
    TargetWindow := SetWindow2(TargetWindow)
    GuiControl,,GrowtopiaPID2,%TargetWindow%
    Gui,Submit,NoHide
return 

SelectWater1:
	CoordMode,Mouse,Client
	isPress:=0
	i:= 0
	Loop
	{
		LMouse:=GetKeyState("LButton")
		WinGetTitle,Title,A
		ToolTip,Click to see coord in active window `n window:%Title%
		If(LMouse==False&&isPress==0)
		{
			isPress:=1
		}
		Else If(LMouse==True&&isPress==1)
		{
			i++,isPress:=0
			if(i>=2)
			{
				MouseGetPos,Water1X,Water1Y
				GuiControl,,WaterCoords1,%Water1X%`,%Water1Y%
				ToolTip,
				Gui,Submit,NoHide
				break
			}
		}
	}
return

SelectWater2:
	CoordMode,Mouse,Client
	isPress:=0
	i:= 0
	Loop
	{
		LMouse:=GetKeyState("LButton")
		WinGetTitle,Title,A
		ToolTip,Click to see coord in active window `n window:%Title%
		If(LMouse==False&&isPress==0)
		{
			isPress:=1
		}
		Else If(LMouse==True&&isPress==1)
		{
			i++,isPress:=0
			if(i>=2)
			{
				MouseGetPos,Water2X,Water2Y
				GuiControl,,WaterCoords2,%Water2X%`,%Water2Y%
				ToolTip,
				Gui,Submit,NoHide
				break
			}
		}
	}
return


SetWindow1(TargetWindow)
{
    isPress:=0
    i:=0
    Loop, 
    {
        LMouse:=GetKeyState("LButton")
        WinGetTitle,Title,A
        ToolTip,Click active window `n Current window: %Title%
        If (LMouse==False&&isPress==0)
        {
            isPress:=1
        }
        Else If (LMouse==True&&isPress==1)
        {
            i++
            isPress:=0
            If (i>=2)
            {
                WinSetTitle,A,,GarbelFish 1
                WinGet,TargetWindow,PID,A 
                ToolTip,
                Break
            }
        }
    }return TargetWindow
}return 

SetWindow2(TargetWindow)
{
    isPress:=0
    i:=0
    Loop, 
    {
        LMouse:=GetKeyState("LButton")
        WinGetTitle,Title,A
        ToolTip,Click active window `n Current window: %Title%
        If (LMouse==False&&isPress==0)
        {
            isPress:=1
        }
        Else If (LMouse==True&&isPress==1)
        {
            i++
            isPress:=0
            If (i>=2)
            {
                WinSetTitle,A,,GarbelFish 2
                WinGet,TargetWindow,PID,A 
                ToolTip,
                Break
            }
        }
    }return TargetWindow
}return 