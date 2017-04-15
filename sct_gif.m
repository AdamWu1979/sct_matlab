function sct_gif(M,delay,varargin)
if ~exist('delay','var') || isempty(delay); delay = 0.1; end
M = double(M);
M=M-prctile(M(:),1); M = M/max(M(:))*255;
M = uint8(M);
Mc = mat2cell(M,size(M,1),size(M,2),size(M,3),ones(1,size(M,4)));
Mmosaic = cell2mat(cellfun(@(MM) makeimagestack(MM,varargin{:}), Mc,'UniformOutput', false));
imwrite(permute(Mmosaic(:,end:-1:1,:,:),[2 1 3 4]),gray(255),['img_anim.gif'],'DelayTime',delay,'LoopCount',65535);
