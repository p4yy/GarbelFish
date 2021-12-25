; 	 GarbelFish 
; 	 Copyright (C) 2021 p4yy
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU Affero General Public License as published
;    by the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU Affero General Public License for more details.
;
;    You should have received a copy of the GNU Affero General Public License
;    along with this program.  If not, see <http:;www.gnu.org/licenses/>.

#NoEnv
#SingleInstance Off
#NoTrayIcon
;#Include Gdip.ahk

Gui,Add,Button,x10 y10 w80 h25 gSelectWindow,Select Window
Gui,Add,Edit,x+10 h25 w100 vWindow
Gui,Add,Button,x10 y+10 w80 h25 gSelectWater,Select WATER
Gui,Add,Edit,x+10  h25 w100 vWaterCoords 
Gui,Add,Button,x10 y+10 h25 w80 vSelectBaitButton gSelectBait,Select BAIT
Gui,Add,Edit,x+10 h25 w100 vSelectBaitEdit
Gui,Add,Button,x10 y+30 h25 w80 gOnEquipment, On DETO
Gui,Add,Button,x+10 h25 w80 gOffEquipment, Off DETO
Gui,Add,Button,x10 y170 h25 w80 Disabled vSelectEquipmentButton gSelectEquipment,DETO/DRILL
Gui,Add,Edit,x+10 h25 w100 Disabled vEquipmentEdit
Gui,Add,Button,x10 y+15 w90 h35 gStart vStartButton,Start
Gui,Add,Button,x+10 w90 h35 Disabled vStopButton gStop,Stop
gui,show,,GarbelFish
fishing := "shiny"
return

GuiClose:
	ExitApp
return

OnEquipment:
	fishing := "deto"
	GuiControl,Enabled,SelectEquipmentButton
	GuiControl,Enabled,EquipmentEdit
return

OffEquipment:
	fishing := "shiny"
	GuiControl,Disabled,SelectEquipmentButton
	GuiControl,Disabled,EquipmentEdit
return

SelectEquipment:
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
			MouseGetPos,EquipmentX,EquipmentY
			GuiControl,,EquipmentEdit,%EquipmentX%`,%EquipmentY%
			ToolTip,
			Gui,Submit,NoHide
			break
		}
	}
}
return


SelectBait:
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
			MouseGetPos,BaitX,BaitY
			GuiControl,,SelectBaitEdit,%BaitX%`,%BaitY%
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
While (status=="Stop")
{
	return
}
While (status=="Start")
{
	while (fishing=="shiny")
	{
		while (status=="Start")
		{
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-shiny\captha.png
			If (ErrorLevel = 2){
				Sleep,0
			} 
			Else If (ErrorLevel = 1){
				Sleep,0
			}
			Else{
				ControlSend,,{escape},ahk_pid %Window%
			}
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-shiny\water.png
			If (ErrorLevel = 2){
				Sleep,0
			} 
			Else If (ErrorLevel = 1){
				Sleep,0
			}
			Else{
				ControlClick,,ahk_pid %Window%,,Left,1,X%BaitX% Y%BaitY% NA
				Sleep,2000
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA 
				Sleep,2500
			}
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-shiny\block.png
			If (ErrorLevel = 2){
				Sleep,0
			} 
			Else If (ErrorLevel = 1){
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA 
				Sleep,2500
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA  
				Sleep,3000
			}
			Else{
				Sleep,0
			}
		}
	}
	while (fishing=="deto")
	{
		while (status=="Start")
		{
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-deto\captha.png
			If (ErrorLevel = 2){
				Sleep,0
			} 
			Else If (ErrorLevel = 1){
				Sleep,0
			}
			Else{
				ControlSend,,{escape},ahk_pid %Window%
			}
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-deto\deto.png
			If (ErrorLevel = 2){
				Sleep,0
			}
			Else If (ErrorLevel = 1){
				Sleep,0
			}
			Else{
				ControlClick,,ahk_pid %Window%,,Left,1,X%EquipmentX% Y%EquipmentY% NA
				Sleep,1000
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA
				Sleep,2000
				ControlClick,,ahk_pid %Window%,,Left,1,X%BaitX% Y%BaitY% NA 
				Sleep,1000
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA 
				Sleep,3000
			}
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-deto\water-deto.png
			If (ErrorLevel = 2){
				Sleep,0
			} 
			Else If (ErrorLevel = 1){
				Sleep,0
			}
			Else{
				ControlClick,,ahk_pid %Window%,,Left,1,X%BaitX% Y%BaitY% NA
				Sleep,2000
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA 
				Sleep,2500
			}
			ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, image-deto\block.png
			If (ErrorLevel = 2){
				Sleep,0
			} 
			Else If (ErrorLevel = 1){
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA 
				Sleep,2500
				ControlClick,,ahk_pid %Window%,,Left,1,X%waterX% Y%WaterY% NA  
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

SelectWindow:
    TargetWindow := SetWindow(TargetWindow)
    GuiControl,,Window,%TargetWindow%
    Gui,Submit,NoHide
return 

SelectWater:
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
			MouseGetPos,WaterX,WaterY
			GuiControl,,WaterCoords,%WaterX%`,%WaterY%
			ToolTip,
			Gui,Submit,NoHide
			break
		}
	}
}
return


SetWindow(TargetWindow)
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
                WinSetTitle,A,,Growtopia
                WinGet,TargetWindow,PID,A 
                ToolTip,
                Break
            }
        }
    }return TargetWindow
}return 