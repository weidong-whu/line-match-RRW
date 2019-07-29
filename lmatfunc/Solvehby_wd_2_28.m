% u1 ... segment's end points in image 1
% u2 ... segment's end points in image 2
% u1, u2 are two *exactly corresponding* point pairs
function [H0,e2,l1,l2] = Solvehby_wd_2_28(u1,u2,P1,P2)
F = vgg_F_from_P(P1,P2);
e2 = P2*vgg_wedge(P1);

F(:) = normx(F(:));
e2 = normx(e2);

% Family of homographies consistent with P1,P2 is H(m) = H0 + e2*m, 1-by-3 vector m is the free parameter.
H0 = vgg_contreps(e2)*F;

% Find s such that it must be m*hom(u1) = s
% From s, 1-parameter family of m is m(t) = m0 + t*l1.
for n = 1:2
  a(:,n) = vgg_contreps([u2(:,n);1])*H0*[u1(:,n);1];
  b(:,n) = vgg_contreps([u2(:,n);1])*e2;
  s(n) = -b(:,n)\a(:,n);
end
m0 = s/hom(u1);
l1 = vgg_wedge([u1; 1 1]);
l2 = vgg_wedge([u2; 1 1]);
% Update H0 so that family of homographies consistent with P1,P2 and
% sending u1 to u2 is H(t) = H0 + t*e2*l1.
H0 = H0 + e2*m0;
% H0=cross(vgg_contreps(l1),F);
return
