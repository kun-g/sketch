#include <stdio.h>
#include <lua5.1/lua.h>
#include <lua5.1/lauxlib.h>
#include <lua5.1/lualib.h>
#include <curses.h>

typedef struct _type_pos {
	unsigned char x;
	unsigned char y;
} type_pos;
typedef struct _type_snake {
	int len;
	unsigned char direction; // head direction
				//  0
				//3   1
				//  2
	type_pos body[1024];
} type_snake;

void init_game();
void broadcast();//broadcast map to players
void get_input();//get players' input
void update_game();//update
enum enumTile
{
	enTile_Ground,
	enTile_Wall,
	enTile_Food,
	enTile_RedHeadUp,
	enTile_RedHeadRight,
	enTile_RedHeadDown,
	enTile_RedHeadLeft,
	enTile_RedBody,
	enTile_GreenHeadUp,
	enTile_GreenHeadRight,
	enTile_GreenHeadDown,
	enTile_GreenHeadLeft,
	enTile_GreenBody,
	enTile_Count
};
bool put_tile(enum enumTile tile, unsigned char x, unsigned char y);// put an tile
// actions on snake
int init_snake(type_snake *pSnake, unsigned char dir, unsigned char x, unsigned char y);//reset a snake

// snake's actions
int snake_move(type_snake *pSnake, int);

// for lua script
// change direction
static int l_turn(lua_State *);
// query map
static int l_queryMap(lua_State *);
static int l_queryCount(lua_State *l);

static const struct luaL_reg myLib[] = {
	{"get_round", l_queryCount},
	{"get_map", l_queryMap},
	{"turn", l_turn},
	{NULL, NULL}
};
type_snake greenSnake, redSnake;
enum enumTile map[1024][1024];
char gcTable[1024];
int g_max_x, g_max_y;
int g_Round;
lua_State *L;
int r, c, nrows, ncols;
bool gbGameOn = true;

int main(int argc, const char *argv[])
{
	WINDOW *wnd;

	// file char-table
	gcTable[enTile_Ground] = ' ';
	gcTable[enTile_Wall] = '#';
	gcTable[enTile_Food] = '@';
	gcTable[enTile_RedHeadUp] = '^';
	gcTable[enTile_RedHeadRight] = '>';
	gcTable[enTile_RedHeadDown] = 'v';
	gcTable[enTile_RedHeadLeft] = '<';
	gcTable[enTile_RedBody] = 'X';
	gcTable[enTile_GreenHeadUp] = '^';
	gcTable[enTile_GreenHeadRight] = '>';
	gcTable[enTile_GreenHeadDown] = 'v';
	gcTable[enTile_GreenHeadLeft] = '<';
	gcTable[enTile_GreenBody] = 'O';

	// init Lua
	L = lua_open();
	luaL_openlibs(L);

	int error = luaL_loadbuffer(L, "dofile('./snake.lua')", sizeof("dofile('./snake.lua')"), "line") || lua_pcall(L, 0, 0, 0);
	if (error) {
		mvaddstr(0, 0, lua_tostring(L, -1));
	}
	luaL_openlib(L, "mylib", myLib, 0);

	// initialize curses
	wnd = initscr();
	start_color();
	init_pair(1, COLOR_RED, COLOR_BLACK);// for red snake
	init_pair(2, COLOR_GREEN, COLOR_BLACK);// for green snake
	init_pair(3, COLOR_WHITE, COLOR_BLACK);// for system output
	cbreak();
	noecho();
	getmaxyx(wnd, g_max_x, g_max_y);
	clear();
	refresh();

	init_game();
	broadcast();
	while (gbGameOn) {//game loop
	//getch();
		get_input();
		update_game();
		broadcast();
//		sleep(500);
	}
	lua_close(L);
	endwin();
	return 0;
}

void put_snake(type_snake *pSnake, int index)
{
	map[pSnake->body[0].x][pSnake->body[0].y] = index+pSnake->direction;
}
int init_snake(type_snake *pSnake, unsigned char dir, unsigned char x, unsigned char y)
{
	pSnake->direction = dir;
	pSnake->len = 1;
	pSnake->body[0].x = x;
	pSnake->body[0].y = y;

	return 0;
}

