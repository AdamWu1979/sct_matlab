function cis = sct_voxelwise_corr_nii(roi_fname, im4D_fname,erode,slice, thr, rangeminmax)
% sct_voxelwise_corr(roi_fname, im4D_fname,slice, thr, rangeminmax)
% roi_fname = 'segr.nii.gz';
% im4D_fname = 'mtv_mtvr.nii.gz';
% slice = 1:4;
% thr = 0.6;
% rangeminmax = [0 1];

roi = load_nii_data(roi_fname,slice);
if erode
roi = imerode(roi,strel('disk',erode,4));
end
metric = load_nii_data(im4D_fname,slice);

cis = sct_voxelwise_corr(roi>thr, metric, rangeminmax);

