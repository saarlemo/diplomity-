clear
nRay = 144;

pz = load(strcat("data/nema_phantom/results/nema1_model3_nRay", num2str(nRay), ".mat")).pz;

f1 = figure(1);
clf
pz = double(pz);
pz = pz ./ max(pz, [], "all");
imshow(pz(:, :, 68))
axis equal

f1.Position = [100 100 640 480];
exportgraphics(f1, strcat("kuvat/rekonstruktio_nRay", num2str(nRay),".pdf"), 'resolution', 1500, 'contenttype', 'vector')
