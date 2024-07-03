template<typename T>
inline std::vector<std::vector<T>> computeSpectSquareShifts(paramStruct<T>& param, Det<T> detectors, int64_t ix, int64_t iy) {
	// Panel outer normal vector
	T panelNvecX = detectors.xs - detectors.xd; // Unnormalized detector panel normal vector X component
	T panelNvecY = detectors.ys - detectors.yd; // Unnormalized detector panel normal vector Y component
	T panelNvecXn = panelNvecX / std::sqrt(std::pow(panelNvecX, 2) + std::pow(panelNvecY, 2)); // Normalized ...
	T panelNvecYn = panelNvecY / std::sqrt(std::pow(panelNvecX, 2) + std::pow(panelNvecY, 2)); // Normalized ...

	// Panel rotation angle
	T panelAngle = atan2d(panelNvecY, panelNvecX);
	
	// Get detector pixel center in local coordinates from ix, iy and size
	T pixelCenterX = ix * param.dPitchXY - param.Nx * param.dPitchXY / 2. + param.dPitchXY / 2.;
	T pixelCenterY = iy * param.dPitchXY - param.Ny * param.dPitchXY / 2. + param.dPitchXY / 2.;

	// Pixel boundary in local coordinates
	T xdMin = pixelCenterX - param.dPitchXY / (T)2.;
	T xdMax = pixelCenterX + param.dPitchXY / (T)2.;
	T ydMin = pixelCenterY - param.dPitchXY / (T)2.;
	T ydMax = pixelCenterY + param.dPitchXY / (T)2.;
	T xsMin = xdMin - param.colD;
	T xsMax = xdMax + param.colD;
	T ysMin = ydMin - param.colD;
	T ysMax = ydMax + param.colD;

	T nRay = std::pow(std::ceil(std::sqrt(param.nRaySPECT)), 2);
	std::vector<std::vector<T>> detectorShifts(nRay, std::vector<T>(2, 0));; // 2D position shifts in detector end (for one hexagon)
	std::vector<std::vector<T>> sourceShifts(nRay, std::vector<T>(2, 0));; // 2D position shifts in source end (for one hexagon)

	for (uint32_t x = 0; x < std::sqrt(nRay); x++) {
		for (uint32_t y = 0; y < std::sqrt(nRay); y++) {
			T tmpXd = xdMin + x / (std::sqrt(nRay) - 1) * (xdMax - xdMin);
			T tmpYd = ydMin + y / (std::sqrt(nRay) - 1) * (ydMax - ydMin);
			T tmpXs = xsMin + x / (std::sqrt(nRay) - 1) * (xsMax - xsMin);
			T tmpYs = ysMin + y / (std::sqrt(nRay) - 1) * (ysMax - ysMin);

			detectorShifts[x * std::sqrt(nRay) + y][0] = tmpXd;
			detectorShifts[x * std::sqrt(nRay) + y][1] = tmpYd;
			sourceShifts[x * std::sqrt(nRay) + y][0] = tmpXs;
			sourceShifts[x * std::sqrt(nRay) + y][1] = tmpYs;
		}	
	}

	std::vector<std::vector<T>> sqShifts(nRay, std::vector<T>(6, 0));
	for (uint32_t currentShift = 0; currentShift < nRay; currentShift++) {
		T xx_d = detectorShifts[currentShift][0];
		T yy_d = detectorShifts[currentShift][1];
		T xx_s = sourceShifts[currentShift][0];
		T yy_s = sourceShifts[currentShift][1];

		sqShifts[currentShift][0] = -sind(panelAngle) * (yy_s-pixelCenterY) - panelNvecX - panelNvecXn * param.colL;
		sqShifts[currentShift][1] = cosd(panelAngle) * (yy_s-pixelCenterY) - panelNvecY - panelNvecYn * param.colL;
		sqShifts[currentShift][2] = xx_s - pixelCenterX;
		sqShifts[currentShift][3] = -sind(panelAngle) * (yy_d-pixelCenterY);
		sqShifts[currentShift][4] = cosd(panelAngle) * (yy_d-pixelCenterY);
		sqShifts[currentShift][5] = xx_d - pixelCenterX;
	}

	return sqShifts;
}