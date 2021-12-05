#NoEnv
SetBatchLines, -1
Return

Esc:: ExitApp

^X::
StartSelection() {
   Hotkey, LButton, Select, On
   ReplaceSystemCursors("IDC_CROSS")
}

Select() {
   static hGui := CreateSelectionGui()
   hHook := SetHook(WH_MOUSE_LL := 14, "LowLevelMouseProc", hGui)
   KeyWait, LButton
   ReplaceSystemCursors("")
   Hotkey, LButton, Off
   SetHook(hHook)
   WinGetPos, X, Y, W, H, ahk_id %hGui%
   Gui, %hGui%:Show, Hide
   ShowSketch(X, Y, W, H)
}

ShowSketch(X, Y, W, H) {
   static oBitmap := [], hParent, hSketch := CreateSketchGui(300, 200, hParent, oBitmap), hPic, hBM
   ( hBM && DllCall("DeleteObject", Ptr, hBM) )
   ( hPic && DllCall("DestroyWindow", Ptr, hPic) )
   hBM := HBitmapFromScreen(X, Y, W, H)
   oBitmap[1] := hBM
   GetDimensions(300, 200, X, Y, W, H)
   try Gui, %hSketch%: Add, Pic, hwndhPic x%X% y%Y% w%W% h%H%, HBITMAP:*%hBM%
   Gui, %hParent%: Show
}

GetDimensions(maxWidth, maxHeight, ByRef X, ByRef Y, ByRef W, ByRef H) {
   if (W > maxWidth || H > maxHeight) {
      maxRatio := maxWidth/maxHeight
      ratio := W/H
      if (maxRatio > ratio) {
         H := maxHeight
         W := H*ratio
         X := (maxWidth - W)/2
         Y := 0
      }
      else {
         W := maxWidth
         H := W/ratio
         X := 0
         Y := (maxHeight - H)/2
      }
   }
   else {
      X := (maxWidth - W)/2
      Y := (maxHeight - H)/2
   }
}
   
SetHook(hook, fn := "", eventInfo := "", isGlobal := true) {
   static exitFunc
   if !fn {
      DllCall("UnhookWindowsHookEx", "Ptr", hook)
      OnExit(exitFunc, 0)
      exitFunc := ""
   }
   else {
      hHook := DllCall("SetWindowsHookEx", "Int", hook, "Ptr", RegisterCallback(fn, "Fast", 3, eventInfo)
                                         , "Ptr", DllCall("GetModuleHandle", "UInt", 0, "Ptr")
                                         , "UInt", isGlobal ? 0 : DllCall("GetCurrentThreadId"), "Ptr")
      ( exitFunc && OnExit(exitFunc, 0) )
      exitFunc := Func(A_ThisFunc).Bind(hHook, "", "")
      OnExit(exitFunc)
      Return hHook
   }
}

LowLevelMouseProc(nCode, wParam, lParam) {
   static WM_MOUSEMOVE := 0x200, WM_LBUTTONUP := 0x202
        , coords := [], startMouseX, startMouseY, hGui
        , timer := Func("LowLevelMouseProc").Bind("timer", "", "")
   
   if (nCode = "timer") {
      while coords[1] {
         point := coords.RemoveAt(1)
         mouseX := point[1], mouseY := point[2]
         x := startMouseX < mouseX ? startMouseX : mouseX
         y := startMouseY < mouseY ? startMouseY : mouseY
         w := Abs(mouseX - startMouseX)
         h := Abs(mouseY - startMouseY)
         try Gui, %hGUi%: Show, x%x% y%y% w%w% h%h% NA
      }
   }
   else {
      (!hGui && hGui := A_EventInfo)
      if (wParam = WM_LBUTTONUP)
         startMouseX := startMouseY := ""
      if (wParam = WM_MOUSEMOVE)  {
         mouseX := NumGet(lParam + 0, "Int")
         mouseY := NumGet(lParam + 4, "Int")
         if (startMouseX = "") {
            startMouseX := mouseX
            startMouseY := mouseY
         }
         coords.Push([mouseX, mouseY])
         SetTimer, % timer, -10
      }
      Return DllCall("CallNextHookEx", Ptr, 0, Int, nCode, UInt, wParam, Ptr, lParam)
   }
}

