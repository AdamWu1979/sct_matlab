function sct_moco_apply(fname_mat, fnamein,fnameout)
[list, path]=sct_tools_ls(fname_mat);

Z_index=double(round(cellfun(@(x) cell2mat(textscan(x,'%*[mat.T]%*u%*[_Z]%u%*[.txt]')),list)));
T=cellfun(@(x) cell2mat(textscan(x,'%*[mat.T]%u%*[_Z]%*u%*[.txt]')),list); T=single(T);
j_progress('loading matrix...')
for imat=1:length(list), j_progress(imat/length(list)); M_tmp{imat}=load([path list{imat}]); X(imat)=M_tmp{imat}(1,4); Y(imat)=M_tmp{imat}(2,4); end
j_progress('elapsed')

%% apply transfo
dat = load_nii(fnamein,[],[],[],[],[],1);
j_progress('translating...')
for iT = 1:length(Z_index)
    j_progress(iT/length(Z_index))
    tt = dat.img(:,:,Z_index(iT),T(iT));
    dat.img(:,:,Z_index(iT),T(iT)) = imtranslate(tt,[Y(iT) -X(iT)]./dat.hdr.dime.pixdim([2 3]),'method','cubic');
end
j_progress('done.')
save_nii_v2(dat.img,fnameout,fnamein);
