function sct_dcm_addextension(dcmfiles)
% sct_dcm_addextension('MR*')
% add .dcm at the end of all dicoms
for ii = 1:length(dcmfiles)
unix(['mv ' dcmfiles{ii} ' ' dcmfiles{ii} '.dcm']);
end

% Faster but need to launch from terminal
%sct_unix(['for f in ' dcmfiles ' ; do  mv \$f \$f.dcm; done']);
