function sqShifts = computeSpectSquareShifts( ...
    param, ...
    detectors, ...
    ix, ...
    iy, ...
    twoDflag ...
)
    panelNvecX = detectors.xs - detectors.xd; % Unnormalized detector panel normal vector X component
    panelNvecY = detectors.ys - detectors.yd; % Unnormalized detector panel normal vector Y component
    panelNvecXn = panelNvecX / sqrt(panelNvecX.^2 + panelNvecY.^2); % Normalized detector panel normal vector X component
    panelNvecYn = panelNvecY / sqrt(panelNvecX.^2 + panelNvecY.^2); % Normalized detector panel normal vector Y component
    
    % Panel rotation angle
	panelAngle = atan2d(panelNvecY, panelNvecX);

    % Get detector pixel center in local coordinates from ix, iy and size
	pixelCenterX = ix * param.dPitchXY - param.Nx * param.dPitchXY / 2. + param.dPitchXY / 2.;
	pixelCenterY = iy * param.dPitchXY - param.Ny * param.dPitchXY / 2. + param.dPitchXY / 2.;

    % Pixel boundary in local coordinates
    xdMin = pixelCenterX - param.dPitchXY / 2.;
    xdMax = pixelCenterX + param.dPitchXY / 2.;
    ydMin = pixelCenterY - param.dPitchXY / 2.;
    ydMax = pixelCenterY + param.dPitchXY / 2.;
    xsMin = xdMin - param.colD;
    xsMax = xdMax + param.colD;
    ysMin = ydMin - param.colD;
    ysMax = ydMax + param.colD;

    nRay = pow(ceil(sqrt(param.nRaySPECT)), 2);
    detectorShifts = zeros(nRay, 2);
    sourceShifts = zeros(nRay, 2);
    for x = 1:sqrt(nRay)
        for y = 1:sqrt(nRay)
            tmpXd = xdMin + (x - 1) / (sqrt(nRay) - 1) * (xdMax - xdMin);
            tmpYd = ydMin + (y - 1) / (sqrt(nRay) - 1) * (ydMax - ydMin);
            tmpXs = xsMin + (x - 1) / (sqrt(nRay) - 1) * (xsMax - xsMin);
            tmpYs = ysMin + (y - 1) / (sqrt(nRay) - 1) * (ysMax - ysMin);

            detectorShifts((x-1)*sqrt(nRay)+y, :) = [tmpXd tmpYd];
            sourceShifts((x-1)*sqrt(nRay)+y, :) = [tmpXs tmpYs];
        end
    end

    sqShifts = zeros(6, nRay);
    for currentShift = 1:nRay
        xx_d = detectorShifts(currentShift, 1);
        yy_d = detectorShifts(currentShift, 2);
        xx_s = sourceShifts(currentShift, 1);
        yy_s = sourceShifts(currentShift, 2);
            
        if twoDflag
            sqShifts(1:2, currentShift) = [xx_s; yy_s];
            sqShifts(4:5, currentShift) = [xx_d; yy_d];
        else
            sqShifts(1, currentShift) = -sind(panelAngle) * (yy_s-pixelCenterY) - panelNvecX - panelNvecXn * param.colL;
            sqShifts(2, currentShift) = cosd(panelAngle) * (yy_s-pixelCenterY) - panelNvecY - panelNvecYn * param.colL;
            sqShifts(3, currentShift) = xx_s - pixelCenterX;
            sqShifts(4, currentShift) = -sind(panelAngle) * (yy_d-pixelCenterY);
            sqShifts(5, currentShift) = cosd(panelAngle) * (yy_d-pixelCenterY);
            sqShifts(6, currentShift) = xx_d - pixelCenterX;
        end
    end
end

function res = pow(a, b)
    res = a^b;
end