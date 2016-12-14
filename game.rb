require_relative 'player'
require_relative 'game_engine'
require_relative 'congklak_image_console'

class Game
	attr_reader :player1, :player2

	def initialize
		@player1 = ::Player.new("Player 1")
		@player2 = ::Player.new("Player 2")
		@engine = ::GameEngine.new(@player1, @player2)
	end

	def start
		system 'cls'
		::CongklakImageConsole.draw_congklak(@player1, @player2)
		until round_end? do
			puts "Turn #{player_name_turn(@engine.status[:turn])}"
			puts "\n#{@player1.name} holes is in bottom and #{@player2.name} holes is in top"
			puts "Number of holes from 1 - 7 is sorted clockwise"
			puts "Select number holes: (input 'q' if you want to quit)"
			hole_number = gets.chomp
			break if hole_number == "q"
			
			hole_number = change_to_numeric(hole_number)
			if input_valid?(hole_number) && !hole_empty?(@engine.status[:turn], hole_number)
				@engine.start_play(hole_number)
				@player1 = @engine.player1_result
				@player2 = @engine.player2_result

				::CongklakImageConsole.draw_congklak(@player1, @player2)
			else
				puts "Please select number hole from 1 - 7 and hole with shell in it\n\n"
			end
		end

		if @player1.holes_empty? && !@player2.holes_empty?
			@player2.store_house += get_remaining_shell(@player2)
			@player2.holes = Array.new(7, 0)
		elsif @player2.holes_empty? && !@player1.holes_empty?
			@player1.store_house += get_remaining_shell(@player1)
			@player1.holes = Array.new(7, 0)
		end

		if @player1.status == ::Player::PLAYING || @player2.status == ::Player::PLAYING
			change_status_player!
			::CongklakImageConsole.draw_congklak(@player1, @player2)
		end
		puts "#{@player1.name} is the #{@player1.status}"
		puts "#{@player2.name} is the #{@player2.status}"
	end

	private

	def player_name_turn(turn)
		if turn == ::GameEngine::PLAYER1
			@player1.name
		else
			@player2.name
		end
	end

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

	def change_status_player!
		if @player1.store_house > @player2.store_house
			@player1.status = ::Player::WINNER
			@player2.status = ::Player::LOSER
		elsif @player2.store_house > @player1.store_house
			@player2.status = ::Player::WINNER
			@player1.status = ::Player::LOSER
		else
			@player2.status = ::Player::WINNER
			@player1.status = ::Player::WINNER
		end
	end
end