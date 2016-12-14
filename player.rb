class Player
	attr_accessor :holes, :store_house, :status, :name

	PLAYING = "playing"
	WINNER = "winner"
	LOSER = "loser"

	def initialize(name)
		@holes = Array.new(7, 7)
		@store_house = 0
		@status = PLAYING
		@name = name
	end

	def holes_empty?
		holes.all? { |hole| hole == 0 }
	end
end