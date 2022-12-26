SetWorkingDir %A_ScriptDir%  ; ワーキングディレクトリを明示的に指定
#SingleInstance Ignore

; ========= 変数 ==========

KEY_SEND_DELAY = 200 ; メニュー間の移動が早い場合はこの値を上げる
KEY_PRESS_DELAY = 100 ; キーが押されない場合はこの値を上げる
DELAY_MENU = 1200

; ==============================

launch_dir = %A_ScriptDir%

WinActivate, ahk_exe GTA5.exe ; 常にフォーカスを合わせるためにウィンドウをアクティブ化

SetKeyDelay, KEY_SEND_DELAY, KEY_PRESS_DELAY

Hotkey, F10, Shutdown_Script
Hotkey, F11, Pause_Script

Sleep, 3200

; 小文字じゃないとたまにStartキーが押される なんで
Send {esc}            ; メニュー表示
Sleep, DELAY_MENU
Send {d}              ; ONLINEメニューに移動
Sleep, DELAY_MENU
Send {enter}          ; 選択
Send {enter}          ; ジョブ
Send {s}              ; ジョブをプレイ
Send {enter}          ; 選択
Send {s}              ; ブックマーク済み
Send {enter}          ; 選択
Sleep, DELAY_MENU * 6 ; 読み込み待機
Send {w}              ; パラシューティング
Send {w}              ; 敵対モード
Send {w}              ; 対戦
Send {w}              ; ミッション
Send {w}              ; サバイバル
Send {enter}          ; 選択
Sleep, DELAY_MENU     ; 念のため    
Send {w}              ; 放置サバイバル12
Send {enter}          ; ジョブを選択
Send {enter}          ; 開始
Send {enter}          ; 念のため

Sleep, DELAY_MENU * 6

job_status := 0       ; ジョブの状態をリセット

while( True )
{
	enter_pos_x = enter_pos_y = "" ; 座標をリセット
	esc_pos_x = esc_pos_y = ""
	
	ImageSearch, enter_pos_x, enter_pos_y, 545, 545, 820, 650, *120 %launch_dir%\img\enter.png  ; 画像認識
	ImageSearch, esc_pos_x, esc_pos_y, 545, 545, 820, 650, *120 %launch_dir%\img\esc.png
		
	if( enter_pos_x != "" && esc_pos_x != "" )
	{
		switch job_status
		{
			case 0: ; 設定画面
			{
				Sleep, DELAY_MENU
				Send {w}          ; 設定完了
				Send {enter}      ; 選択
				
				Sleep, ( DELAY_MENU * 6 )
				job_status++      ; ジョブ状態を進行
			}
			case 1: ; 招待画面
			{
				Send {w}     ; プレイ
				Send {enter} ; 選択
				Send {enter} ; 開始
        Send {enter} ; 念のため
				
        Sleep, ( DELAY_MENU * 5 )
				job_status++ ; ジョブ状態を進行
			}
			case 2: ; ジョブ終了，自動リプレイ
			{
				Sleep, 1000
				Send {w}      ; リプレイ
				Send {enter}  ; 選択
				Send {enter}  ; 念のため

        Sleep, ( DELAY_MENU * 6 )
				global job_status := 0 ; リセット
				Continue
			}
		}
	}
	else   ; ジョブ
	{		
		if( job_status >= 2 ) ; 放置キックを回避
		{
      WinActivate, ahk_exe GTA5.exe ; 他のアプリによるフォーカス外しを対策するためにウィンドウをアクティブ化
      Sleep, 2000
			Send {z 3}
			Sleep, 2000
		}
	}
}

Shutdown_Script:   
ExitApp
Return

Pause_Script:
Pause
Return    