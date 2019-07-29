base_dir =  'Sec7.1/light';
lines= load([base_dir '/ljlmatch.txt']);
ext = 'jpg';


addpath('myfunc');
addpath('LSDlines');

% load data
name = dir([base_dir '/*.' ext]);
name = sort({name.name});
name={name{1} name{2}} ;



for k = 1:2
    [dummy,name{k}] = fileparts(name{k});
    I{k} = imread([base_dir '/' name{k} '.' ext]);
end

img1=I{1};
img2=I{2};
total=0;

ll=size(lines,1);
match=[1:ll];
cmatch=[match' match'];
lines1=lines(:,1:4);
lines2=lines(:,5:8);
drawMatch(cmatch,lines1,lines2,img1,img2 ,1,1,2);