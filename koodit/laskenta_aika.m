clear

data = readtable("../data/nema_phantom/results/nema_phantom_speedtest.csv");
G = groupsummary(data, "nRaySPECT", ["mean", "std"], "ntime");

f1 = figure(1);
set(f1, "defaulttextinterpreter", "latex")
clf
hold on
p1 = plot(G.nRaySPECT, G.mean_ntime, "LineWidth", 1);
p2 = plot(G.nRaySPECT, G.mean_ntime - 2 * G.std_ntime, "--");
p3 = plot(G.nRaySPECT, G.mean_ntime + 2 * G.std_ntime, "--", 'Color', p2.Color);

x = [G.nRaySPECT; flipud(G.nRaySPECT)];
y = [G.mean_ntime - 2 * G.std_ntime; flipud(G.mean_ntime + 2 * G.std_ntime)];
fill(x, y, p2.Color, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
hold off
grid on
xlabel('S\"ateiden lukum\"a\"ar\"a')
ylabel("Laskenta-aika (s)")
legend("$\mu$", "$\mu \pm 2\sigma$", "interpreter", "latex", "location", "northwest")

f1.Position = [100 100 640 480];
exportgraphics(f1, strcat("../kuvat/laskenta_aika.pdf"), 'resolution', 1500, 'contenttype', 'vector')
