% =========================================================================
% FUNCTION
% j_dmri_display_fa.m
%
% Generate pretty pictures. 
%
% INPUT
% dmri				structure generated by j_dmri_process_dti.m
% 
% OUTPUT
% (-)
%
% COMMENTS
% Julien Cohen-Adad 2009-09-04
% =========================================================================
function display_fa(dmri)

slice		= 8; % if 0, then use dmri.dti.slice
txt			= '32ch 1x1x2';


nb_folders = length(dmri.nifti.folder);
for i_folder = 1:nb_folders
	
	% Load FA
	fa3d = load_nifti([dmri.nifti.folder{i_folder},dmri.nifti.file_dti,'_FA.nii.gz']);
	fa3d = fa3d.vol;
	if slice
		fa = fa3d(:,:,slice);
	else
		fa = squeeze(fa3d(:,:,dmri.fa.slice));
	end

	% create image
	h_fig = figure;
	h_img = imagesc(flipud(fliplr(fa')),[0 1]);
	axis image
	axis off
% 	colorbar
	colormap gray
	[a b c]=fileparts(dmri.nifti.path);
	title({['\bfFA'];[dmri.info,', serie ',dmri.nifti.folder{i_folder}(1:end-1)]})
	
	% print figure
	print(h_fig,'-dpng','-r150',[dmri.nifti.path,filesep,'fig_FA.png']);
% 	print(h_fig,'-dpng','-r150',[dmri.nifti.path,filesep,'fig_FA_serie',num2str(dmri.nifti.folder{i_folder}(1:end-1)),'.png']);

	close 
end



for i_folder = 1:nb_folders
	
	% Load colormap
	v13d = load_nifti([dmri.nifti.folder{i_folder},dmri.nifti.file_dti,'_V1.nii.gz']);
	v13d = v13d.vol;
	if slice
		v1 = v13d(:,:,slice,:);
	else
		v1 = squeeze(v13d(:,:,dmri.fa.slice,:));
	end
	
	facol = zeros(dmri.nifti.nx,dmri.nifti.ny,3);
	for i=1:3
		% modulate by FA
		facol(:,:,i) = v1(:,:,i).*fa;
		% get absolute value
		facol(:,:,i) = abs(facol(:,:,i));
		% rotate
		facol(:,:,i) = facol(:,:,i)';
		% flip
		facol(:,:,i) = flipud(facol(:,:,i));
		facol(:,:,i) = fliplr(facol(:,:,i));
		% truncate to 1
		trunc = facol(:,:,i)<=1;
		facol(:,:,i) = facol(:,:,i).*trunc;
		trunc_inv = facol(:,:,i)>1;
		facol(:,:,i) = facol(:,:,i)+trunc_inv;
	end

	% create image
	h_fig = figure;
	imagesc(facol,[0 1])
	axis image
	axis off
	title({['\bfFA COLORMAP'];[dmri.info,', serie ',dmri.nifti.folder{i_folder}(1:end-1)]})
	
	% print figure
	print(h_fig,'-dpng','-r150',[dmri.nifti.path,filesep,'fig_COLORMAP.png']);
% 	print(h_fig,'-dpng','-r150',[dmri.nifti.path,filesep,'fig_COLORMAP_serie',num2str(dmri.nifti.folder{i_folder}(1:end-1)),'.png']);

	close 
end



