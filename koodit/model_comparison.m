%% Data load
clear
n_images = 30;
rays = 1:n_images;

nema_arr = calculate_metrics('nema_phantom_proj1_model3_nRay', ...
    "data/nema_phantom/results/nema_ground_truth.mat", n_images, rays);
cbf_arr = calculate_metrics('brain_phantom_proj1_model3_nRay', ...
    "data/brain_phantom/results/cbf1_ground_truth.mat", n_images, rays);

function res_arr = calculate_metrics(fpath, gtpath, n_images, rays)
    options = {};
    pz = {};
    
    for ii = rays
        fname = strcat(fpath, num2str(ii^2), '.mat');
        tmp_struct = load(fname);
        options{ii} = tmp_struct.options;
        pz{ii} = tmp_struct.pz ./ max(tmp_struct.pz, [], 'all');
    end
    
    load(gtpath);
    phantom = single(phantom);
    phantom = phantom ./ max(phantom, [], 'all');
    
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

    res_arr(:, 1) = mse_arr;
    res_arr(:, 2) = ssim_arr;
end

load("data/nema_phantom/results/nema_ground_truth.mat")
phantom = single(phantom);
phantom = phantom ./ max(phantom, [], 'all');

load('nema_phantom_proj6.mat')
pz = single(pz);
pz = pz ./ max(pz, [], 'all');

nema_proj6 = [immse(pz, phantom), ssim(pz, phantom)];

load("data/brain_phantom/results/cbf1_ground_truth.mat")
phantom = single(phantom);
phantom = phantom ./ max(phantom, [], 'all');

load('brain_phantom_proj6.mat')
pz = single(pz);
pz = pz ./ max(pz, [], 'all');

brain_proj6 = [immse(pz, phantom), ssim(pz, phantom)];

%% Plot
f1 = figure(1);
set(f1, 'defaulttextinterpreter', 'latex')

semilogx(rays.^2, nema_arr(:, 2))
hold on
semilogx(rays.^2, cbf_arr(:, 2))
yline(nema_proj6(2), '--')
yline(brain_proj6(2), '--')
hold off
ylabel('SSIM')
ylim([0.9 1])
xlabel('$N$')
legend('NEMA IQ', 'Zubal', 'Location', 'southeast', 'interpreter', 'latex')
grid on

f1.Position = [100 100 640 480];
exportgraphics(f1, strcat("kuvat/vertailu_SSIM.pdf"), 'resolution', 1500, 'contenttype', 'vector')

f2 = figure(2);
set(f2, 'defaulttextinterpreter', 'latex')

semilogx(rays.^2, nema_arr(:, 1))
hold on
semilogx(rays.^2, cbf_arr(:, 1))
yline(nema_proj6(1), '--')
yline(brain_proj6(1), '--')
hold off
ylabel('MSE')
xlabel('$N$')
legend('NEMA IQ', 'Zubal', 'Location', 'northeast', 'interpreter', 'latex')
grid on
ylim([0 0.001])

f2.Position = [100 100 640 480];
exportgraphics(f2, strcat("kuvat/vertailu_MSE.pdf"), 'resolution', 1500, 'contenttype', 'vector')