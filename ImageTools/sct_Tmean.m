function sct_Tmean(fname)
[basename,~, ext]=sct_tool_remove_extension(fname,1);
save_nii_v2(mean(load_nii_data(fname),4),[basename '_mean' ext],fname)
