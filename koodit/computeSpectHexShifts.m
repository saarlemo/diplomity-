function hexShifts = computeSpectHexShifts( ...
    param, ...
    detectors, ...
    ix, ...
    iy, ...
    twoD ...
)
    coneMethod = param.coneMethod; % Method for tracing rays: 1 for accurate location of rays, 2 for one cone at center of pixel
	hexOrientation = param.hexOrientation; % 1=vertical diameter smaller, 2=horizontal diameter smaller
	nRay = param.nRaySPECT; % Number of rays in each hexagon: for example 7 for centre and all hexagon corners
	pixelSize = param.dPitchXY; % Detector pixel size (mm)
	collimatorLength = param.colL; % Collimator hole length (mm)
	collimatorDiameter = param.colD;  % Collimator hole diameter (mm)
	d_septal = param.dSeptal; % Septal thickness (mm)

    panelNvecX = detectors.xs - detectors.xd; % Unnormalized detector panel normal vector X component
    panelNvecY = detectors.ys - detectors.yd; % Unnormalized detector panel normal vector Y component
    panelNvecXn = panelNvecX / sqrt(panelNvecX.^2 + panelNvecY.^2); % Normalized detector panel normal vector X component
    panelNvecYn = panelNvecY / sqrt(panelNvecX.^2 + panelNvecY.^2); % Normalized detector panel normal vector Y component
    
    % Panel rotation angle
	panelAngle = atan2d(panelNvecY, panelNvecX);

    % Get detector pixel center in local coordinates from ix, iy and size
	pixelCenterX = ix * pixelSize - param.Nx * pixelSize / 2. + pixelSize / 2.;
	pixelCenterY = iy * pixelSize - param.Ny * pixelSize / 2. + pixelSize / 2.;

    % Pixel boundary in local coordinates
    xMin = pixelCenterX - pixelSize / 2.;
    xMax = pixelCenterX + pixelSize / 2.;
    yMin = pixelCenterY - pixelSize / 2.;
    yMax = pixelCenterY + pixelSize / 2.;

    % Calculate hexagon grid properties
    if (hexOrientation == 1)
        d_horizontal = collimatorDiameter;
        d_vertical = sqrt(3.) / 2. * d_horizontal;
        d_vertical_s = d_vertical + d_septal;
        d_horizontal_s = sqrt(3.) / 2. * d_vertical_s;
        
        detectorShifts = computeHexShifts2D(nRay, 0., d_vertical); 
        sourceShifts = computeHexShifts2D(nRay, 180., d_vertical);
    elseif (hexOrientation == 2)
        d_vertical = collimatorDiameter;
		d_horizontal = sqrt(3.) / 2. * d_vertical;
		d_horizontal_s = d_horizontal + d_septal;
		d_vertical_s = sqrt(3.) / 2. * d_horizontal_s;

		detectorShifts = computeHexShifts2D(nRay, 30., d_horizontal);
		sourceShifts = computeHexShifts2D(nRay, 210., d_horizontal);
    end

    % Helper variables for hexagon location calculation
	rowMin = floor(yMin / d_vertical_s) - 2.;
	rowMax = floor(yMax / d_vertical_s) + 2.;
	colMin = floor(xMin / d_horizontal_s) - 2.;
	colMax = floor(xMax / d_horizontal_s) + 2.;

    hexCenters = zeros((rowMax - rowMin) * (colMax - colMin), 2);

    nHex = 0; % Number of hexagons in the pixel
    if (coneMethod == 1)
        for row = rowMin:rowMax
            for col = colMin:colMax
                tmpX = col * d_horizontal_s;
                tmpY = row * d_vertical_s;
                if (hexOrientation == 1)
                    tmpY = tmpY + rem(col, 2) * d_vertical_s / 2;
                elseif (hexOrientation == 2)
                    tmpX = tmpX + rem(row, 2) * d_horizontal / 2;
                end

                if ((tmpX >= (xMin - d_horizontal / 2.)) && (tmpX <= (xMax + d_horizontal / 2.))) % Check pixel boundaries X
					if ((tmpY >= (yMin - d_vertical / 2.)) && (tmpY <= (yMax + d_vertical / 2.))) % Check pixel boundaries Y
                        nHex = nHex + 1;
						hexCenters(nHex, 1) = tmpX;
						hexCenters(nHex, 2) = tmpY;	
                    end
                end
            end
        end
    elseif (coneMethod == 2)
        nHex = 1;
        hexCenters = [pixelCenterX pixelCenterY];
    end

    hexShifts = zeros(6, nHex * nRay);
    trueRayCount = 0;
    for currentHex = 1:nHex
        for currentShift = 1:nRay
            xx_d = hexCenters(currentHex, 1) + detectorShifts(currentShift, 1);
            yy_d = hexCenters(currentHex, 2) + detectorShifts(currentShift, 2);
            xx_s = hexCenters(currentHex, 1) + sourceShifts(currentShift, 1);
            yy_s = hexCenters(currentHex, 2) + sourceShifts(currentShift, 2);

            % if ((xx_s >= xMin) && (xx_s <= xMax) && (yy_s >= yMin) && (yy_s <= yMax)) % Check pixel boundaries
				if ((xx_d >= xMin) && (xx_d <= xMax) && (yy_d >= yMin) && (yy_d <= yMax)) % Check pixel boundaries
                    trueRayCount = trueRayCount + 1;
                    if twoD
                        hexShifts(1:2, trueRayCount) = [xx_s; yy_s];
                        hexShifts(4:5, trueRayCount) = [xx_d; yy_d];
                    else
                    hexShifts(1, trueRayCount) = -sind(panelAngle) * (yy_s-pixelCenterY) - panelNvecX - panelNvecXn * collimatorLength;
                    hexShifts(2, trueRayCount) = cosd(panelAngle) * (yy_s-pixelCenterY) - panelNvecY - panelNvecYn * collimatorLength;
                    hexShifts(3, trueRayCount) = xx_s - pixelCenterX;
                    hexShifts(4, trueRayCount) = -sind(panelAngle) * (yy_d-pixelCenterY);
                    hexShifts(5, trueRayCount) = cosd(panelAngle) * (yy_d-pixelCenterY);
                    hexShifts(6, trueRayCount) = xx_d - pixelCenterX;
                    end
                end
            % end
        end
    end
    hexShifts = hexShifts(:, 1:trueRayCount);
    return
end