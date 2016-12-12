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
		if @status[:turn] == PLAYER1
			reset_status_for_hole
			@status[:hole_place] = PLAYER1
			index_array = hole_number - 1
			while !mati?(@status) do
				index_array = move_shell(index_array)
			end

			# change turn
			@status[:turn] = PLAYER2 if @status[:index_last_hole] != -1
			# tembak
			if @status[:hole_place] == PLAYER1 && @status[:index_last_hole] != -1
				index_opponent = 6 - @status[:index_last_hole]
				@player1_result.store_house += @player2_result.holes[index_opponent]
				@player2_result.holes[index_opponent] = 0
			end
		else
			reset_status_for_hole
			@status[:hole_place] = PLAYER2
			index_array = hole_number - 1
			while !mati?(@status) do
				index_array = move_shell(index_array)
			end

			# change turn
			@status[:turn] = PLAYER1 if @status[:index_last_hole] != -1
			# tembak
			if @status[:hole_place] == PLAYER2 && @status[:index_last_hole] != -1
				index_opponent = 6 - @status[:index_last_hole]
				@player2_result.store_house += @player1_result.holes[index_opponent]
				@player1_result.holes[index_opponent] = 0
			end
		end
	end

	private
	
	def move_shell(index_array)
		player_place = @status[:hole_place] == PLAYER1 ? @player1_result : @player2_result
		picked_shell = player_place.holes[index_array]
		player_place.holes[index_array] = 0

		while picked_shell != 0 do
			index_array += 1
			if index_array == 7 && player_place == @player1_result
				if @status[:turn] == PLAYER1
					player_place.store_house += 1
					picked_shell -= 1
				end
				player_place = @player2_result
				@status[:hole_place] = PLAYER2
				index_array = -1
			elsif index_array == 7 && player_place == @player2_result
				if @status[:turn] == PLAYER2
					player_place.store_house += 1
					picked_shell -= 1
				end
				player_place = @player1_result
				@status[:hole_place] = PLAYER1
				index_array = -1
			else
				player_place.holes[index_array] += 1
				picked_shell -= 1
			end
		end

		@status[:index_last_hole] = index_array
		@status[:shell_last_hole] = player_place.holes[index_array] if index_array != -1
		puts "hole_place: #{@status[:hole_place]}"
		puts "turn: #{@status[:turn]}"
		puts "index_last_hole: #{@status[:index_last_hole]}"
		puts "shell_last_hole: #{@status[:shell_last_hole]}"
		index_array
	end

	def mati?(status)
		status[:index_last_hole] == -1 || status[:shell_last_hole] == 1
	end

	def reset_status_for_hole
		@status[:index_last_hole] = 0
		@status[:shell_last_hole] = 0
	end
end