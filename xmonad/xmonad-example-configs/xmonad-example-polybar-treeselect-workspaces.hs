-- Xmonad is a dynamically tiling X11 window manager that is written and
-- configured in Haskell. Official documentation: https://xmonad.org

-- This is the xmonad configuration of Derek Taylor (DistroTube)
-- My YouTube: http://www.youtube.com/c/DistroTube
-- My GitLab:  http://www.gitlab.com/dwt1/

-- This config is massively long. It is purposely bloated with a ton of
-- examples of what you can do with xmonad. It is written more as a
-- study guide rather than a config that you should download and use.

------------------------------------------------------------------------
-- IMPORTS
------------------------------------------------------------------------
    -- Base
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Tuple.Extra as TE
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docks, docksEventHook, ToggleStruts(..))
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

    -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn)
import XMonad.Util.SpawnOnce

   -- For polybar
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

------------------------------------------------------------------------
-- VARIABLES
------------------------------------------------------------------------
-- It's nice to assign values to stuff that you will use more than once
-- in the config. Setting values for things like font, terminal and editor
-- means you only have to change the value here to make changes globally.
myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=9"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"   -- Sets default terminal

myBrowser :: String
myBrowser = myTerminal ++ " -e lynx "  -- Sets lynx as browser for tree select
-- myBrowser = "firefox "                 -- Sets firefox as browser for tree select

myEditor :: String
myEditor = "emacsclient -c -a emacs "  -- Sets emacs as editor for tree select
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor for tree select

myBorderWidth :: Dimension
myBorderWidth = 2          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#292d3e"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#bbc5ff"  -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

-- Colors for polybar
color1, color2, color3, color4 :: String
color1 = "#7F7F7F"
color2 = "#c792ea"
color3 = "#900000"
color4 = "#2E9AFE"

------------------------------------------------------------------------
-- AUTOSTART
------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
          spawnOnce "nitrogen --restore &"
          spawnOnce "picom &"
          spawnOnce "/usr/bin/emacs --daemon &"
          spawnOnce "/home/dt/.config/polybar/launch-xmonad.sh &"
          setWMName "LG3D"

------------------------------------------------------------------------
-- GRID SELECT
------------------------------------------------------------------------
-- GridSelect displays items (programs, open windows, etc.) in a 2D grid
-- and lets the user select from it with the cursor/hjkl keys or the mouse.
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x29,0x2d,0x3e) -- lowest inactive bg
                  (0x29,0x2d,0x3e) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x29,0x2d,0x3e) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

-- The lists below are actually 3-tuples for use with gridSelect and treeSelect.
-- TreeSelect uses all three values in the 3-tuples but GridSelect only needs first
-- two values in each list (see myAppGrid, myBookmarkGrid and myConfigGrid below).
myApplications :: [(String, String, String)]
myApplications = [ ("Audacity", "audacity", "Graphical cross-platform audio eidtor")
                 , ("Deadbeef", "deadbeef", "Lightweight GUI audio player")
                 , ("Emacs", "emacs", "Much more than a text editor")
                 , ("Firefox", "firefox", "The famous open source web browser")
                 , ("Geany", "geany", "A nice text editor")
                 , ("Geary", "geary", "Email client that is attractive")
                 , ("Gimp", "gimp", "Open source alternative to Photoshop")
                 , ("Kdenlive", "kdenlive", "A great open source video editor")
                 , ("LibreOffice Impress", "loimpress", "For making presentations")
                 , ("LibreOffice Writer", "lowriter", "A fully featured word processor")
                 , ("OBS", "obs", "Open broadcaster software")
                 , ("PCManFM", "pcmanfm", "Lightweight graphical file manager")
                 , ("Simple Terminal", "st", "Suckless simple terminal")
                 , ("Steam", "steam", "Proprietary gaming platform")
                 , ("Surf Browser", "surf suckless.org", "Suckless surf web browser")
                 , ("Xonotic", "xonotic-glx", "A fast-paced first person shooter")
                 ]

