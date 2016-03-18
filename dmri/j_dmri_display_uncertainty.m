% =========================================================================
% FUNCTION
% generate_uncertainty_maps.m
%
% Generate pretty pictures. 
%
% INPUT
% diff				structure generated by j_dmri_process_dti.m
% 
% OUTPUT
% (-)
%
% COMMENTS
% Julien Cohen-Adad 2009-09-05
% =========================================================================
function j_dmri_display_uncertainty(diff,slice)

if nargin == 1
slice = 16;
end

for i_nex = 1:diff.nex
	
	% Load volume
	nifti = load_nifti(diff.fname_uncertainty{i_nex});
	data = squeeze(nifti.vol(:,:,slice));

	% create image
	h_fig = figure;
	imagesc(data',[0 90])
	axis image
	axis off
	colorbar
	title(['Angular uncertainty at P=0.05 for NAV = ',num2str(i_nex)])
	
	% print figure
	print(h_fig,'-dpng','-r150',[diff.path,filesep,'fig_uncertainty95_nav',num2str(i_nex),'.png']);

	%close 
end


