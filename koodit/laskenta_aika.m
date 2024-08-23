clear

data = readtable("../data/nema_phantom/results/nema_phantom_speedtest.csv");
data1 = data(data.projector_type == 1, :);
data6 = data(data.projector_type == 6, :);
G1 = groupsummary(data1, "nRaySPECT", ["mean", "std"], "ntime");
G6 = groupsummary(data6, "nRaySPECT", ["mean", "std"], "ntime");

f1 = figure(1);
set(f1, "defaulttextinterpreter", "latex")
clf
hold on
p1 = plot(G1.nRaySPECT, G1.mean_ntime, "LineWidth", 1);
p2 = plot(G1.nRaySPECT, G1.mean_ntime - 2 * G1.std_ntime, "--", 'Color',p1.Color);
p3 = plot(G1.nRaySPECT, G1.mean_ntime + 2 * G1.std_ntime, "--", 'Color', p1.Color);

x = [G1.nRaySPECT; flipud(G1.nRaySPECT)];
y = [G1.mean_ntime - 2 * G1.std_ntime; flipud(G1.mean_ntime + 2 * G1.std_ntime)];
fill(x, y, p2.Color, 'FaceAlpha', 0.2, 'EdgeColor', 'none');

p4 = yline(G6.mean_ntime, "LineWidth", 1);
p5 = yline(G6.mean_ntime - 2 * G6.std_ntime, "--", 'Color',p4.Color);
p6 = yline(G6.mean_ntime + 2 * G6.std_ntime, "--", 'Color', p4.Color);

hold off
grid on
xlabel('S\"ateiden lukum\"a\"ar\"a')
ylabel("Laskenta-aika (s)")
legend("$\mu$", "$\mu \pm 2\sigma$", "interpreter", "latex", "location", "northwest")
xlim([1 144])

f1.Position = [100 100 640 480];
exportgraphics(f1, strcat("../kuvat/laskenta_aika.pdf"), 'resolution', 1500, 'contenttype', 'vector')
