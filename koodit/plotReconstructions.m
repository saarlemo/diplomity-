clear
nRay = 144;

pz = load('pro_specta_proj1_model3_nRay9.mat').pz;
% pz = padarray(pz, [0 0 16]);

f1 = figure(1);
clf
pz = double(pz);
pz = pz ./ max(pz, [], "all");
imshow(pz(:, :, 40))
axis equal

f1.Position = [100 100 640 480];
% colorbar
exportgraphics(f1, 'kuvat/pro_specta_rekonstruktio_proj1_malli3_nRay9.pdf', 'resolution', 1500, 'contenttype', 'vector')
