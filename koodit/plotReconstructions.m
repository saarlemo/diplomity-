clear
nRay = 144;

pz = load('cbf1_ground_truth.mat').pz;

f1 = figure(1);
clf
pz = double(pz);
pz = pz ./ max(pz, [], "all");
imshow(pz(:, :, 64))
axis equal

f1.Position = [100 100 640 480];
exportgraphics(f1, 'kuvat/cbf_ground_truth.pdf', 'resolution', 1500, 'contenttype', 'vector')
