template<typename T>
inline std::vector<std::vector<T>> computeSpectHexShifts(paramStruct<T>& param, Det<T> detectors, int64_t ix, int64_t iy) {
	uint8_t coneMethod = param.coneMethod; // Method for tracing rays: 1-accurate 2-efficient
	uint8_t hexOrientation = param.hexOrientation; // 1=vertical diameter smaller, 2=horizontal diameter smaller
	T nRay = param.nRaySPECT; // Number of rays in each hexagon: for example 7 for centre and all hexagon corners
	T pixelSize = param.dPitchXY; // Detector pixel size (mm)
	T collimatorLength = param.colL; // Collimator hole length (mm)
	T collimatorDiameter = param.colD;  // Collimator hole diameter (mm)
	T d_septal = param.dSeptal; // Septal thickness (mm)

	// Panel outer normal vector
	T panelNvecX = detectors.xs - detectors.xd; // Unnormalized detector panel normal vector X component
	T panelNvecY = detectors.ys - detectors.yd; // Unnormalized detector panel normal vector Y component
	T panelNvecXn = panelNvecX / std::sqrt(std::pow(panelNvecX, 2) + std::pow(panelNvecY, 2)); // Normalized ...
	T panelNvecYn = panelNvecY / std::sqrt(std::pow(panelNvecX, 2) + std::pow(panelNvecY, 2)); // Normalized ...

	// Panel rotation angle
	T panelAngle = atan2d(panelNvecY, panelNvecX);
	
	// Get detector pixel center in local coordinates from ix, iy and size
	T pixelCenterX = ix * pixelSize - param.Nx * pixelSize / 2. + pixelSize / 2.;
	T pixelCenterY = iy * pixelSize - param.Ny * pixelSize / 2. + pixelSize / 2.;

	// Pixel boundary in local coordinates
	T xMin = pixelCenterX - pixelSize / (T)2.;
	T xMax = pixelCenterX + pixelSize / (T)2.;
	T yMin = pixelCenterY - pixelSize / (T)2.;
	T yMax = pixelCenterY + pixelSize / (T)2.;
	
	// Calculate hexagon grid properties
	T d_vertical; // Vertical distance (y) spanning one hole
	T d_horizontal; // Horizontal distance (x) spanning one hole
	T d_vertical_s; // Vertical distance (y) between hexagon centers
	T d_horizontal_s; // Horizontal distance (x) between hexagon centers

	// 2D position shifts in detector and source ends (for one hexagon)
	std::vector<std::vector<T>> detectorShifts(nRay, std::vector<T>(2, 0)); 
	std::vector<std::vector<T>> sourceShifts(nRay, std::vector<T>(2, 0));

	if (hexOrientation == 1) { // Vertical diameter is smaller
		d_horizontal = collimatorDiameter;
		d_vertical = (T)(std::sqrt(3.)) / (T)2. * d_horizontal;
		d_vertical_s = d_vertical + d_septal;
		d_horizontal_s = (T)(std::sqrt(3.)) / (T)2.  * d_vertical_s;

		detectorShifts = computeHexShifts2D(nRay, (T)0., d_vertical); 
		sourceShifts = computeHexShifts2D(nRay, (T)180., d_vertical);
	} else if (hexOrientation == 2) { // Horizontal diameter is smaller
		d_vertical = collimatorDiameter;
		d_horizontal = (T)(std::sqrt(3.)) / (T)2. * d_vertical;
		d_horizontal_s = d_horizontal + d_septal;
		d_vertical_s = (T)(std::sqrt(3.)) / (T)2. * d_horizontal_s;

		detectorShifts = computeHexShifts2D(nRay, (T)30., d_horizontal);
		sourceShifts = computeHexShifts2D(nRay, (T)210., d_horizontal);
	}

	// Helper variables for hexagon location calculation
	T rowMin = std::floor(yMin / (T)(d_vertical_s)) - 2.;
	T rowMax = std::floor(yMax / (T)(d_vertical_s)) + 2.;
	T colMin = std::floor(xMin / (T)(d_horizontal_s)) - 2.;
	T colMax = std::floor(xMax / (T)(d_horizontal_s)) + 2.;

	// Vector of hexagon centers [x, y]
	std::vector<std::vector<T>> hexCenters((uint32_t)(rowMax - rowMin) * (colMax - colMin), std::vector<T>(2, 0)); 

	T nHex = 0; // Number of hexagons in the pixel
	if (coneMethod == 1) { // Accurate ray locations
		for (int32_t row = rowMin; row <= rowMax; row++) { // Iterate over hexagon rows
			for (int32_t col = colMin; col <= colMax; col++) { // Iterate over hexagon columns
				// Select the next hexagon
				T tmpX = (T)col * d_horizontal_s; // Hex center X
				T tmpY = (T)row * d_vertical_s; // Hex center Y
				if (hexOrientation == 1) { // Vertical diameter is smaller
					// The columns overlap 
					tmpY += std::remainder(col, 2) * d_vertical_s / (T)2.; 
				} else if (hexOrientation == 2) { // Horizontal diameter is smaller
					// The rows overlap
					tmpX += std::remainder(row, 2) * d_horizontal_s / (T)2.; 
				}

				// Validate pixel boundaries
				if ((tmpX >= (xMin - d_horizontal / (T)2.)) && (tmpX <= (xMax + d_horizontal / (T)2.))) {
					if ((tmpY >= (yMin - d_vertical / (T)2.)) && (tmpY <= (yMax + d_vertical / (T)2.))) {
						hexCenters[nHex][0] = tmpX;
						hexCenters[nHex][1] = tmpY;
						nHex++;
					}
				}
			}
		}
	} else if (coneMethod == 2) { // Approximate cone of response
		nHex = 1;
		hexCenters[0][0] = pixelCenterX;
		hexCenters[0][1] = pixelCenterY;
	}

	// Shifts in xs,ys,zs,xd,... with respect to pixel center: initialize empty matrix
	std::vector<std::vector<T>> hexShifts(nHex * nRay, std::vector<T>(6, 0));
	// At the edge of pixel, some rays might be detected by an adjacent pixel. Keep count of valid rays.
	uint16_t trueRayCount = 0; 
	for (uint16_t currentHex = 0; currentHex < nHex; currentHex++) { // Loop over each hexagon
		for (uint16_t currentShift = 0; currentShift < nRay; currentShift++) { // Loop over all rays
			T xx_d = hexCenters[currentHex][0] + detectorShifts[currentShift][0];
			T yy_d = hexCenters[currentHex][1] + detectorShifts[currentShift][1];
			T xx_s = hexCenters[currentHex][0] + sourceShifts[currentShift][0];
			T yy_s = hexCenters[currentHex][1] + sourceShifts[currentShift][1];

			// The panel has been in xy-plane for now.
			// Let us shift the panel by the angle determined before and the radius.
			// First validate pixel boundaries
			if ((xx_d >= xMin) && (xx_d <= xMax) && (yy_d >= yMin) && (yy_d <= yMax)) {
				// Shift from xy-plane (in 2D space) to xz-plane (in 3D space) and rotate.
				hexShifts[trueRayCount][0] = -sind(panelAngle) * (yy_s-pixelCenterY);
				hexShifts[trueRayCount][1] = cosd(panelAngle) * (yy_s-pixelCenterY);
				hexShifts[trueRayCount][2] = xx_s - pixelCenterX;
				hexShifts[trueRayCount][3] = -sind(panelAngle) * (yy_d-pixelCenterY);
				hexShifts[trueRayCount][4] = cosd(panelAngle) * (yy_d-pixelCenterY);
				hexShifts[trueRayCount][5] = xx_d - pixelCenterX;

				// Adjust for panel orientation encoded in variable x
				hexShifts[trueRayCount][0] += - panelNvecX - panelNvecXn * collimatorLength;
				hexShifts[trueRayCount][1] += - panelNvecY - panelNvecYn * collimatorLength;

				trueRayCount++;
			}
		}
	}
	
	hexShifts.resize(trueRayCount);
	return hexShifts;
}