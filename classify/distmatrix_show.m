% Useful visualization of a distance matrix of clustered points.
%
% D is sorted into k blocks, where the ith block contains all the points in
% cluster i. When D is displayed the blocks are shown explicitly.  Hence
% for a good clustering (under a spherical gaussian assumption) the
% 'diagnol' blocks ought to be mostly dark, and all other block ought to be
% relatively white.  One can thus quickly visualize the quality of the
% clustering, or even how clusterable the points are.  Outliers (according
% to IDX) are removed from D.
%
% USAGE
%  distmatrix_show( D, IDX )
%
% INPUTS
%  D       - nxn distance matrix
%  IDX     - cluster membership [see kmeans2.m]
%   
% OUTPUTS
%
% EXAMPLE
%  % not the best example since points are already ordered
%  [X,IDX_true] = demogendata(100,0,2,2,10,2,0);  
%  distmatrix_show( dist_euclidean(X,X), IDX_true );
%
% See also VISUALIZE_DATA, KMEANS2

% Piotr's Image&Video Toolbox      Version 1.03   PPD
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu 
% Please email me if you find bugs, or have suggestions or questions! 
 
function distmatrix_show( D, IDX )

k = max(IDX);
n = size(D,1);

%%% remove outliers from D and IDX
inliers = IDX>0;
D = D( inliers, inliers );
IDX = IDX( inliers );

%%% get order of points and rearrange D and IDX
order = IDX2order( IDX );
IDX = IDX( order );
D = D( order, order );

%%% show D and lines seperating super clusters.
clf; subplot(1,2,1); im(D); hold('on')
cnts = zeros(1,k); for i=1:k; cnts(i) = sum( IDX==i ); end; 
cumCnts = cumsum(cnts); 
for i=1:k-1
  line( [.5,n+.5], [cumCnts(i)+.5,cumCnts(i)+.5] ); 
  line( [cumCnts(i)+.5,cumCnts(i)+.5], [.5,n+.5] ); 
end;
hold('off')    

%%% show smoothed version of D
inds = 1:k; inds = inds( cnts>0 );
cumCnts = [0 cumCnts];  Dsm = D;
for i=inds; 
  rs = cumCnts(i)+1:cumCnts(i+1);
  for j=inds;    
    cs = cumCnts(j)+1:cumCnts(j+1);
    ds = D( rs, cs  );
    Dsm( rs, cs ) = mean(ds(:));
  end;
end;
subplot(1,2,2); im( Dsm );
