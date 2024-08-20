%% Data load
clear
n_images = 30;
rays = 1:n_images;

options = {};
pz = {};

for ii = rays
    fname = strcat('nema_phantom_proj1_model3_nRay', num2str(ii^2), '.mat');
    tmp_struct = load(fname);
    options{ii} = tmp_struct.options;
    pz{ii} = tmp_struct.pz ./ max(tmp_struct.pz, [], 'all');
end

load("data/nema_phantom/results/nema_ground_truth.mat");
phantom = single(phantom);
phantom = phantom ./ max(phantom, [], 'all');

%% Metrics calculation
mse_arr = zeros(n_images, 1);
ssim_arr = zeros(n_images, 1);
psnr_arr = zeros(n_images, 1);
multissim_arr = zeros(n_images, 1);
for ii = rays
    mse_arr(ii) = immse(pz{ii}, phantom);
    ssim_arr(ii) = ssim(pz{ii}, phantom);
    psnr_arr(ii) = psnr(pz{ii}, phantom);
    multissim_arr(ii) = multissim3(pz{ii}, phantom);
end

%% Plot
f1 = figure(1);
set(f1, 'defaulttextinterpreter', 'latex')

semilogx(rays.^2, ssim_arr)
ylabel('SSIM')
ylim([0.9 1])
xlabel('$N$')
grid on

f1.Position = [100 100 640 480];
% exportgraphics(f1, strcat("kuvat/cbf_vertailu_SSIM.pdf"), 'resolution', 1500, 'contenttype', 'vector')

f2 = figure(2);
set(f2, 'defaulttextinterpreter', 'latex')
semilogx(rays.^2, mse_arr)
ylabel('MSE')
xlabel('$N$')
grid on
ylim([0 0.001])

f2.Position = [100 100 640 480];
% exportgraphics(f2, strcat("kuvat/nema_vertailu_MSE.pdf"), 'resolution', 1500, 'contenttype', 'vector')
