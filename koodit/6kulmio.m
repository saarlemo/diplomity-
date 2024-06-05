clear

for nLayer = 0:3
    nPoints = 1 + sum(6*(0:nLayer));
    diameter = 2;
    hexShifts = computeHexShifts2D(nPoints, 0, diameter);
    [hexVerticesX, hexVerticesY] = pol2cart(0:pi/3:2*pi, ones(1,7));
    
    f1 = figure(1);clf
    hold on
    scatter(hexShifts(:, 1), hexShifts(:, 2),50,'.') % Plot points
    plot(hexVerticesX, hexVerticesY, "--", "color", [0.8 0.8 0.8]) % Plot hexagon outline
    hold off
    axis square
    
    ax = gca;
    ax.Color = 'none';
    ax.XColor = 'none'; % Hide the axis lines and ticks by setting their color to 'none'
    ax.YColor = 'none'; % Hide the axis lines and ticks by setting their color to 'none'
    xlim([-1.5 1.5])
    ylim([-1.5 1.5])
    
    f3.Position = [100 100 400 400];
    fileName = strcat("../kuvat/6kulmio", num2str(nLayer), ".pdf");
    exportgraphics(f1, fileName, 'resolution', 300, 'contenttype', 'vector')
end

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