function z_lev = sct_template_extractlevels(levels, slicethickness, pct)
% sct_template_extractlevels(levels, slicethickness,pct)
% sct_template_extractlevels(4:-1:1,20)
% sct_template_extractlevels([5 4 3 2],sct_slicethickness('qspace.nii'))
% put everything in a folder ./template_roi
levels_fname=[sct_dir '/data/PAM50/template/PAM50_levels.nii.gz'];

levels_template=load_nii_data(levels_fname);
z_lev=[];
for i=levels
    if ~exist('pct','var'), pct = 50; end
    [~,~,z]=find3d(levels_template==i); z_lev(end+1)=floor(prctile(z,pct));
end
z_lev(z_lev>986)=986;
if exist('slicethickness','var') && ~isempty(slicethickness)
    [templatelist, path]=sct_tools_ls([sct_dir '/data/PAM50/template/PAM50*']);
    %templatelist{end+1}='../../dev/template/diffusion_template.nii';
    mkdir('template_roi')
    mkdir('template_roi/template')
    for ifile =1:length(templatelist)
        template=load_nii([path templatelist{ifile}]);
        template_roi=template.img(:,:,z_lev);
        template_roi=make_nii(double(template_roi),[template.hdr.dime.pixdim(2:3) slicethickness],[],[]);
        save_nii_v2(template_roi,['./template_roi/template/' templatelist{ifile}])
    end
    sct_unix('FSLOUTPUTTYPE=NIFTI; fslmaths ./template_roi/template/PAM50_wm.nii.gz -mul 0.9 -div 0.6 -add ./template_roi/template/PAM50_gm.nii.gz -mul 0.6 ./template_roi/template/diffusion_template.nii.gz')
    
    [tractlist, path]=sct_tools_ls([sct_dir '/data/PAM50/atlas/PAM50_atlas*']);
    mkdir('template_roi/atlas')
    for ifile =1:length(tractlist)
        tract=load_nii([path tractlist{ifile}]);
        tract_roi=tract.img(:,:,z_lev);
        tract_roi=make_nii(double(tract_roi),[template.hdr.dime.pixdim(2:3) slicethickness],[],[]);
        save_nii_v2(tract_roi,['./template_roi/atlas/' tractlist{ifile}])
    end
    sct_unix(['cp ' sct_dir '/data/PAM50/atlas/info_label.txt ./template_roi/atlas/']);
    sct_unix(['cp ' sct_dir '/data/PAM50/template/info_label.txt ./template_roi/template/']);
end