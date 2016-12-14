require_relative 'player'
require_relative 'game_engine'

class Game

	def initialize
		@player1 = ::Player.new
		@player2 = ::Player.new
	end

	def start
		engine = ::GameEngine.new(@player1, @player2)
		puts "player2:\n#{@player2.holes}, store_house: #{@player2.store_house}"
		puts "player1:\nstore_house: #{@player1.store_house}, #{@player1.holes.reverse}\n"
		::CongklakImageConsole.draw_congklak(@player1, @player2)
		until round_end? do
			puts engine.status[:turn]
			puts "Select number holes:"
			hole_number = gets.chomp
			hole_number = change_to_numeric(hole_number)

			if input_valid?(hole_number) && !hole_empty?(engine.status[:turn], hole_number)
				engine.start_play(hole_number)
				@player1 = engine.player1_result
				@player2 = engine.player2_result

				puts "player2:\n#{@player2.holes}, store_house: #{@player2.store_house}"
				puts "player1:\nstore_house: #{@player1.store_house}, #{@player1.holes.reverse}\n"
			else
				puts "Please select number hole from 1 - 7 and hole with shell in it"
			end
		end

		if @player1.holes_empty?
			@player2.store_house += get_remaining_shell(@player2)
			@player2.holes = Array.new(7, 0)
		else
			@player1.store_house += get_remaining_shell(@player1)
			@player1.holes = Array.new(7, 0)
		end	
	end

	private

	def round_end?
		@player1.holes_empty? || @player2.holes_empty?
	end

	def get_remaining_shell(player)
		remaining_shell = player.holes.inject(:+)
		remaining_shell
	end

	def change_to_numeric(input)
		begin
			Integer(input)
		rescue ArgumentError, TypeError
			puts "Invalid input."
		end
	end

	def input_valid?(input)
		input >= 1 && input <= 7
	end

	def hole_empty?(turn, hole_number)
		index_array = hole_number - 1
		if turn == ::GameEngine::PLAYER1
			@player1.holes[index_array] == 0
		elsif turn == ::GameEngine::PLAYER2
			@player2.holes[index_array] == 0
		else
			true
		end
	end
end