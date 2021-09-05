/* dwm config */
/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 3;
static const unsigned int gappx     = 5;
static const unsigned int snap      = 32;       
static const int showbar            = 1;        
static const int topbar        = 1;          /* 0 means bottom bar */
static const int usealtbar     = 1;          /* 1 means use non-dwm status bar */
static const char *altbarclass = "tint2";  /* Alternate bar class name */
static const char *fonts[]     = {"Mononoki Nerd Font:size=9:antialias=true:autohint=true",
                                  "Hack:size=8:antialias=true:autohint=true",
                                  "JoyPixels:size=10:antialias=true:autohint=true"};
static const char dmenufont[]       = "Mononoki Nerd Font:size=9:antialias=true:autohint=true";
static const char col_gray1[]       = "#282c34";
static const char col_gray2[]       = "#282c20";
static const char col_gray3[]       = "#282c10";
static const char col_gray4[]       = "#2e2c20";
static const char col_gray5[]       = "#89ddff";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray5, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_gray5, col_gray5 },
};

static const char *tags[] = { " ", " ", "", " ", " ", " ", " ", " ", " " };

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            0,           -1 },
	{ "firefox",  NULL,       NULL,       0,			0,           1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "|M|",      centeredmaster }, /* centered master */ 
	{ ">M>",      centeredfloatingmaster }, /* centered master */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} }, 

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }


/* dmenu */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
/* If you are using the standard dmenu program, use the following. */
static const char *dmenucmd[]    = { "dmenu_run", "-i", "-p", "Run: ", NULL };
/* commands */
static const char *termcmd[]  = { "alacritty", NULL };

#include "movestack.c"
static Key keys[] = {
	/* modifier                     key        function        argument */
	/* command keybiding */
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = dmenucmd } },
	{ MODKEY,		                XK_Return, spawn,          {.v = termcmd } },

	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Left,   focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_Right,  focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Left,   movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_Right,  movestack,      {.i = -1 } },
	{ MODKEY,                       XK_Up,     incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_Down,   incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Up,     setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_Down,   setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },

	/* Layouts */ 
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_u,      setlayout,      {.v = &layouts[3]} }, /* centered master */ 
	//{ MODKEY,                       XK_o,      setlayout,      {.v = &layouts[4]} }, [> centered master <]
	{ MODKEY|ShiftMask,		        XK_Tab,    cyclelayout,    {.i = -1 } },
	{ MODKEY,		                XK_Tab,    cyclelayout,    {.i = +1 } },
	{ MODKEY,                       XK_space,  togglefullscr,  {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },

	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
	{ MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_r,      quit,           {1} },
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	//{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

