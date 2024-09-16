clear
load('pro_specta_ground_truth_old.mat')

D2 = padarray(imresize3(D2(:,:, 6:end-10), [128 128 66]), [0 0 31]);
phantom = flip(D2, 3);

save('pro_specta_ground_truth.mat', 'phantom')