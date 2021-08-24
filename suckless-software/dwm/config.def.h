/* dwm config */
/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 3;
static const unsigned int gappx     = 5;
static const unsigned int snap      = 32;       
static const int showbar            = 1;        
static const int topbar             = 1;       
static const char *fonts[]          = { "Misc Termsyn:size=13" };
static const char dmenufont[]       = "Misc Termsyn:size=13";
static const char col_gray1[]       = "#232323";
static const char col_gray2[]       = "#303030";
static const char col_gray3[]       = "#404040";
static const char col_gray4[]       = "#3d3d3d";
static const char col_gray5[]       = "#d5bbbc";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray5, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray1, col_gray5,  col_gray5    },
};

static const char *tags[] = { 
	"www", 
	"dev", 
	"doc", 
	"chat", 
	"gfx",
	"vbox",
	"mp" 
};

static const char *tagsel[][2] = {
	{ "#ffffff", "#ff0000" },
	{ "#ffffff", "#ff7f00" },
	{ "#000000", "#ffff00" },
	{ "#000000", "#00ff00" },
	{ "#ffffff", "#0000ff" },
	{ "#ffffff", "#4b0082" },
	{ "#ffffff", "#9400d3" },
	{ "#000000", "#ffffff" },
	{ "#ffffff", "#000000" },
};

static const char *tagsel[][2] = {
	{ "#ffffff", "#ff0000" },
	{ "#ffffff", "#ff7f00" },
	{ "#000000", "#ffff00" },
	{ "#000000", "#00ff00" },
	{ "#ffffff", "#0000ff" },
	{ "#ffffff", "#4b0082" },
	{ "#ffffff", "#9400d3" },
	{ "#000000", "#ffffff" },
	{ "#ffffff", "#000000" },
};

static const char *tagselfg[] = { "#ffffff", "#ffffff", "#000000", "#000000", "#ffffff", "#ffffff", "#ffffff", "#000000", "#ffffff" };
static const char *tagselbg[] = { "#ff0000", "#ff7f00", "#ffff00", "#00ff00", "#0000ff", "#4b0082", "#9400d3", "#ffffff", "#000000" };

static const char *tagselfg[] = { "#ffffff", "#ffffff", "#000000", "#000000", "#ffffff", "#ffffff", "#ffffff", "#000000", "#ffffff" };
static const char *tagselbg[] = { "#ff0000", "#ff7f00", "#ffff00", "#00ff00", "#0000ff", "#4b0082", "#9400d3", "#ffffff", "#000000" };

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

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_gray5, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *browser[]  = { "firefox", NULL };
static const char *gimp[]     = { "gimp", NULL};
/* static const char *scrot[]    = { "scrot", "-q", "100", NULL}; */
static const char *discord[]  = { "discord", NULL };

#include "movestack.c"
static Key keys[] = {
	/* modifier                     key        function        argument */
	/* command keybiding */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,						XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,						XK_w,	   spawn,          {.v = browser } },
	{ MODKEY,						XK_g,	   spawn,		   {.v = gimp } },
	/* { MODKEY|ShiftMask,				XK_p,      spawn,          {.v = scrot } }, */
	{ MODKEY|ShiftMask,				XK_d,      spawn,          {.v = discord } },

	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },

	/* Layouts */ 
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_u,      setlayout,      {.v = &layouts[3]} }, /* centered master */ 
	{ MODKEY,                       XK_o,      setlayout,      {.v = &layouts[4]} }, /* centered master */
	{ MODKEY,                       XK_space,  setlayout,      {0} },
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
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