myBookmarks :: [(String, String, String)]
myBookmarks = [ ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("Site Name", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              ]

myConfigs :: [(String, String, String)]
myConfigs = [ ("bashrc", myEditor ++ "/home/dt/.bashrc", "the bourne again shell")
            , ("doom emacs config.el", myEditor ++ "/home/dt/.doom.d/config.el", "doom emacs config")
            , ("doom emacs init.el", myEditor ++ "/home/dt/.doom.d/init.el", "doom emacs init")
            , ("dwm", myEditor ++ "/home/dt/dwm-distrotube/config.h", "dwm config file")
            , ("qtile", myEditor ++ "/home/dt/.config/qtile/config.py", "qtile config")
            , ("xmonad.hs", myEditor ++ "/home/dt/.xmonad/xmonad.hs", "xmonad config")
            , ("zshrc", myEditor ++ "/home/dt/.zshrc", "config for the z shell")
            ]

-- Let's take myApplications, myBookmarks and myConfigs and take only
-- the first two values from those 3-tuples (for GridSelect).
myAppGrid :: [(String, String)]
myAppGrid = [ (a,b) | (a,b,c) <- xs]
  where xs = myApplications

myBookmarkGrid :: [(String, String)]
myBookmarkGrid = [ (a,b) | (a,b,c) <- xs]
  where xs = myBookmarks

myConfigGrid :: [(String, String)]
myConfigGrid = [ (a,b) | (a,b,c) <- xs]
  where xs = myConfigs

------------------------------------------------------------------------
-- TREE SELECT
------------------------------------------------------------------------
-- TreeSelect displays your workspaces or actions in a Tree-like format.
-- You can select desired workspace/action with the cursor or hjkl keys.

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "applications" "a list of programs I use often" (return ()))
     [Node (TS.TSNode (TE.fst3 $ myApplications !! n)
                      (TE.thd3 $ myApplications !! n)
                      (spawn $ TE.snd3 $ myApplications !! n)
           ) [] | n <- [0..(length myApplications - 1)]
     ]
   , Node (TS.TSNode "bookmarks" "a list of web bookmarks" (return ()))
     [Node (TS.TSNode(TE.fst3 $ myBookmarks !! n)
                     (TE.thd3 $ myBookmarks !! n)
                     (spawn $ TE.snd3 $ myBookmarks !! n)
           ) [] | n <- [0..(length myBookmarks - 1)]
     ]
   , Node (TS.TSNode "config files" "config files that edit often" (return ()))
     [Node (TS.TSNode (TE.fst3 $ myConfigs !! n)
                      (TE.thd3 $ myConfigs !! n)
                      (spawn $ TE.snd3 $ myConfigs !! n)
           ) [] | n <- [0..(length myConfigs - 1)]
     ]
   ]

-- Configuration options for treeSelect
tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd292d3e
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffd0d0d0, 0xff202331)
                              , TS.ts_nodealt      = (0xffd0d0d0, 0xff292d3e)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
                              , TS.ts_extra        = 0xffd0d0d0
                              , TS.ts_node_width   = 200
                              , TS.ts_node_height  = 20
                              , TS.ts_originX      = 0
                              , TS.ts_originY      = 0
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

-- Keybindings for treeSelect menus. Use h-j-k-l to navigate.
-- Use 'o' and 'i' to move forward/back in the workspace history.
-- Single KEY's are for top-level nodes. SUPER+KEY are for the
-- second-level nodes. SUPER+ALT+KEY are third-level nodes.
myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
    , ((0, xK_d),        TS.moveTo ["dev"])
    , ((0, xK_g),        TS.moveTo ["graphics"])
    , ((0, xK_m),        TS.moveTo ["music"])
    , ((0, xK_v),        TS.moveTo ["video"])
    , ((0, xK_w),        TS.moveTo ["web"])
    , ((mod4Mask, xK_b), TS.moveTo ["web", "browser"])
    , ((mod4Mask, xK_c), TS.moveTo ["web", "chat"])
    , ((mod4Mask, xK_m), TS.moveTo ["web", "email"])
    , ((mod4Mask, xK_r), TS.moveTo ["web", "rss"])
    , ((mod4Mask, xK_w), TS.moveTo ["web", "web conference"])
    , ((mod4Mask, xK_d), TS.moveTo ["dev", "docs"])
    , ((mod4Mask, xK_e), TS.moveTo ["dev", "emacs"])
    , ((mod4Mask, xK_f), TS.moveTo ["dev", "files"])
    , ((mod4Mask, xK_p), TS.moveTo ["dev", "programming"])
    , ((mod4Mask, xK_t), TS.moveTo ["dev", "terminal"])
    , ((mod4Mask, xK_z), TS.moveTo ["dev", "virtualization"])
    , ((mod4Mask, xK_g), TS.moveTo ["graphics", "gimp"])
    , ((mod4Mask, xK_i), TS.moveTo ["graphics", "image viewer"])
    , ((mod4Mask, xK_a), TS.moveTo ["music", "audio editor"])
    , ((mod4Mask, xK_u), TS.moveTo ["music", "music player"])
    , ((mod4Mask, xK_o), TS.moveTo ["video", "obs"])
    , ((mod4Mask, xK_v), TS.moveTo ["video", "video player"])
    , ((mod4Mask, xK_k), TS.moveTo ["video", "kdenlive"])
    , ((mod4Mask .|. altMask, xK_h), TS.moveTo ["dev", "programming", "haskell"])
    , ((mod4Mask .|. altMask, xK_p), TS.moveTo ["dev", "programming", "python"])
    , ((mod4Mask .|. altMask, xK_s), TS.moveTo ["dev", "programming", "shell"])
    ]

