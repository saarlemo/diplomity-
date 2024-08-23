clear
nRay = 144;

pz = load('nema_ground_truth.mat').phantom;%.pz;

f1 = figure(1);
clf
pz = double(pz);
pz = pz ./ max(pz, [], "all");
imshow(pz(:, :, 68))
axis equal

f1.Position = [100 100 640 480];
colorbar
% exportgraphics(f1, 'kuvat/nema_ground_truth.pdf', 'resolution', 1500, 'contenttype', 'vector')
