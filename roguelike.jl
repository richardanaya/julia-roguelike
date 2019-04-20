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
	noecho()              # this prevents cursor from blinking
	nodelay(stdscreen,1)  # this makes input non blocking

	clear()
	max_x,max_y = getmaxyx(stdscreen)
	player =
	Game(
		(x=max_x,y=max_y),
		(x=div(max_x,2),y=div(max_y,2))
	)
end

function Game_render(game::Game)

end

function Game_run(game::Game)
	# Render first time to show something
	Game_render(game)
	while true
		i = getch()
		if i == -1
			continue
		elseif i == 27
			i = getch()
			if i == -1
				break
			elseif i == 91
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