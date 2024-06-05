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