void init_game()
{
	g_Round = 0;
	int i;
	srand(i);
	init_snake(&greenSnake, 1, 0, 0);
	init_snake(&redSnake, 3, g_max_x-1, g_max_y-1);
	put_snake(&greenSnake, enTile_GreenHeadUp);
	put_snake(&redSnake, enTile_RedHeadUp);
}
bool put_tile(enum enumTile tile, unsigned char x, unsigned char y)
{
	if (x < g_max_x && y < g_max_y && map[x][y] == enTile_Ground) {
		map[x][y] = tile;
		return true;
	}
	return false;
}
void broadcast()
{
	char str[36];

	sprintf(str, "%d:%d:%d", g_Round, g_max_x, g_max_y);
				mvaddstr(8, 8, str);
	// show map
	int x, y;
	for (x = 0; x < g_max_x; x++) {
		for (y = 0; y < g_max_y; y++) {
			if (map[x][y] < enTile_RedHeadUp) {
				attrset(COLOR_PAIR(3));//system output
			} else if (map[x][y] < enTile_GreenHeadUp) {
				attrset(COLOR_PAIR(1));//red output
			} else {
				attrset(COLOR_PAIR(2));//green output
			}
			move(x, y);
			insch(gcTable[map[x][y]]);
		}
	}
	sprintf(str, "%d", g_Round);
	mvaddstr(g_max_x/2, g_max_y/2, str);
	// notify player
	// todo...
}
void get_input()
{
	// for green
	char input = getch();
	switch (input)
	{
		case 'h':
			if (greenSnake.direction != 1)
				greenSnake.direction = 3;
			break;
		case 'j':
			if (greenSnake.direction != 0)
				greenSnake.direction = 2;
			break;
		case 'k':
			if (greenSnake.direction != 2)
				greenSnake.direction = 0;
			break;
		case 'l':
			if (greenSnake.direction != 3)
				greenSnake.direction = 1;
			break;
		default:break;
	}
}
int snake_move(type_snake *pSnake, int index)
{
	int x = pSnake->body[0].x;
	int y = pSnake->body[0].y;
	// move head
	switch (pSnake->direction)
	{
		case 0:x--;if (x < 0)x = g_max_x-1;	break;
		case 1:y++;if (y == g_max_y)y = 0;	break;
		case 2:x++;if (x == g_max_x)x = 0;	break;
		case 3:y--;if (y < 0)y = g_max_y-1;	break;
		default:return 0;
	}
	int ret = 0;
	if (map[x][y] == enTile_Ground) {
		ret = 0;
	} else if (map[x][y] == enTile_Food) {
		pSnake->len++;
		ret = 1;
	} else {
		return 2;
	}
	// 1. erase tail
	if (map[x][y] != enTile_Food) {
		map[pSnake->body[pSnake->len-1].x][pSnake->body[pSnake->len-1].y] = enTile_Ground;
	}
	// 2. move body
	int i;
	for (i = pSnake->len-1; i > 0; i--) {//move forward, tail+1 included
		pSnake->body[i].x = pSnake->body[i-1].x;
		pSnake->body[i].y = pSnake->body[i-1].y;
		map[pSnake->body[i].x][pSnake->body[i].y] = index+4;//snake body
	}
	// 3. move head
	pSnake->body[0].x = x;
	pSnake->body[0].y = y;
	map[pSnake->body[0].x][pSnake->body[0].y] = index+pSnake->direction;

	return ret;
}
void update_game()
{
	// move snake
	int rRed = snake_move(&redSnake, enTile_RedHeadUp);
	int rGreen = snake_move(&greenSnake, enTile_GreenHeadUp);
	//int rGreen = snake_mov(&greenSnake);
	// generate food every ten rounds
	if (g_Round % 10 == 0) {
		int x = rand()%g_max_x;
		int y = rand()%g_max_y;
		put_tile(enTile_Food, x, y);
	}
	// check game statues
	if (rRed == 2 && rGreen == 2) {
		mvaddstr(g_max_x/2, g_max_y/2, "Draw!");
		gbGameOn = false; 
		getch();
	} else if (rRed == 2) {
		mvaddstr(g_max_x/2, g_max_y/2, "Red Lose!");
		gbGameOn = false; 
		getch();
	} else if (rGreen == 2) {
		mvaddstr(g_max_x/2, g_max_y/2, "Green Lose!");
		gbGameOn = false; 
		getch();
	}
	g_Round++;
}
static int l_turn(lua_State *l)
{
	int snakeId = lua_tonumber(l, 1); // red or green
	int direction = lua_tonumber(l, 2);

	if (snakeId == 0) {
		redSnake.direction = direction;
	} else {
		greenSnake.direction = direction;
	}

	return 0;
}
static int l_queryMap(lua_State *l)
{
	;
}
static int l_queryCount(lua_State *l)
{
	lua_pushnumber(l, g_Round);

	return 0;
}
