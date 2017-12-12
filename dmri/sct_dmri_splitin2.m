function [vol1,vol2]=sct_dmri_splitin2(fname,vol,part)
% sct_dmri_splitin2('AxCaliber.nii',30)
% First group has 30 volumes
if ~exist('part','var'), part = [1 2]; end % by default generate the 2 volumes
fname=sct_tool_remove_extension(fname,1);
vol1=[fname '_1.nii.gz'];
if max(ismember(part,1))
    unix(['fslroi ' fname ' ' vol1 ' 0 ' num2str(vol)]);
end

vol2=[fname '_2.nii.gz'];
if max(ismember(part,2))
    unix(['fslroi ' fname ' ' vol2 ' ' num2str(vol) ' -1']);
end