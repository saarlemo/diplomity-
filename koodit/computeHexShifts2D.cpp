template<typename T>
inline std::vector<std::vector<T>> computeHexShifts2D(T nPoints, T startAngle, T diameter) {
	std::vector<std::vector<T>> hexShifts(nPoints, std::vector<T>(2, 0)); // A vector of [x, y] pairs
	if (nPoints == 1) { // Trivial case
		return hexShifts;
	}

	uint16_t currentPoint = 0; // Variable to keep count of current point
	T radius = diameter / (T)2.; // Hexagon radius
	T nLayer = std::ceil(0.5 * std::sqrt(4. * ((T)nPoints - 1.) / (T)3. + 1.) - 1.); // Number of hexagon point layers

	T xx_s; // Temporary variable for point location
	T yy_s; // Temporary variable for point location

	for (T currentLayer = 1; currentLayer <= nLayer; currentLayer++) {
		for (T ii = 1; ii <= 6; ii++) { // Iterate over each hexagon angle
			xx_s = currentLayer / (T)nLayer * radius * cosd(startAngle + 60 * ii);
			yy_s = currentLayer / (T)nLayer * radius * sind(startAngle + 60 * ii);

			// Layer k has 6 * k points
			for (uint8_t jj = 1; jj <= currentLayer; jj++) {
				currentPoint++;
				if (currentPoint == nPoints) {
					return hexShifts;
				}

				xx_s -= 1. / (T)nLayer * radius * cosd(startAngle + 60 * ii);
				yy_s -= 1. / (T)nLayer * radius * sind(startAngle + 60 * ii);
				xx_s += 1. / (T)nLayer * radius * cosd(startAngle + 60 * (ii + 1));
				yy_s += 1. / (T)nLayer * radius * sind(startAngle + 60 * (ii + 1));

				hexShifts[currentPoint][0] = xx_s;
				hexShifts[currentPoint][1] = yy_s;
			} 
		}
	}
	return hexShifts;
}