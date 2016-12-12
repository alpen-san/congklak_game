require_relative 'player'
require_relative 'game_engine'

class Game

	def initialize
		@player1 = ::Player.new
		@player2 = ::Player.new
	end

	def start
		engine = ::GameEngine.new(@player1, @player2)
		until round_end? do
			puts engine.status[:turn]
			puts "Select number holes:"
			hole_number = gets.chomp
			hole_number = hole_number.to_i

			engine.start_play(hole_number)
			@player1 = engine.player1_result
			@player2 = engine.player2_result

			puts "player1:/n#{@player1.holes}, store_house: #{@player1.store_house}"
			puts "player2:/n#{@player2.holes}, store_house: #{@player2.store_house}"
		end

		if @player1.holes_empty?
			@player2.store_house += get_remaining_shell(@player2)
			@player2.holes = Array.new(7, 0)
		else
			@player1.store_house += get_remaining_shell(@player1)
			@player1.holes = Array.new(7, 0)
		end	
	end

	def round_end?
		@player1.holes_empty? || @player2.holes_empty?
	end

	def get_remaining_shell(player)
		remaining_shell = player.holes.inject(:+)
		remaining_shell
	end
end