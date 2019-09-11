
clear
clc
close all
base_dir =  'Sec7.1/occlusion';
ext = 'jpg';

addpath('lmatfunc');
addpath('myfunc');
minl=0;
% load data
name = dir([base_dir '/*.' ext]);
name = sort({name.name});
name={name{1} name{2}} ;

intersecratio=0.5;
distonerance=2;
near1=20;%20

for k = 1:2
    [dummy,name{k}] = fileparts(name{k});
    I{k} = imread([base_dir '/' name{k} '.' ext]);
    if ndims(I{k})==3
        I{k} = uint8(sum(double(I{k}),3)/3);  % convert to grayscale
    end
    imsize(:,k) = size(I{k})';
     %Not real canny lines, but the EDPF detector <smile> 
     lines{k}=getCannyLines([base_dir '/' name{k} '.lines'],size(I{k},1),size(I{k},2),0,minl);

end
img1=I{1};
img2=I{2};
lines1=lines{1};
 drawL_cross(img1,lines1)
figure(2)
lines2=lines{2};
 drawL_cross(img2,lines2)

F= load([base_dir '/F.P']);
[isIn,e2] = isEpipoleInImage(F',[size(img2,1),size(img2,2)] );
e2=[e2(1),e2(2),1]';


disthres1=5;
disthres2=15;
angthre1=0.96;
angthre2=0.5;
% 0.2588

cc1=GetcrossPt(lines1,disthres1,disthres2,angthre1,angthre2);
cc2=GetcrossPt(lines2,disthres1,disthres2,angthre1,angthre2);
cc1n=cc1(cc1(:,5)==1,:);
cc2n=cc2(cc2(:,5)==1,:);
cc1f=cc1(cc1(:,5)==2,:);
cc2f=cc2(cc2(:,5)==2,:);


figure(1)
imshow(img1);hold on
for j=1:size(cc1,1)
    plot(cc1(j,3),cc1(j,4),'r*');
    plot([lines1(cc1(j,1),1),lines1(cc1(j,1),3)],[lines1(cc1(j,1),2),lines1(cc1(j,1),4)],'g','LineWidth',2);
    plot([lines1(cc1(j,2),1),lines1(cc1(j,2),3)],[lines1(cc1(j,2),2),lines1(cc1(j,2),4)],'g','LineWidth',2);
end  
figure(2)
imshow(img2);
hold on

for j=1:size(cc2,1)
    plot(cc2(j,3),cc2(j,4),'r*');
    plot([lines2(cc2(j,1),1),lines2(cc2(j,1),3)],[lines2(cc2(j,1),2),lines2(cc2(j,1),4)],'g','LineWidth',2);
    plot([lines2(cc2(j,2),1),lines2(cc2(j,2),3)],[lines2(cc2(j,2),2),lines2(cc2(j,2),4)],'g','LineWidth',2);
end  


[matchresn,matchres1n]=MatchCrossPt(cc1n,cc2n,lines1,lines2,F,e2,4,distonerance,intersecratio,3);
[matchresf,matchres1f]=MatchCrossPt(cc1f,cc2f,lines1,lines2,F,e2,4,distonerance,intersecratio,0);
matchres1=[matchres1n;matchres1f];

%out_inner:
out_inner=0.75;


candidate=EpipolarConstraint(lines1,lines2,F,0.45);
% dismatch=disMatrix2Match(lines1,matchres1,15);
% densematch = AddMatching2(matchres1,lines1,lines2,candidate,dismatch,distonerance, img1,img2);
densematch = addMatching(matchres1,lines1,lines2,candidate,distonerance,intersecratio);
% drawMatch( matchres,lines1,lines2,img1,img2 ,1)
[uniquedense,coreidx]=uniqueDense([densematch(:,1:2);matchresn(:,1:2);matchresf(:,1:2)]);
matchres=uniquedense;
%  drawMatch( matchres,lines1,lines2,img1,img2 ,1,1,2)

[C1, ia1, ic1] = unique(matchres(:,1));
[C2, ia2, ic2] = unique(matchres(:,2));
Mdis1=LDistanceMatrix(lines1(C1,:));
Mdis2=LDistanceMatrix(lines2(C2,:));
t1=ConstructTrianangle(C1,Mdis1,lines1(C1,:),size(lines1,1),20);
t2=ConstructTrianangle(C2,Mdis2,lines2(C2,:),size(lines2,1),20);

M=PairWiseM(matchres,lines1,lines2,F,e2,t1,t2,distonerance,intersecratio);



id11=unique(matchres(:,1));
id22=unique(matchres(:,2));
addpath('./RRWM/utils/');
addpath('./RRWM/Methods/RRWM/'); % Reweighted Random Walks Matching by Cho et al. ECCV2010
[group1,group2] = make_group12(matchres);
[Xraw] = RRWM( M, group1, group2);

E12 = ones(size(lines1,1),size(lines2,1));
XX= zeros(size(E12));
for i=1:size(matchres,1)
    XX(matchres(i,1),matchres(i,2))=Xraw(i);
end
line_MatchAssign
drawMatch( cmatch,lines1,lines2,img1,img2 ,1,1,2)
save([base_dir '/matlabres.mat'])
return