------------------------------------------------------------------------
-- XPROMPT SETTINGS
------------------------------------------------------------------------
dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#292d3e"
      , fgColor             = "#d0d0d0"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , promptKeymap        = dtXPKeymap
      , position            = Top
--    , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
      }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

-- A list of all of the standard Xmonad prompts and a key press assigned to them.
-- These are used in conjunction with keybinding I set later in the config.
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("p", passPrompt)         -- get passwords (requires 'pass')
             , ("g", passGeneratePrompt) -- generate passwords (requires 'pass')
             , ("r", passRemovePrompt)   -- remove passwords (requires 'pass')
             , ("s", sshPrompt)          -- ssh prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]

-- Same as the above list except this is for my custom prompts.
promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         -- requires qalculate-gtk
              ]

------------------------------------------------------------------------
-- CUSTOM PROMPTS
------------------------------------------------------------------------
-- calcPrompt requires a cli calculator called qalcualte-gtk.
-- You could use this as a template for other custom prompts that
-- use command line programs that return a single line of output.
calcPrompt :: XPConfig -> String -> X ()
calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

------------------------------------------------------------------------
-- XPROMPT KEYMAP (emacs-like key bindings for xprompts)
------------------------------------------------------------------------
dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

------------------------------------------------------------------------
-- SEARCH ENGINES
------------------------------------------------------------------------
-- Xmonad has several search engines available to use located in
-- XMonad.Actions.Search. Additionally, you can add other search engines
-- such as those listed below.
archwiki, ebay, news, reddit, urban :: S.SearchEngine

archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("n", news)
             , ("r", reddit)
             , ("s", S.stackage)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("b", S.wayback)
             , ("u", urban)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("z", S.amazon)
             ]


------------------------------------------------------------------------
-- WORKSPACES
------------------------------------------------------------------------
-- TreeSelect workspaces
myWorkspaces :: Forest String
myWorkspaces = [ Node "dev"
                   [ Node "terminal" []
                   , Node "emacs" []
                   , Node "docs" []
                   , Node "files" []
                   , Node "programming"
                     [ Node "haskell" []
                     , Node "python" []
                     , Node "shell" []
                     ]
                   , Node "virtualization" []
                   ]
               , Node "web"
                   [ Node "browser" []
                   , Node "chat" []
                   , Node "email" []
                   , Node "rss" []
                   , Node "web conference" []
                   ]
               , Node "graphics"
                   [ Node "gimp" []
                   , Node "image viewer" []
                   ]
              , Node "music"
                   [ Node "audio editor" []
                   , Node "music player" []
                   ]
               , Node "video"
                   [ Node "obs" []
                   , Node "kdenlive" []
                   , Node "video player" []
                   ]
               ]

