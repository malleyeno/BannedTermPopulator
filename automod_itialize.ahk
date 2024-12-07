#SingleInstance Force
#MaxThreadsPerHotkey 3
; If you're using a specific encoding, change the below.
; Otherwise, leave it alone or else things like emoji will break!
FileEncoding "UTF-8"
    
#z::  ; Win+Z hotkey (change this hotkey to suit your preferences).
{
    ; the Win+Z hotkey suspension was from the docs page! Learn more:
    ; https://www.autohotkey.com/docs/v2/FAQ.htm#repeat
    static KeepWinZRunning := false
    if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
    {
        KeepWinZRunning := false  ; Signal that thread's loop to stop.
        return  ; End this thread so that the one underneath will resume and see the change made by the line above.
    }
    ; Otherwise:
    KeepWinZRunning := true

    ; USER PLEASE READ THIS
    ; There are two options about how you can give a banned terms list to AHK.
    ; Option 1 is to give it a hardcoded path. This is convenient to avoid being
    ;   asked to give this file for every run.
    ; Option 2 is to be asked to give it a file path every time. This is the 
    ;   default because i'm not expecting people to be editing code here.
    ; (Option 0 is an example file that you can use to test that the script is
    ;   working before you invest time developing a blocked term list. But don't
    ;   use it as your production solution unless you really want to.)
    
    ; IF YOU WANT TO SWITCH FROM OPTION 2 TO OPTION 1 or :
    ;    - ADD ; to the start of EVERY line for the option you are TURNING OFF
    ;       to so that it is commented out and won't run
    ;    - REMOVE ; from the start of EVERY line for the option you WANT TO BE ON
    ;       so that it is uncommented and will run
    ;    - SAVE the .ahk file, and the RELOAD it if it is already running. AHK
    ;       won't automatically reload files like that, it is manual.

    ; OPTION 0 is a example of how a file works with the script. You can use
    ;   this to see if the script is working before you invest time developing
    ;   an actual blocked terms file. But after that, you should comment it out.
    ; ---- option 0 start, (un)comment above -----
    ;bannedTermsFile := A_WorkingDir "\example.txt"
    ; ---- option 0 end, (un)comment above -------

    ; Option 1: Specify the file you want to read all the time.
    ; ----- option 1 start, (un)comment below ----
    ; bannedTermsFile := "C:\full\path\to\file.txt"
    ; ----- option 1 end, (un)comment above ------

    ; Option 2: Get asked where your file is located in a dialog box each time.
    ; ----- option 2 start, (un)comment below ----
    bannedTermsInput := InputBox(
        "Where is the path to your banned terms file? (Shift-Right Click it, then Copy as Path but remove the quotes at beginning/end.)"
    )
    if (bannedTermsInput.Result == "Cancel") 
        {
            KeepWinZRunning := false  ; Signal that thread's loop to stop.
            return  ; End this thread so that the one underneath will resume and see the change made by the line above.
        }
    bannedTermsFile := bannedTermsInput.Value
    ; ----- option 2 end, (un)comment above ------


    Loop read, bannedTermsFile
    ;Loop on each new phrase in the kickstart file
    {
        ; The next four lines are the action you want to repeat (update them to suit your preferences):
        ToolTip "Blocking " A_LoopReadLine " - Press Win-Z to stop script."
        ;MsgBox A_LoopReadLine " detected."
        Sleep 100

        ; Start at the automod term input field! Then hit Win+Z to start
        SendText A_LoopReadLine
        Sleep 100
        Send "{enter}"
        Sleep 100
        Send "^a"
        Sleep 100
        Send "{Backspace}"
        ToolTip
    

        ; But leave the rest below unchanged.
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
            break  ; Break out of this loop.
    }
    KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.

}
#MaxThreadsPerHotkey 1