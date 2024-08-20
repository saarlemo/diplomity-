clear
fname = 'vox_brn.dat';
phantom_xy = 1.5;
phantom_xy_dim = 256;%364;
phantom_z = 1.5;%3.75;
phantom_z_dim = 128;%110;
real_xy = 4.664;
real_xy_dim = 128;
real_z = 4.664;
real_z_dim = 128;

fid = fopen(fname);
phantom = fread(fid, inf, 'uint8');
fclose(fid);

phantom = reshape(phantom, [phantom_xy_dim phantom_xy_dim phantom_z_dim]);


activity_data = fileread('phantom.zub');
lines = strsplit(activity_data, '\n');
splitData = cell(length(lines), 1);
for i = 1:length(lines)
    splitData{i} = strsplit(lines{i}, '  ');
end
splitData = vertcat(splitData{:});
dataTable = cell2table(splitData);
dataTable.splitData2 = str2double(dataTable.splitData2);
dataTable.splitData4 = str2double(dataTable.splitData4);

densities = dataTable.splitData2;
activities = dataTable.splitData4;
phantom = changem(phantom, activities, densities);
phantom = pagetranspose(phantom);



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

volume3Dviewer(phantom, 'fit');

save('cbf1_ground_truth.mat', 'phantom')