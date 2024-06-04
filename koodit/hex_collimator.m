clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modeling parameters
param.nRaySPECT = 1+6%+12+18+24; % Number of rays: for example 7 for centre and all hexagon corners
param.coneMethod = 1;
ix = 0; % Pixel index
iy = 0; % Pixel index

% Detector properties
param.Nx = 128; % Panel size, horizontal
param.Ny = 128; % Panel size, vertical
param.dPitchXY = 4.664;

% Collimator properties
param.colL = 32.8; % Collimator hole length
param.colD = 1.4; % Collimator hole diameter
param.hexOrientation = 1; % 1=vertical diameter smaller, 2=horizontal diameter smaller
param.dSeptal = 0.12; % Septal thickness

% Image reconstruction properties
voxelSize = 4.664;
voxelNx = 128;
voxelNy = 128;
voxelNz = 128;
show_grid_lines = 9; % Amount of image area grid lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate detector pixel center in global coordinates (xd, yd, zd)
x = sinogramToX(405, 324.492710000000, param.Nx, param.Ny, param.dPitchXY);
x = x(:, ix*128 + iy + 1);
detectors.xs = x(1); % detectors.xd + panel normal vector x-component
detectors.ys = x(2); % detectors.yd + panel normal vector y-component
detectors.zs = x(3); % detectors.zd
detectors.xd = x(4); % Detector center x in global coordinates
detectors.yd = x(5); % Detector center y in global coordinates
detectors.zd = x(6); % Detector center z in global coordinates

%% 2D one detector pixel plot
param.coneMethod = 1;
hexShifts1 = computeSpectHexShifts(param, detectors, 63, 63, 1);
param.coneMethod = 2;
hexShifts2 = computeSpectHexShifts(param, detectors, 63, 63, 1);

f2 = figure(2);
set(f2, "defaulttextinterpreter", "latex")
tiledlayout(1, 2)

nexttile
hold on
scatter(hexShifts1(4, :), hexShifts1(5, :), 0.1, '.') % Plot points
hold off
ticks = param.dPitchXY * (-10:10);
set(gca,'XTick',ticks,'YTick',ticks)
set(gca,'Layer','top','GridColor','r','GridAlpha',1,...
    'MinorGridLineStyle','-','MinorGridColor',[.92 .51 .93],'MinorGridAlpha',1)
xlim([-2 * param.dPitchXY, 2 * param.dPitchXY])
ylim([-2 * param.dPitchXY, 2 * param.dPitchXY])
xlabel("x (mm)")
ylabel("y (mm)")
axis square
grid on
title('Kollimaattorin malli 1')

nexttile
hold on
scatter(hexShifts2(4, :), hexShifts2(5, :), 0.1, '.') % Plot points
hold off
ticks = param.dPitchXY * (-10:10);
set(gca,'XTick',ticks,'YTick',ticks)
set(gca,'Layer','top','GridColor','r','GridAlpha',1,...
    'MinorGridLineStyle','-','MinorGridColor',[.92 .51 .93],'MinorGridAlpha',1)
xlim([-2 * param.dPitchXY, 2 * param.dPitchXY])
ylim([-2 * param.dPitchXY, 2 * param.dPitchXY])
xlabel("x (mm)")
ylabel("y (mm)")
axis square
grid on
title('Kollimaattorin malli 2')

f2.Position = [100 100 640 480];
% exportgraphics(f2, "2d-kollimaattori.pdf", 'resolution', 1500, 'contenttype', 'vector')

%% 3D Plot
param.coneMethod = 1;
hexShifts2 = x + computeSpectHexShifts(param, detectors, ix, iy, 0);
nHex = size(hexShifts2, 2);

f3 = figure(3);
clf
view(3)

% Extend rays to be plotted
hexShifts2(1:3, :) = hexShifts2(1:3, :) + 1e3 * normc(hexShifts2(1:3, :) - hexShifts2(4:6, :));

hold on
for ii = 1:nHex
    plot3( ...
        hexShifts2([1 4], ii)', ...
        hexShifts2([2 5], ii)', ...
        hexShifts2([3 6], ii)', ...
        color=[0 0.4470 0.7410], ...
        LineWidth=0.01)
end
hold off

% Grid plot: https://stackoverflow.com/a/7325564
xlimits = voxelSize*(voxelNx+1) / 2;
ylimits = voxelSize*(voxelNy+1) / 2;
zlimits = voxelSize*(voxelNz+1) / 2;
xx = linspace(-xlimits, xlimits, show_grid_lines);
yy = linspace(-zlimits, ylimits, show_grid_lines);
zz = linspace(-xlimits, zlimits, show_grid_lines);

[X1, Y1, Z1] = meshgrid(xx([1 end]),yy,zz);
X1 = permute(X1,[2 1 3]); Y1 = permute(Y1,[2 1 3]); Z1 = permute(Z1,[2 1 3]);
X1(end+1,:,:) = NaN; Y1(end+1,:,:) = NaN; Z1(end+1,:,:) = NaN;
[X2, Y2, Z2] = meshgrid(xx,yy([1 end]),zz);
X2(end+1,:,:) = NaN; Y2(end+1,:,:) = NaN; Z2(end+1,:,:) = NaN;
[X3, Y3, Z3] = meshgrid(xx,yy,zz([1 end]));
X3 = permute(X3,[3 1 2]); Y3 = permute(Y3,[3 1 2]); Z3 = permute(Z3,[3 1 2]);
X3(end+1,:,:) = NaN; Y3(end+1,:,:) = NaN; Z3(end+1,:,:) = NaN;

