% ---------------------------------------------------------%
% Material Properties Used in Model -- AISI type H13       %
% thermal diffusivity,        alpha = 6.8 e-6                  %
% Thermal conductivity,       K = 24.4 W/(m*K)  @350C      %
% Specific heat capacity,     Cp = 460 J/(kg*K)            %
% Density,                    ? = 7800 kg/m^3               %
% Length,                     L = 0.003m                   %
% Position,                   x = 0.002m                   %
% ---------------------------------------------------------%
function pdepe
global rho cp k tend
rho=7800;   %kg/m^3 
cp=460;     %J/(kg*K)
k=24.4;     %W/(m*K)  @350C
L=0.003;     %m
tend=15;    %seconds

% load data and sign them into column vetors
load my_data_E300M4

T1 = f_E300M4;  %filterd T data from DLST test, used as template for comparision 
T00 = f_E300M4(1);
q = Qt_E300M4;

% PDEPE solver setup for computing temperature u based on Q(t)
m = 0;
x = linspace(0,L,30);
t = linspace(0,tend,151);
sol = pdepe(m,@pdex1pde,@pdex1ic,@pdex1bc,x,t);
T = sol(:,:,1);

function[c,f,s] = pdex1pde(x,t,u,DuDx)
global rho cp k
c = rho*cp;
f = k*DuDx;
s = 0;

function u0=pdexlic(x)
u0=T00

function[pl,ql,pr,qr] = pdex1bc(xl,ul,xr,ur,t)
pl = q;
ql = 1.0;
pr = 0;
qr = 1.0;


% surface plot for visual ideas
surf(x,t,T2) 
title('Computed Numerical Solution')
xlabel('Distance x')
ylabel('Time t')

% plot temperature curve over time at sensor point x=0.002m
figure
plot(t,T2(:,20),'r-')
title('Computed Temperature at 20th node point x = 0.002')
xlabel('Time [s]')
ylabel('T(x=0.002)')
hold on;
%plot measured temp. T1 from DLST test against computed T2 for visual check
plot(t,T1,'b*')
hold off;
