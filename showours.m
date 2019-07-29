base_dir =  'Sec7.1/light';
load([base_dir '/ours.mat']);
ext = 'jpg';

addpath('myfunc');
name = dir([base_dir '/*.' ext]);
name = sort({name.name});
name={name{1} name{2}} ;

for k = 1:2
    [dummy,name{k}] = fileparts(name{k});
    I{k} = imread([base_dir '/' name{k} '.' ext]);
end
img1=I{1};
img2=I{2};
drawMatch(cmatch,lines1,lines2,img1,img2 ,1,1,2);