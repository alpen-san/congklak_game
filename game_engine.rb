class GameEngine
	attr_reader :status, :player1_result, :player2_result

	PLAYER1 = 'player1'
	PLAYER2 = 'player2'

	def initialize(player1, player2)
		@player1_result = player1
		@player2_result = player2
		@status = {
			hole_place: PLAYER1,
			turn: PLAYER1,
			index_last_hole: 0,
			shell_last_hole: 0
		}
	end

	def start_play(hole_number)
		reset_status_for_hole!
		index_array = hole_number - 1
		while !mati?(@status) do
			index_array = move_shell(index_array)
		end
		tembak!
		change_turn!
	end

	private
	
	def move_shell(index_array)
		player_place = is_hole_place_player1? ? @player1_result : @player2_result
		picked_shell = player_place.holes[index_array]
		player_place.holes[index_array] = 0

		while picked_shell != 0 do
			index_array += 1
			if index_array == 7
				if can_put_shell_in_store_house?(player_place)
					player_place.store_house += 1
					picked_shell -= 1
				end
				if is_hole_place_player1?
					player_place = @player2_result
					@status[:hole_place] = PLAYER2
				else
					player_place = @player1_result
					@status[:hole_place] = PLAYER1
				end
				index_array = -1
			else
				player_place.holes[index_array] += 1
				picked_shell -= 1
			end
		end

		@status[:index_last_hole] = index_array
		@status[:shell_last_hole] = player_place.holes[index_array] if index_array != -1
		index_array
	end

	def mati?(status)
		status[:index_last_hole] == -1 || status[:shell_last_hole] == 1
	end

	def is_turn_player1?
		@status[:turn] == PLAYER1
	end

	def is_turn_player2?
		@status[:turn] == PLAYER2
	end

	def is_hole_place_player1?
		@status[:hole_place] == PLAYER1
	end

	def is_hole_place_player2?
		@status[:hole_place] == PLAYER2
	end

	def change_turn!
		if @status[:index_last_hole] != -1 && is_turn_player1?
			@status[:turn] = PLAYER2
		elsif @status[:index_last_hole] != -1 && is_turn_player2?
			@status[:turn] = PLAYER1
		end
	end

	def tembak!
		if is_turn_player1? && is_hole_place_player1? && @status[:index_last_hole] != -1
			index_opponent = 6 - @status[:index_last_hole]
			@player1_result.store_house += @player2_result.holes[index_opponent]
			@player2_result.holes[index_opponent] = 0
		elsif is_turn_player1? && is_hole_place_player2? && @status[:index_last_hole] != -1
			index_opponent = 6 - @status[:index_last_hole]
			@player2_result.store_house += @player1_result.holes[index_opponent]
			@player1_result.holes[index_opponent] = 0
		end
	end

	def reset_status_for_hole!
		@status[:hole_place] = is_turn_player1? ? PLAYER1 : PLAYER2
		@status[:index_last_hole] = 0
		@status[:shell_last_hole] = 0
	end

	def can_put_shell_in_store_house?(player_place)
		(is_turn_player1? && is_hole_place_player1?) ||
			(is_turn_player2? && is_hole_place_player2?)
	end
end