------------------------------------------------------------------------
-- MANAGEHOOK
------------------------------------------------------------------------
-- Sets some rules for certain programs. Examples include forcing certain
-- programs to always float, or to always appear on a certain workspace.
-- Forcing programs to a certain workspace with a doShift requires xdotool
-- if you are using clickable workspaces. You need the className or title
-- of the program. Use xprop to get this info.

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out
     -- the full name of my clickable workspaces, which would look like:
     -- doShift "<action xdotool super+8>gfx</action>"
     [ className =? "obs"     --> doShift ( "video.obs" )
     , title =? "firefox"     --> doShift ( "web.browser" )
     , title =? "qutebrowser" --> doShift ( "web.browser" )
     , className =? "mpv"     --> doShift ( "video.movie player" )
     , className =? "vlc"     --> doShift ( "video.movie player" )
     , className =? "Gimp"    --> doShift ( "graphics.gimp")
     , className =? "Gimp"    --> doFloat
     , title =? "Oracle VM VirtualBox Manager"     --> doFloat
     , className =? "VirtualBox Manager" --> doShift  ( "dev.virtualization" )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- LOGHOOK
------------------------------------------------------------------------
-- Override the PP values as you would otherwise, adding colors etc depending
-- on the statusbar used
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput  = dbusOutput dbus
    , ppCurrent = wrap ("%{F" ++ color4 ++ "} ") "%{F-}"
    , ppVisible = wrap ("%{F" ++ color1 ++ "} ") "%{F-}"
    , ppUrgent  = wrap ("%{F" ++ color3 ++ "} ") "%{F-}"
    , ppHidden  = wrap ("%{F" ++ color1 ++ "} ") "%{F-}"
    , ppTitle   = wrap ("%{F" ++ color2 ++ "}")"%{F-}"
    , ppSep     = "  |  "
    }

------------------------------------------------------------------------
-- LAYOUTS
------------------------------------------------------------------------
-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ mySpacing' 4
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig
  where
    myTabConfig = def { fontName            = "xft:Mononoki Nerd Font:regular:pixelsize=11"
                      , activeColor         = "#292d3e"
                      , inactiveColor       = "#3e445e"
                      , activeBorderColor   = "#292d3e"
                      , inactiveBorderColor = "#292d3e"
                      , activeTextColor     = "#ffffff"
                      , inactiveTextColor   = "#d0d0d0"
                      }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Sans:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 -- ||| grid
                                 ||| noBorders tabs
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow

------------------------------------------------------------------------
-- SCRATCHPADS
------------------------------------------------------------------------
-- Allows to have several floating scratchpads running different applications.
-- Import Util.NamedScratchpad.  Bind a key to namedScratchpadSpawnAction.
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                ]
  where
    spawnTerm  = myTerminal ++ " -n scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -n mocp 'mocp'"
    findMocp   = resource =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

