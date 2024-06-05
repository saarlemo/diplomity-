clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modeling parameters
param.nRaySPECT = 1+6+12+18+24; % Number of rays: for example 7 for centre and all hexagon corners
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
% exportgraphics(f2, "../kuvat/2d-kollimaattori.pdf", 'resolution', 1500, 'contenttype', 'vector')

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
% exportgraphics(f3, "../kuvat/3d-kollimaattori2.pdf", 'resolution', 1500, 'contenttype', 'vector')