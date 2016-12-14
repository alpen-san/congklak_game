class CongklakImageConsole
	def self.draw_congklak(player1, player2)
		top_hole = " //==|" + player2.holes.join('|==|') + "|==\\\\ "
		bottom_hole = " \\\\==|" + player1.holes.reverse.join('|==|') + "|==// "
		top_hole_length = top_hole.length - 6
		bottom_hole_length = bottom_hole.length - 6
		maximum_length = if top_hole_length >= bottom_hole_length
			top_hole_length
		else
			bottom_hole_length
		end
		center_hole = "|#{player1.store_house}|" + ("=" * maximum_length) + "|#{player2.store_house}|"
		results = [top_hole, center_hole, bottom_hole, " "]
		puts results.join("\n")
	end
end