------------------------------------------------------------------------
-- KEYBINDINGS
------------------------------------------------------------------------
-- I am using the Xmonad.Util.EZConfig module which allows keybindings
-- to be written in simpler, emacs-like format.
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    -- Open my preferred terminal
        , ("M-<Return>", spawn myTerminal)

    -- Run Prompt
        , ("M-S-<Return>", shellPrompt dtXPConfig)   -- Shell Prompt

    -- Windows
        , ("M-S-c", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                         -- Kill all windows on current workspace

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
        , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile

    -- Grid Select (CTRL-g followed by a key)
        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-g m", spawnSelected' myBookmarkGrid)            -- grid select some bookmarks
        , ("C-g c", spawnSelected' myConfigGrid)              -- grid select useful config files
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Tree Select/
        -- tree select actions menu
        , ("C-t a", treeselectAction tsDefaultConfig)
        -- tree select workspaces menu
        , ("C-t t", TS.treeselectWorkspace tsDefaultConfig myWorkspaces W.greedyView)
        -- tree select choose workspace to send window
        , ("C-t g", TS.treeselectWorkspace tsDefaultConfig myWorkspaces W.shift)

    -- Windows navigation
        , ("M-m", windows W.focusMaster)     -- Move focus to the master window
        , ("M-j", windows W.focusDown)       -- Move focus to the next window
        , ("M-k", windows W.focusUp)         -- Move focus to the prev window
        --, ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)      -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)        -- Swap focused window with prev window
        , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
        , ("M1-S-<Tab>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
        --, ("M-S-s", windows copyToAll)
        , ("M-C-s", killAllOtherCopies)

        -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)         -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
        , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
        , ("M-S-<KP_Divide>", decreaseLimit)                -- Decrease number of windows

        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("M-C-j", sendMessage MirrorShrink)               -- Shrink vert window width
        , ("M-C-k", sendMessage MirrorExpand)               -- Exoand vert window width

    -- Workspaces
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Scratchpads
        , ("M-C-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M-C-c", namedScratchpadAction myScratchPads "mocp")

    -- Controls for mocp music player.
        , ("M-u p", spawn "mocp --play")
        , ("M-u l", spawn "mocp --next")
        , ("M-u h", spawn "mocp --previous")
        , ("M-u <Space>", spawn "mocp --toggle-pause")

    -- Emacs (CTRL-e followed by a key)
        , ("C-e e", spawn "emacsclient -c -a ''")                            -- start emacs
        , ("C-e b", spawn "emacsclient -c -a '' --eval '(ibuffer)'")         -- list emacs buffers
        , ("C-e d", spawn "emacsclient -c -a '' --eval '(dired nil)'")       -- dired emacs file manager
        , ("C-e m", spawn "emacsclient -c -a '' --eval '(mu4e)'")            -- mu4e emacs email client
        , ("C-e n", spawn "emacsclient -c -a '' --eval '(elfeed)'")          -- elfeed emacs rss client
        , ("C-e s", spawn "emacsclient -c -a '' --eval '(eshell)'")          -- eshell within emacs
        , ("C-e t", spawn "emacsclient -c -a '' --eval '(+vterm/here nil)'") -- eshell within emacs
        -- emms is an emacs audio player. I set it to auto start playing in a specific directory.
        , ("C-e a", spawn "emacsclient -c -a '' --eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'")

    --- My Applications (Super+Alt+Key)
        , ("M-M1-a", spawn (myTerminal ++ " -e ncpamixer"))
        , ("M-M1-b", spawn "surf www.youtube.com/c/DistroTube/")
        , ("M-M1-e", spawn (myTerminal ++ " -e neomutt"))
        , ("M-M1-f", spawn (myTerminal ++ " -e sh ./.config/vifm/scripts/vifmrun"))
        , ("M-M1-i", spawn (myTerminal ++ " -e irssi"))
        , ("M-M1-j", spawn (myTerminal ++ " -e joplin"))
        , ("M-M1-l", spawn (myTerminal ++ " -e lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss gopher://distro.tube"))
        , ("M-M1-m", spawn (myTerminal ++ " -e mocp"))
        , ("M-M1-n", spawn (myTerminal ++ " -e newsboat"))
        , ("M-M1-p", spawn (myTerminal ++ " -e pianobar"))
        , ("M-M1-r", spawn (myTerminal ++ " -e rtv"))
        , ("M-M1-t", spawn (myTerminal ++ " -e toot curses"))
        , ("M-M1-w", spawn (myTerminal ++ " -e wopr report.xml"))
        , ("M-M1-y", spawn (myTerminal ++ " -e youtube-viewer"))

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn "cmus toggle")
        , ("<XF86AudioPrev>", spawn "cmus prev")
        , ("<XF86AudioNext>", spawn "cmus next")
        -- , ("<XF86AudioMute>",   spawn "amixer set Master toggle")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "firefox")
        , ("<XF86Search>", safeSpawn "firefox" ["https://www.google.com/"])
        , ("<XF86Mail>", runOrRaise "geary" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "gcalctool" (resource =? "gcalctool"))
        , ("<XF86Eject>", spawn "toggleeject")
        , ("<Print>", spawn "scrotd 0")
        ]
        -- Appending search engine prompts to keybindings list.
        -- Look at "search engines" section of this config for values for "k".
        ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]
        ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]
        -- Appending some extra xprompts to keybindings list.
        -- Look at "xprompt settings" section this of config for values for "k".
        ++ [("M-p " ++ k, f dtXPConfig') | (k,f) <- promptList ]
        ++ [("M-p " ++ k, f dtXPConfig' g) | (k,f,g) <- promptList' ]
        -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------
main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    -- The xmonad, ya know...what the window manager is named after.
    xmonad $ ewmh $ docks $ defaults { logHook = dynamicLogWithPP (myLogHook dbus) }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

defaults = def
    { handleEventHook     = serverModeEventHookCmd
                            <+> serverModeEventHook
                            <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                            <+> docksEventHook
    , modMask             = myModMask
    , terminal            = myTerminal
    , workspaces          = TS.toWorkspaces myWorkspaces
    , layoutHook          = showWName' myShowWNameTheme $ smartBorders $ myLayoutHook
    , normalBorderColor   = myNormColor
    , focusedBorderColor  = myFocusColor
    , manageHook          = myManageHook <+> manageHook def
    , borderWidth         = myBorderWidth
    , startupHook         = myStartupHook
    } `additionalKeysP` myKeys
