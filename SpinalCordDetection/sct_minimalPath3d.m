function [coord,binary,S] = sct_minimalPath3d(Img,factx,homogeneousmod , display)

% MINIMALPATH Recherche du chemin minimum de Haut vers le bas et de
% bas vers le haut tel que décrit par Luc Vincent 1998
% [sR,sC,S] = MinimalPath(I,factx)
%
%   I     : Image d'entrï¿½e dans laquelle on doit trouver le
%           chemin minimal
%   factx : Poids de linearite [1 10]
%
% Programme par : Ramnada Chav
% Date : 22 février 2007
% Modifié le 16 novembre 2007

if nargin < 3
    display = false;
end

if nargin==1
    factx=1.05;
end

mask=isinf(Img) | isnan(Img) | Img==0;
Img(mask)=0;
[m, n, p ] = size(Img);
J=ones([m n p 2]).*Inf;
ValSup=sum(sum(sum(Img)));

for iv = 1:2 % top to bottom (iv==1) / then bottom to top (iv==2)..
    if iv == 1
        II = Img;
    elseif iv==2
        II = Img(:,:,end:-1:1);
    end
    
    
    J(:,:,1,iv)=0;
    J_sum2=II(:,:,1).^2;
    J_moy=II(:,:,1);
    J_sum3=ValSup*ones(m,n,9);
    J_moy3=zeros(m,n,9);
    
    for islice=2:p
        
        if homogeneousmod
            
            J_sum3(2:m,1:n,1) = II(2:m,1:n,islice).^2 + J_sum2(1:m-1,:);
            J_moy3(2:m,1:n,1) = ( II(2:m,1:n,islice) + (islice-1)*J_moy(1:m-1,:) )/islice;
            J_sum3(1:m,2:n,2) = II(1:m,2:n,islice).^2 + J_sum2(:,1:n-1);
            J_moy3(1:m,2:n,2) = ( II(1:m,2:n,islice) + (islice-1)*J_moy(:,1:n-1) )/islice;
            
            J_sum3(1:m,1:n,3) = II(1:m,1:n,islice).^2 + J_sum2;
            J_moy3(1:m,1:n,3) =( II(1:m,1:n,islice) + (islice-1)*J_moy )/islice;
            
            J_sum3(1:m-1,1:n,4) = II(1:m-1,1:n,islice).^2 + J_sum2(2:m,:);
            J_moy3(1:m-1,1:n,4) = ( II(1:m-1,1:n,islice) + (islice-1)*J_moy(2:m,:) )/islice;
            J_sum3(1:m,1:n-1,5) = II(1:m,1:n-1,islice).^2 + J_sum2(:,2:n);
            J_moy3(1:m,1:n-1,5) = ( II(1:m,1:n-1,islice) + (islice-1)*J_moy(:,2:n) )/islice;
            
            J_sum3(2:m,2:n,6) = II(2:m,2:n,islice).^2 + J_sum2(1:m-1,1:n-1);
            J_moy3(2:m,2:n,6) = ( II(2:m,2:n,islice) + (islice-1)*J_moy(1:m-1,1:n-1) )/islice;
            J_sum3(1:m-1,2:n,7) = II(1:m-1,2:n,islice).^2 + J_sum2(2:m,1:n-1);
            J_moy3(1:m-1,2:n,7) = ( II(1:m-1,2:n,islice) + (islice-1)*J_moy(2:m,1:n-1) )/islice;
            
            J_sum3(1:m-1,1:n-1,8) = II(1:m-1,1:n-1,islice).^2 + J_sum2(2:m,2:n);
            J_moy3(1:m-1,1:n-1,8) = ( II(1:m-1,1:n-1,islice) + (islice-1)*J_moy(2:m,2:n) )/islice;
            J_sum3(2:m,1:n-1,9) = II(2:m,1:n-1,islice).^2 + J_sum2(1:m-1,2:n);
            J_moy3(2:m,1:n-1,9) = ( II(2:m,1:n-1,islice) + (islice-1)*J_moy(1:m-1,2:n) )/islice;

            J_std=J_sum3/islice-J_moy3.^2;
            J_std(:,:,[1 2 4 5 6 7 8 9]) = J_std(:,:,[1 2 4 5 6 7 8 9]) *factx;
            
            
            [~, IImin]=min(J_std,[],3);
            IImin=intmodefilt(IImin,[2 2]); IImin(IImin==0)=1;
           % imagesc(IImin); drawnow
            [X,Y]=meshgrid(1:n,1:m);
            ind = sub2ind(size(J_std),Y(:),X(:),IImin(:));
            
            J_sum2=reshape(J_sum3(ind),m,n);
            J_moy=reshape(J_moy3(ind),m,n);
            J(:,:,islice,iv) = reshape(J_std(ind),m,n);
            
        else
            vectx=2:m-1;
            vecty=2:n-1;
            pJ=squeeze(J(:,:,islice-1));
            %     pP=cPixel(i-1,:);
            cP=squeeze(II(:,:,islice));
            cPm=squeeze(II(:,:,islice-1));
            %     Iq=[pP(vect-1);pP(vect);pP(vect+1)];
            VI=repmat(cP(vectx,vecty),1,1,5);
            VIm=repmat(cPm(vectx,vecty),1,1,5);
            %     VI=Ip;
            VI(:,:,1:2)=VI(:,:,1:2).*factx; 
            VI(:,:,4:5)=VI(:,:,4:5).*factx;
            Jq=cat(3,pJ(vectx-1,vecty),pJ(vectx,vecty-1),pJ(vectx,vecty),pJ(vectx,vecty+1),pJ(vectx+1,vecty));
             
            J(2:end-1,2:end-1,islice,iv)=min(Jq+VI,[],3);
        end
    end
end


S=J(:,:,:,1)+J(:,:,end:-1:1,2);
[Cx,mx]=min(S,[],1);
[Cy,my]=min(Cx,[],2);

coord=[mx(:,my)',my(:),[1:p]'];

binary=false(m,n,p);
for islice=1:p
    binary(mx(1,my(islice),islice),my(islice),islice)=true;
end

if display
    figure(46)
    imagesc(squeeze(S(floor(end/2),:,:))',[prctile(S(:),10) prctile(S(:),90)]); axis image
    figure(47)
    imagesc(squeeze(S(:,floor(end/2),:))',[prctile(S(:),10) prctile(S(:),90)]); axis image
    figure(48)
    imagesc(squeeze(Img(floor(end/2),:,:))',[prctile(Img(:),10) prctile(Img(:),90)]); axis image
end

function a=intmodefilt(a,nhood)
[ma,na] = size(a);
aa(ma+nhood(1)-1,na+nhood(2)-1) = 0;
aa(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na)) = a;
[~,a(:)] = max(histc(im2col(aa,nhood,'sliding'),min(a(:))-1:max(a(:))));
a = a-1;

% % [mv2,mi2]=min(fliplr(S),[],2);]
% sR=(1:m)';
% sC=round(mi1);
%
% if display
%     figure(47)
%     sc(nC);
%     hold on
%     plot(sC,sR,'r')
% end