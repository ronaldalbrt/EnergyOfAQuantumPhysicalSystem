clear

close all;
clc;
%Starting constants
n = 100;
l = 10;
s = 10;
w = 4;
Vo = -3;


h = l/n;

%Setting up the space to plot the graph
X = linspace(-l/2, l/2, n);

%Setting up the function
func = @(x) Vo./(exp(s*(abs(x) - w/2)) + 1);  
%func = @(x) (x.^2).*2;

%Setting up the matrix for aproximating the value of the second derivative
d2 = zeros(n,n);
d2(1,1)= -2;
d2(1,2) = 1;
d2(n,(n-1)) = 1;
d2(n,n) = -2;
for i = 2: n - 1
    d2(i, (i-1)) = 1;
    d2(i, i) = -2;
    d2(i, (i + 1)) = 1;
end

d2 = 1/h^2 * d2;
d2 = -1/2 * d2;

%Applying the equation
H = d2 + diag(func(X));
[V, E] = eig(H);

%Getting the lowest eigenvalue
[E, ind] = sort(diag(E));
V=V(:,ind);

lastValue = 99999999;
sigma = 0.00001;
count = 1;

% %Plot
% figure(1)
% plot(X, abs(V(:,1))/sqrt(h),'k');

% Minimizing the sigma
x0 = 3;
y0 = 4;

dx = 0.00001;
dy = 0.00001;
alpha = 0.01;

l = 1e-3;
g   = [inf; inf];
while norm(g) > l
    f1 = EnergyFunc(x0 - dx/2, y0, H, X);
    f2 = EnergyFunc(x0 + dx/2, y0, H, X);
    gx = (f2 - f1)/dx;
    
    f1 = EnergyFunc(x0, y0 - dy/2, H, X);
    f2 = EnergyFunc(x0, y0 + dy/2, H, X);
    gy = (f2 - f1)/dy;
    g = [gx;gy];
    
    x0 = x0 - alpha*gx;
    y0 = y0 - alpha*gy;
    
end
[x0 y0]
  
% Plotting the test function
EnergyTestMinimal = EnergyFunc(x0, y0, H, X);
TestFunk = @(x) exp(-x0.*x.^2 - y0.*x.^4);
psiTest = TestFunk(X);
normTestFunk = trapz(X, abs(psiTest).^2);
psiTest = psiTest/sqrt(normTestFunk); 
figure(1);
hold on;
plot(X, psiTest,'r');
hold off;
legend('From eig','Our test function');
 
hold on;
figure(2);
X2 = linspace(x0 - (x0./2), x0 + (x0./2), 10000);
Y2 = linspace(y0 - (y0./2), y0 + (y0./2), 10000);
F = EnergyFunc(X2, Y2, H, X);
surf(X2, Y2, F);
hold off;
% yline(E(1,1));
% hold off;
% axis([0 2 Vo 0])
% 
error =  (1 - (EnergyFunc(x0,y0,H,X)/E(1,1))) * 100