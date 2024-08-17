clear
fname = '/home/niilo/simind/smc_dir/nema.dat';
fid = fopen(fname);
phantom = fread(fid, inf, 'uint8');

fclose(fid);
densities = 0:9;
activities = [0 60 50 45 40 35 30 2 5 0];
phantom = reshape(phantom, [364 364 110]);
phantom = changem(phantom, activities, densities);
phantom = pagetranspose(phantom);

phantom_xy = 1;
phantom_xy_dim = 364;
phantom_z = 3.75;
phantom_z_dim = 110;
real_xy = 4.664;
real_xy_dim = 128;
real_z = 4.664;
real_z_dim = 128;

phantom_xy_size = phantom_xy * phantom_xy_dim;
phantom_z_size = phantom_z * phantom_z_dim;
real_xy_size = real_xy * real_xy_dim;
real_z_size = real_z * real_z_dim;

requiredSizeXY = real_xy_size - phantom_xy_size;
requiredPixelsXY = requiredSizeXY / phantom_xy;
paddingSizeXY = requiredPixelsXY / 2;

requiredSizeZ = real_z_size - phantom_z_size;
requiredPixelsZ = requiredSizeZ / phantom_z;
paddingSizeZ = requiredPixelsZ / 2;

phantom = padarray(phantom, ...
    [ceil(paddingSizeXY), ceil(paddingSizeXY), ceil(paddingSizeZ)], 0, ...
    'both');

phantom = imresize3(phantom, [128 128 128]);


max(phantom, [], "all");
volume3Dviewer(phantom, 'fit');

save('nema_ground_truth.mat', 'phantom')