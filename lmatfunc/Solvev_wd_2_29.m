% u1 ... segment's end points in image 1
% u2 ... segment's end points in image 2
% u1, u2 are two *exactly corresponding* point pairs
%inspired by Li kai
function [H,H1,error] = Solvev_wd_2_29(u11,u12,u21,u22,F,e2)


% Family of homographies consistent with P1,P2 is H(m) = H0 + e2*m, 1-by-3 vector m is the free parameter.
A = vgg_contreps(e2)*F;

l12 = vgg_wedge([u12; 1 1]);
l22 = vgg_wedge([u22; 1 1]);
l12=l12';
l22=l22';
x1=[u11(:,1);1];
x2=[u11(:,2);1];
x3=[u21(:,1);1];
x4=[u21(:,2);1];
K=[x1';x2';x3';x4'];
y= [x1'*A'*l12/(e2'*l12);
    x2'*A'*l12/(e2'*l12);
    x3'*A'*l22/(e2'*l22);
    x4'*A'*l22/(e2'*l22)];
v=K\y;
H= A -e2*v';
v1=K(1:3,:)\y(1:3);
H1= A -e2*v1';
error=v1'*x4-y(4);
return
