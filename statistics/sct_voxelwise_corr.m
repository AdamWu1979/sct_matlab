function cis = sct_voxelwise_corr(roi, metric, rangeminmax)
% sct_voxelwise_corr(roi, metric, thr, rangeminmax)
% roi = load_nii_data('MNI-Poly-AMU_WM_roi.nii')>0.7;
% metric = load_nii_data('mtv_merged.nii.gz');
% rangeminmax = [0 1];


%%

figure, imagesc3D(roi); figure

%%
clear cis
colors = jet(size(metric,4));
mt = [];
mrt = [];
for is = 1:2:size(metric,4)
    metric_test=metric(:,:,:,is);
    metric_retest=metric(:,:,:,is+1);
    plot(metric_test(roi),metric_retest(roi),'+','Color',colors(is,:)); hold on
    [cis((is+1)/2) p]=corr(metric_test(roi),metric_retest(roi))
    mt = [mt; metric_test(roi)];
    mrt = [mrt; metric_retest(roi)];
    ciss((is+1)/2) = std(metric_retest(roi) - metric_test(roi))
    cissm((is+1)/2) = mean(metric_retest(roi) - metric_test(roi))
end

plot(rangeminmax,rangeminmax)
%%
axis equal
xlim(rangeminmax)
ylim(rangeminmax)
grid on; 

%%
res = 30;
boundary = mrt<rangeminmax(2) & mrt>rangeminmax(1) & mt<rangeminmax(2) & mt>rangeminmax(1);
values = hist3([mrt(boundary),mt(boundary)],{linspace(rangeminmax(1),rangeminmax(2),res), linspace(rangeminmax(1),rangeminmax(2),res)});
figure,
imagesc(-values);%imfilter(-values,fspecial('gaussian')))
axis xy
hold on;
plot([0 res],[0 res])
colormap gray
grid on
axis equal
xlim([0 res])
ylim([0 res])
colorbar