ReplaceSystemCursors(IDC = "")
{
   static IMAGE_CURSOR := 2, SPI_SETCURSORS := 0x57
        , exitFunc := Func("ReplaceSystemCursors").Bind("")
        , SysCursors := { IDC_APPSTARTING: 32650
                        , IDC_ARROW      : 32512
                        , IDC_CROSS      : 32515
                        , IDC_HAND       : 32649
                        , IDC_HELP       : 32651
                        , IDC_IBEAM      : 32513
                        , IDC_NO         : 32648
                        , IDC_SIZEALL    : 32646
                        , IDC_SIZENESW   : 32643
                        , IDC_SIZENWSE   : 32642
                        , IDC_SIZEWE     : 32644
                        , IDC_SIZENS     : 32645 
                        , IDC_UPARROW    : 32516
                        , IDC_WAIT       : 32514 }
   if !IDC {
      DllCall("SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0)
      OnExit(exitFunc, 0)
   }
   else  {
      hCursor := DllCall("LoadCursor", Ptr, 0, UInt, SysCursors[IDC], Ptr)
      for k, v in SysCursors  {
         hCopy := DllCall("CopyImage", Ptr, hCursor, UInt, IMAGE_CURSOR, Int, 0, Int, 0, UInt, 0, Ptr)
         DllCall("SetSystemCursor", Ptr, hCopy, UInt, v)
      }
      OnExit(exitFunc)
   }
}

CreateSelectionGui() {
   Gui, New, +hwndhGui +Alwaysontop -Caption +LastFound +ToolWindow +E0x20 -DPIScale
   WinSet, Transparent, 130
   Gui, Color, FFC800
   Return hGui
}

CreateSketchGui(W, H, ByRef hParent, oBitmap) {
   Gui, New, +hwndhParent, Sketch
   Gui, Color, DDDDDD
   Gui, Add, Button, % "x" W + 10 - 80 " y" H + 20  " w80", Save
   handler := Func("SaveBitmapToFile").Bind(oBitmap)
   GuiControl, +g, Button1, % handler
   Gui, New, +hwndhSketch +Parent%hParent% +ToolWindow -Caption +Border
   Gui, Color, 808080
   Gui, Show, NA x10 y10 w%W% h%H%
   Gui, %hParent%: Show, Hide  w320 h263 ;w820 h653
   Return hSketch
}

SaveBitmapToFile(oBitmap) {
   ;filepath := "screenshot.png"
   FileSelectFile, filePath, 16,, Save the image as:, Images (*.png; *.bmp; *.tiff; *.tif; *.jpeg; *.jpg; *.gif)
   if !filePath
      Return
   oGdip := new GDIp
   pBitmap := oGdip.CreateBitmapFromHBITMAP(oBitmap[1])
   oGdip.SaveBitmap(pBitmap, filePath)
   oGdip.DisposeImage(pBitmap)
}

HBitmapFromScreen(X, Y, W, H) {
   HDC := DllCall("GetDC", "Ptr", 0, "UPtr")
   HBM := DllCall("CreateCompatibleBitmap", "Ptr", HDC, "Int", W, "Int", H, "UPtr")
   PDC := DllCall("CreateCompatibleDC", "Ptr", HDC, "UPtr")
   DllCall("SelectObject", "Ptr", PDC, "Ptr", HBM)
   DllCall("BitBlt", "Ptr", PDC, "Int", 0, "Int", 0, "Int", W, "Int", H
                   , "Ptr", HDC, "Int", X, "Int", Y, "UInt", 0x00CC0020)
   DllCall("DeleteDC", "Ptr", PDC)
   DllCall("ReleaseDC", "Ptr", 0, "Ptr", HDC)
   Return HBM
}

class GDIp  {
   __New() {
      if !DllCall("GetModuleHandle", Str, "gdiplus", Ptr)
         DllCall("LoadLibrary", Str, "gdiplus")
      VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
      DllCall("gdiplus\GdiplusStartup", UPtrP, pToken, Ptr, &si, Ptr, 0)
      this.token := pToken
   }
   
   __Delete()  {
      DllCall("gdiplus\GdiplusShutdown", Ptr, this.token)
      if hModule := DllCall("GetModuleHandle", Str, "gdiplus", Ptr)
         DllCall("FreeLibrary", Ptr, hModule)
   }

   CreateBitmapFromHBITMAP(hBitmap, Palette=0)  {
      DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBitmap, Ptr, Palette, PtrP, pBitmap)
      return pBitmap
   }

   SaveBitmap(pBitmap, ByRef info, tobuff := false, JPEGquality := 75)
   {
      ; info: if copy to the buffer, specify the file extansion, if to the file — the file path
      if tobuff
         Extension := info
      else
         SplitPath, info,,, Extension
      if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
         return -1

      DllCall("gdiplus\GdipGetImageEncodersSize", UintP, nCount, UintP, nSize)
      VarSetCapacity(ci, nSize)
      DllCall("gdiplus\GdipGetImageEncoders", UInt, nCount, UInt, nSize, Ptr, &ci)
      if !(nCount && nSize)
         return -2
      
      Loop, % nCount  {
         sString := StrGet(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
         if !InStr(sString, "*." Extension)
            continue
         
         pCodec := &ci+idx
         break
      }
      
      if !pCodec
         return -3
      
      if RegExMatch(Extension, "i)^J(PG|PEG|PE|FIF)$") && JPEGquality != 75  {
         DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, UintP, nSize)
         VarSetCapacity(EncoderParameters, nSize, 0)
         DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, UInt, nSize, Ptr, &EncoderParameters)
         Loop, % NumGet(EncoderParameters, "UInt")
         {
            elem := (24+A_PtrSize)*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
            if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
            {
               p := elem+&EncoderParameters-pad-4
               NumPut(JPEGquality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
               break
            }
         }      
      }
      if !tobuff
         E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, WStr, info, Ptr, pCodec, UInt, p ? p : 0)
      else  {
         DllCall( "ole32\CreateStreamOnHGlobal", UInt, 0, Int, 1, PtrP, pStream )
         if !E := DllCall( "gdiplus\GdipSaveImageToStream", Ptr, pBitmap, Ptr, pStream, Ptr, pCodec, UInt, p ? p : 0 )  {
            DllCall( "ole32\GetHGlobalFromStream", Ptr, pStream, PtrP, hData )
            pData := DllCall( "GlobalLock", Ptr, hData, Ptr )
            nSize := DllCall( "GlobalSize", Ptr, hData, Ptr )
            VarSetCapacity( info, 0), VarSetCapacity( info, nSize, 0 )
            DllCall( "RtlMoveMemory", Ptr, &info, Ptr, pData, UInt, nSize )
            DllCall( "GlobalUnlock", Ptr, hData )
            DllCall( "GlobalFree", Ptr, hData )
         }
         ObjRelease(pStream)
      }
      return E ? -4 : tobuff ? nSize : 0
   }
   
   DisposeImage(pBitmap)  {
      return DllCall("gdiplus\GdipDisposeImage", Ptr, pBitmap)
   }
}