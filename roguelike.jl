using Formatting
include("ncurses.jl")

mutable struct Game
	screen_size::NamedTuple{(:x, :y),Tuple{Int64,Int64}}
	player_pos::NamedTuple{(:x, :y),Tuple{Int64,Int64}}
end

function Game_new()
	# startup
	stdscreen = initscr() # gets things started and gives us root window
	cbreak()              # normalizes the terminal
	curs_set(0)           # hide cursor
	noecho()              # dont wait until newline
	nodelay(stdscreen,1)  # this makes input non blocking and returns -1 if not key

	clear()
	max_y,max_x = getmaxyx(stdscreen)
	player =
	Game(
		(x=max_x,y=max_y),
		(x=div(max_x,2),y=div(max_y,2))
	)
end

function Game_render(game::Game)
	clear()
	mvprintw(game.player_pos.y,game.player_pos.x,"@")
	refresh()
end

function Game_run(game::Game)
	# Render first time to show something
	Game_render(game)
	while true
		i = getch()
		if i == -1
			# we have recieved nothing
			continue
		elseif i == 27
			i = getch()
			if i == -1
				# we have received an ESCAPE key
				break
			elseif i == 91
				# We might have an arrow
				i = getch()
				if i == 65
					game.player_pos = (x=game.player_pos.x,y=max(game.player_pos.y-1,0))
				elseif i == 66
					game.player_pos = (x=game.player_pos.x,y=min(game.player_pos.y+1,game.screen_size.y-1))
				elseif i == 67
					game.player_pos = (x=min(game.player_pos.x+1,game.screen_size.x-1),y=game.player_pos.y)
				elseif i == 68
					game.player_pos = (x=max(game.player_pos.x-1,0),y=game.player_pos.y)
				end
				Game_render(game)
			end
		end
	end
	endwin()
end

game = Game_new()
Game_run(game)
