-------------------------------------------------------------------------------
--                  __  ____  __                       _                     --
--                  \ \/ /  \/  | ___  _ __   __ _  __| |                    --
--                   \  /| |\/| |/ _ \| '_ \ / _` |/ _` |                    --
--                   /  \| |  | | (_) | | | | (_| | (_| |                    --
--                  /_/\_\_|  |_|\___/|_| |_|\__,_|\__,_|                    --
--                                                                           --
-------------------------------------------------------------------------------
--          written by Shotaro Fujimoto (https://github.com/ssh0)            --
-------------------------------------------------------------------------------
-- Import modules                                                           {{{
-------------------------------------------------------------------------------
import qualified Data.Map as M

import XMonad
import qualified XMonad.StackSet as W  -- myManageHookShift

import Control.Monad (liftM2)          -- myManageHookShift
import System.IO                       -- for xmobar

import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex -- flexible resize
import XMonad.Actions.FloatKeys
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo
import XMonad.Hooks.DynamicLog         -- for xmobar
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.ManageDocks        -- avoid xmobar area
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Layout
import XMonad.Layout.DragPane          -- see only two window
import XMonad.Layout.Gaps
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders         -- In Full mode, border is no use
import XMonad.Layout.PerWorkspace      -- Configure layouts on a per-workspace
import XMonad.Layout.ResizableTile     -- Resizable Horizontal border
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing           -- this makes smart space around windows
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns      -- for many windows
import XMonad.Layout.ToggleLayouts     -- Full window at any time
import XMonad.Layout.TwoPane
import XMonad.Prompt
import XMonad.Prompt.Window            -- pops up a prompt with window names
import XMonad.Util.EZConfig            -- removeKeys, additionalKeys
import XMonad.Util.Run
import XMonad.Util.Run(spawnPipe)      -- spawnPipe, hPutStrLn

import Graphics.X11.ExtraTypes.XF86

--------------------------------------------------------------------------- }}}
-- local variables                                                          {{{
-------------------------------------------------------------------------------

myWorkspaces = ["1", "2", "3", "4", "5"]
modm = mod4Mask

-- Color Setting
colorBlue      = "#9fc7e8"
colorGreen     = "#a5d6a7"
colorRed       = "#ef9a9a"
colorGray      = "#9e9e9e"
colorWhite     = "#ffffff"
colorGrayAlt   = "#eceff1"
colorNormalbg  = "#1c1c1c"
colorfg        = "#9fa8b1"

-- Border width
borderwidth = 0

-- Border color
mynormalBorderColor  = colorNormalbg
myfocusedBorderColor = colorBlue

-- gapwidth
gapwidth  = 3
gapwidthU = 12
gapwidthD = 12
gapwidthL = 40
gapwidthR = 41

--------------------------------------------------------------------------- }}}
-- Define keys to remove                                                    {{{
-------------------------------------------------------------------------------

keysToRemove x =
    [
        -- Unused gmrun binding
          (modm .|. shiftMask, xK_p)
        -- Unused close window binding
        , (modm .|. shiftMask, xK_c)
        , (modm .|. shiftMask, xK_Return)
    ]

-- Delete the keys combinations we want to remove.
strippedKeys x = foldr M.delete (keys defaultConfig x) (keysToRemove x)

--------------------------------------------------------------------------- }}}
-- main                                                                     {{{
-------------------------------------------------------------------------------

main :: IO ()

main = do
    wsbar <- spawnPipe myWsBar
    xmonad $ ewmh defaultConfig
       { borderWidth        = borderwidth
       -- urxvtc is client terminal application. you should launch the daemon 
       -- before using urxvtc
       --     $ urxvtd -q -f -o
       , terminal           = "urxvtc"
       , focusFollowsMouse  = True
       , normalBorderColor  = mynormalBorderColor
       , focusedBorderColor = myfocusedBorderColor
       , startupHook        = myStartupHook
       , manageHook         = myManageHookShift <+>
                              myManageHookFloat <+>
                              manageDocks
        -- any time Full mode, avoid xmobar area
       , layoutHook         = -- lessBorders OnlyFloat $
                              toggleLayouts (avoidStruts $ noBorders Full) $
                              -- onWorkspace "3" simplestFloat $
                              avoidStruts $ myLayout
        -- xmobar setting
       , logHook            = myLogHook wsbar
       , handleEventHook    = fadeWindowsEventHook <+>
                              fullscreenEventHook
       , workspaces         = myWorkspaces
       , modMask            = modm
       , mouseBindings      = newMouse
       }

       -------------------------------------------------------------------- }}}
       -- Keymap: window operations                                         {{{
       ------------------------------------------------------------------------

       `additionalKeys`
       [
       -- Shrink / Expand the focused window
         ((modm                , xK_comma  ), sendMessage Shrink)
       , ((modm                , xK_period ), sendMessage Expand)
       , ((modm                , xK_z      ), sendMessage MirrorShrink)
       , ((modm                , xK_a      ), sendMessage MirrorExpand)
       -- Close the focused window
       , ((modm                , xK_c      ), kill1)
       -- Toggle layout (Fullscreen mode)
       , ((modm                , xK_f      ), sendMessage ToggleLayout)
       -- Move the focused window
       , ((modm .|. controlMask, xK_Right  ), withFocused (keysMoveWindow (2,0)))
       , ((modm .|. controlMask, xK_Left   ), withFocused (keysMoveWindow (-2,0)))
       , ((modm .|. controlMask, xK_Up     ), withFocused (keysMoveWindow (0,-2)))
       , ((modm .|. controlMask, xK_Down   ), withFocused (keysMoveWindow (0,2)))
       -- Resize the focused window
       , ((modm                , xK_s      ), withFocused (keysResizeWindow (-6,-6) (0.5,0.5)))
       , ((modm                , xK_i      ), withFocused (keysResizeWindow (6,6) (0.5,0.5)))
       -- Increase / Decrese the number of master pane
       , ((modm .|. shiftMask  , xK_semicolon), sendMessage $ IncMasterN 1)
       , ((modm                , xK_minus  ), sendMessage $ IncMasterN (-1))
       -- Go to the next / previous workspace
       , ((modm                , xK_Right  ), nextWS )
       , ((modm                , xK_Left   ), prevWS )
       , ((modm                , xK_l      ), nextWS )
       , ((modm                , xK_h      ), prevWS )
       -- Shift the focused window to the next / previous workspace
       , ((modm .|. shiftMask  , xK_Right  ), shiftToNext)
       , ((modm .|. shiftMask  , xK_Left   ), shiftToPrev)
       , ((modm .|. shiftMask  , xK_l      ), shiftToNext)
       , ((modm .|. shiftMask  , xK_h      ), shiftToPrev)
       -- CopyWindow
       , ((modm                , xK_v      ), windows copyToAll)
       , ((modm .|. shiftMask  , xK_v      ), killAllOtherCopies)
       -- Move the focus down / up
       , ((modm                , xK_Down   ), windows W.focusDown)
       , ((modm                , xK_Up     ), windows W.focusUp)
       , ((modm                , xK_j      ), windows W.focusDown)
       , ((modm                , xK_k      ), windows W.focusUp)
       -- Swap the focused window down / up
       , ((modm .|. shiftMask  , xK_j      ), windows W.swapDown)
       , ((modm .|. shiftMask  , xK_k      ), windows W.swapUp)
       -- Shift the focused window to the master window
       , ((modm .|. shiftMask  , xK_m      ), windows W.shiftMaster)
       -- Search a window and focus into the window
       , ((modm                , xK_g      ), windowPromptGoto myXPConfig)
       -- Search a window and bring to the current workspace
       , ((modm                , xK_b      ), windowPromptBring myXPConfig)
       -- Move the focus to next screen (multi screen)
       , ((modm                , xK_w      ), nextScreen)
       ]

       -------------------------------------------------------------------- }}}
       -- Keymap: moving workspace by number                                {{{
       ------------------------------------------------------------------------

       `additionalKeys`
       [ ((modm .|. m, k), windows $ f i)
         | (i, k) <- zip myWorkspaces
                     [ xK_exclam, xK_at, xK_numbersign
                     , xK_dollar, xK_percent, xK_asciicircum
                     , xK_ampersand, xK_asterisk, xK_parenleft
                     , xK_parenright
                     ]
         , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]

       -------------------------------------------------------------------- }}}
       -- Keymap: custom commands                                           {{{
       ------------------------------------------------------------------------

       `additionalKeys`
       [
       -- Lock screen
         ((mod1Mask .|. controlMask, xK_l      ), spawn "xscreensaver-command -lock")
       -- Toggle compton (compsite manager)
       , ((mod1Mask .|. controlMask, xK_t      ), spawn "bash $HOME/bin/toggle_compton.sh")
       -- Launch terminal
       , ((modm                    , xK_Return ), spawn "urxvtc")
       -- Launch terminal with a float window
       , ((modm .|. shiftMask      , xK_Return ), spawn "$HOME/bin/urxvt_float.sh")
       -- Insert a transparent panel
       , ((modm .|. shiftMask      , xK_t      ), spawn "python $HOME/Workspace/python/transparent.py")
       -- Launch file manager
       , ((modm                    , xK_e      ), spawn "thunar")
       -- Launch web browser
       , ((modm                    , xK_w      ), spawn "luakit")
       -- Launch dmenu for launching applicatiton
       , ((modm                    , xK_p      ), spawn "exe=`dmenu_run -l 10 -fn 'Migu 1M:size=20'` && exec $exe")
       -- Lauch websearch application (See https://github.com/ssh0/web_search)
       , ((mod1Mask .|. controlMask, xK_f      ), spawn "websearch")
       -- Play / Pause media keys
       , ((0                       , 0x1008ff18), spawn "sh $HOME/bin/cplay.sh")
       , ((0                       , 0x1008ff14), spawn "sh $HOME/bin/cplay.sh")
       , ((shiftMask               , 0x1008ff18), spawn "streamradio pause")
       , ((shiftMask               , 0x1008ff14), spawn "streamradio pause")
       -- Volume setting media keys
       , ((0                       , 0x1008ff13), spawn "bash $HOME/bin/sound_volume_change_wrapper.sh +")
       , ((0                       , 0x1008ff11), spawn "bash $HOME/bin/sound_volume_change_wrapper.sh -")
       , ((0                       , 0x1008ff12), spawn "bash $HOME/bin/sound_volume_change_wrapper.sh m")
        -- Brightness Keys
       , ((0                       , 0x1008FF02), spawn "xbacklight + 5 -time 100 -steps 1")
       , ((0                       , 0x1008FF03), spawn "xbacklight - 5 -time 100 -steps 1")
       -- Take a screenshot (whole window)
       , ((0                       , 0xff61    ), spawn "$HOME/bin/screenshot.sh")
       -- Take a screenshot (selected area)
       , ((shiftMask               , 0xff61    ), spawn "$HOME/bin/screenshot_select.sh")
       -- Launch ipython qtconsole
       , ((0                       , 0x1008ff1d), spawn "ipython qtconsole --matplotlib=inline")
       -- Toggle touchpad
       , ((controlMask             , xK_Escape ), spawn "$HOME/bin/touchpad_toggle.sh")
       -- Toggle trackpoint (Lenovo PC)
       , ((mod1Mask                , xK_Escape ), spawn "$HOME/bin/trackpoint_toggle.sh")
       ]

--------------------------------------------------------------------------- }}}
-- myLayout:          Handle Window behaveior                               {{{
-------------------------------------------------------------------------------

myLayout = spacing gapwidth $
           gaps [(U,gapwidth + gapwidthU),(D,gapwidth + gapwidthD),(L,gapwidth + gapwidthL),(R,gapwidth + gapwidthR)] $
                 (ResizableTall 1 (1/100) (3/5) [])
             ||| (TwoPane (1/100) (3/5))
             ||| (ThreeColMid 1 (1/100) (16/35))
             ||| Simplest

--------------------------------------------------------------------------- }}}
-- myStartupHook:     Start up applications                                 {{{
-------------------------------------------------------------------------------

myStartupHook = do
        spawn "gnome-settings-daemon"
        spawn "nm-applet"
        spawn "xscreensaver -no-splash"
        spawn "$HOME/.dropbox-dist/dropboxd"
        spawn "bash $HOME/.fehbg"
        spawn "$HOME/bin/start_urxvtd.sh"

--------------------------------------------------------------------------- }}}
-- myManageHookShift: some window must created there                        {{{
-------------------------------------------------------------------------------

myManageHookShift = composeAll
            -- if you want to know className, type "$ xprop|grep CLASS" on shell
            [ className =? "Firefox"       --> mydoShift "2"
            ]
             where mydoShift = doF . liftM2 (.) W.greedyView W.shift

--------------------------------------------------------------------------- }}}
-- myManageHookFloat: new window will created in Float mode                 {{{
-------------------------------------------------------------------------------

myManageHookFloat = composeAll
    [ className =? "Gimp"             --> doFloat
    , className =? "Tk"               --> doFloat
    , className =? "mplayer2"         --> doCenterFloat
    , className =? "mpv"              --> doCenterFloat
    , className =? "feh"              --> doCenterFloat
    , className =? "Display.im6"      --> doCenterFloat
    , className =? "Shutter"          --> doCenterFloat
    , className =? "Thunar"           --> doCenterFloat
    , className =? "Nautilus"         --> doCenterFloat
    , className =? "Plugin-container" --> doCenterFloat
    , className =? "Screenkey"        --> (doRectFloat $ W.RationalRect 0.7 0.9 0.3 0.1)
    , className =? "Websearch"        --> (doRectFloat $ W.RationalRect 0.45 0.4 0.1 0.01)
    , title     =? "Speedbar"         --> doCenterFloat
    , title     =? "urxvt_float"      --> doCenterFloat
    , isFullscreen                    --> doFullFloat
    , stringProperty "WM_NAME" =? "LINE" --> (doRectFloat $ W.RationalRect 0.60 0.1 0.39 0.82)
    , stringProperty "WM_NAME" =? "Google Keep" --> (doRectFloat $ W.RationalRect 0.3 0.1 0.4 0.82)
    , stringProperty "WM_NAME" =? "tmptex.pdf - 1/1 (96 dpi)" --> (doRectFloat $ W.RationalRect 0.29 0.25 0.42 0.5)
    ]

--------------------------------------------------------------------------- }}}
-- myLogHook:         loghock settings                                      {{{
-------------------------------------------------------------------------------

myLogHook h = dynamicLogWithPP $ wsPP { ppOutput = hPutStrLn h }

--------------------------------------------------------------------------- }}}
-- myWsBar:           xmobar setting                                        {{{
-------------------------------------------------------------------------------

myWsBar = "xmobar $HOME/.xmonad/xmobarrc"

wsPP = xmobarPP { ppOrder           = \(ws:l:t:_)  -> [ws,t]
                , ppCurrent         = xmobarColor colorWhite colorNormalbg . \s -> "*"
                , ppUrgent          = xmobarColor colorfg    colorNormalbg . \s -> "*"
                , ppVisible         = xmobarColor colorfg    colorNormalbg . \s -> "*"
                , ppHidden          = xmobarColor colorfg    colorNormalbg . \s -> "*"
                , ppHiddenNoWindows = xmobarColor colorfg    colorNormalbg . \s -> "-"
                , ppTitle           = xmobarColor colorGreen colorNormalbg
                , ppOutput          = putStrLn
                , ppWsSep           = " "
                , ppSep             = " : "
                }

--------------------------------------------------------------------------- }}}
-- myXPConfig:        XPConfig                                            {{{

myXPConfig = defaultXPConfig
                { font              = "xft:Migu 1M:size=12:antialias=true"
                , fgColor           = colorfg
                , bgColor           = colorNormalbg
                , borderColor       = colorNormalbg
                , height            = 20
                , promptBorderWidth = 1
                , autoComplete      = Just 100000
                , bgHLight          = colorWhite
                , fgHLight          = colorNormalbg
                , position          = Bottom
                }

--------------------------------------------------------------------------- }}}
-- newMouse:          Right click is used for resizing window               {{{
-------------------------------------------------------------------------------

myMouse x = [ ((modm, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) ]
newMouse x = M.union (mouseBindings defaultConfig x) (M.fromList (myMouse x))

--------------------------------------------------------------------------- }}}