h = line([X1(:);X2(:);X3(:)], [Y1(:);Y2(:);Y3(:)], [Z1(:);Z2(:);Z3(:)]);
set(h, 'Color',[0 0 0 1], 'LineWidth',0.1, 'LineStyle','-')

% Axis properties
axis vis3d
camproj perspective, rotate3d on
axis equal
% xlabel('x')
% ylabel('y')
% zlabel('z')

ax = gca;
ax.Color = 'none';
ax.XColor = 'none'; % Hide the axis lines and ticks by setting their color to 'none'
ax.XLabel.Color=[0 0 0];
ax.XLabel.Visible='on';
ax.XLabel.Position = 1.1 * [0, -ylimits, zlimits];
ax.YColor = 'none';
ax.YLabel.Color=[0 0 0];
ax.YLabel.Visible='on';
ax.YLabel.Position = 1.1 * [-xlimits, 0, zlimits];
ax.ZColor = 'none';
ax.ZLabel.Color=[0 0 0];
ax.ZLabel.Visible='on';
ax.ZLabel.Position = 1.1 * [-xlimits, -ylimits, 0];
ax.ZLabel.Rotation = 0;

f3.Position = [100 100 640 480];
% exportgraphics(f3, "3d-kollimaattori2.pdf", 'resolution', 1500, 'contenttype', 'vector')

%%
function hexShifts = computeHexShifts2D(nPoints, startAngle, diameter)
    arguments (Input)
        nPoints     (1, 1) double % Number of points inside hexagon
        startAngle  (1, 1) double % Angle at which the first point is placed (deg)
        diameter    (1, 1) double % Hexagon diameter (mm)
    end

    arguments (Output)
        hexShifts   (:, 2) double % Array of coordinate pairs of shifts
    end

    hexShifts = zeros(nPoints, 2);

    if nPoints == 1 % Trivial case
        return
    end

    currentPoint = 1; % Variable to keep count of current point
    nLayer = ceil(0.5 * sqrt(4. * (nPoints - 1.) / 3. + 1.) - 1.); % Number of hexagon point layers
    radius = diameter / 2.; % Hexagon radius
    
    for currentLayer = 1:nLayer 
        for ii = 1:6
            xx_s = currentLayer / nLayer * radius * cosd(startAngle + 60 * ii);
            yy_s = currentLayer / nLayer * radius * sind(startAngle + 60 * ii);

            % Layer k has 6 * k points
            for jj = 1:currentLayer
                currentPoint = currentPoint + 1;
                if currentPoint == (nPoints + 1)
                    return
                end

                xx_s = xx_s - 1 / nLayer * radius * cosd(startAngle + 60 * ii);
                yy_s = yy_s - 1 / nLayer * radius * sind(startAngle + 60 * ii);
                xx_s = xx_s + 1 / nLayer * radius * cosd(startAngle + 60 * (ii + 1));
                yy_s = yy_s + 1 / nLayer * radius * sind(startAngle + 60 * (ii + 1));

                hexShifts(currentPoint, 1) = xx_s;
                hexShifts(currentPoint, 2) = yy_s;

            end
        end
    end
    return
end

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

function returnList = sinogramToX(angles, radii, nx, ny, crxy)
    arguments (Input)
        angles  (:, 1) double % Column vector of panel angles
        radii   (:, 1) double % Column vector of panel radii
        nx      (1, 1) double % Detector column count
        ny      (1, 1) double % Detector row count
        crxy    (1, 1) double % Detector crystal pitch
    end

    arguments (Output)
        returnList (6, :) double % Each column corresponds to source xyz and detector xyz in that order
    end

    if (numel(angles) ~= numel(radii))
        error('Different amount of angles and radii')
    end

    nIter = numel(angles);
    returnList = zeros(6, nIter * nx * ny);
    
    panelXmin = -crxy * (nx - 1) / 2;
    panelXmax = -panelXmin;
    panelYmin = -crxy * (ny - 1) / 2;
    panelYmax = -panelYmin;
    
    % Detector x points
    x = zeros(ny, nx);
    
    % Detector y points
    y = repmat(linspace(panelYmin, panelYmax, ny)', [1, nx]);
    
    % Detector z points
    z = repmat(linspace(panelXmin, panelXmax, nx), [ny, 1]);
    
    % Rotate and move
    idxCounter = 1;
    for nn = 1:nIter
        ang = angles(nn);
        rr = radii(nn);
        
        nVec = rr*[cosd(ang); sind(ang)]; % Panel normal
        R = [cosd(ang) -sind(ang); sind(ang) cosd(ang)]; % Rotation matrix
        for ii = 1:nx
            for jj = 1:ny
                detXY = R * [x(jj, ii); y(jj, ii)] + nVec;
                detZ = z(jj, ii);
    
                returnList(:, idxCounter) = [detXY + nVec; detZ; detXY; detZ];
                
                idxCounter = idxCounter + 1;
            end
        end
    end
end