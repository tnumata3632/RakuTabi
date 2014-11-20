module TourHelper
	ABSOLUTE_ZERO = - 273.15
	def kelvin_to_celsius(degree)
		(degree.to_f + ABSOLUTE_ZERO).round
	end
end
