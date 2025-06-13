function plotFieldMeas2(bfield,t_vec,fnroot,mylegend)
%plotFieldMeas2 compare conditions by plotting each of all terms and save figures
%
%   Usage: plotFieldMeas2(bfield,t_vec,fnroot,mylegend)
%
% Input:
%
% bfield: field measurement in mT, samples x orders x conditions.
% 
% t_vec: a time vector in ms
%
% fnroot: a root name to be used at the beginning of the filenames.
% defaults to '';
%
% mylegend: a cell containing legend
%
%
% see also: calcGIRFs plotFieldMeas plotGIRFs plotGIRFs2
%
%
% Created by Xiaoping Wu, 3/22/2023

if nargin< 3
    fnroot= '';
end
if nargin< 4
    mylegend= '';
end

% b0 
%myaxis0= myaxis{1};
figure('name','FM: b0'), plot(t_vec, squeeze(bfield(:,1,:)))
%axis(myaxis0)
title('b_0')
xlabel('ms')
ylabel('mag (mT)')
legend(mylegend)
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
%export_fig([fnroot,'-b0'],'-png')

% 1st order terms
f= figure('name','FM: 1st order terms');
f.Position(3)= f.Position(4)*16/7;

subplot(311), plot(t_vec, squeeze(bfield(:,2,:)))
title('x')
%xlabel('ms')
ylabel('mag (mT/m)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend(mylegend)
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
%axis(myaxis1)

subplot(312), plot(t_vec, squeeze(bfield(:,3,:)))
title('y')
%xlabel('ms')
ylabel('mag (mT/m)')
%legend('GIRF','GIRF no ECC','GIRF ref')
%legend('measured','predicted')

subplot(313), plot(t_vec, squeeze(bfield(:,4,:)))
title('z')
xlabel('ms')
ylabel('mag (mT/m)')
%legend('GIRF','GIRF no ECC','GIRF ref')
%legend('measured','predicted')

%export_fig([fnroot,'-1stOrder'],'-png')

%% second order terms
f= figure('name','FM: 2nd order terms');
f.Position(3)= f.Position(4)*16/7; f.Position(4)= 1.5.* f.Position(4);

idx0= 5;
subplot(511), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('xy')
%xlabel('ms')
ylabel('mag (mT/m^2)')
legend(mylegend)
%axis(myaxis2)

idx0= idx0+ 1;
subplot(512), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('yz')
%xlabel('ms')
ylabel('mag (mT/m^2)')
%legend('measured','predicted')
%axis(myaxis2)

idx0= idx0+ 1;
subplot(513), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('2z^2 - (x^2 + y^2)')
%xlabel('ms')
ylabel('mag (mT/m^2)')
%legend('measured','predicted')
%axis(myaxis2)

idx0= idx0+ 1;
subplot(514), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('xz')
%xlabel('ms')
ylabel('mag (mT/m^2)')
%legend('measured','predicted')
%axis(myaxis2)

idx0= idx0+ 1;
subplot(515), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('x^2 - y^2')
%xlabel('ms')
ylabel('mag (mT/m^2)')
%legend('measured','predicted')
%axis(myaxis2)

%export_fig([fnroot,'-2ndOrder'],'-png')

%% third order terms
f= figure('name','FM: 3rd order terms');
f.Position(3)= f.Position(4)*16/7; f.Position(4)= 1.5.* f.Position(4) *7/5;

idx0= 10;
subplot(711), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('3x^2y - y^3')
%xlabel('ms')
ylabel('mag (mT/m^3)')
legend(mylegend)

idx0= idx0+ 1;
subplot(712), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('xyz')
%xlabel('ms')
ylabel('mag (mT/m^3)')
%legend('measured','predicted')

idx0= idx0+ 1;
subplot(713), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('4yz^2 - y(x^2 + y^2)')
%xlabel('ms')
ylabel('mag (mT/m^3)')
%legend('measured','predicted')

idx0= idx0+ 1;
subplot(714), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('2z^3 - 3z(x^2 + y^2)')
%xlabel('ms')
ylabel('mag (mT/m^3)')
%legend('measured','predicted')

idx0= idx0+ 1;
subplot(715), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('4xz^2 - x(x^2 + y^2)')
%xlabel('ms')
ylabel('mag (mT/m^3)')
%legend('measured','predicted')

idx0= idx0+ 1;
subplot(716), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('x^2z - y^2z')
%xlabel('ms')
ylabel('mag (mT/m^3)')
%legend('measured','predicted')

idx0= idx0+ 1;
subplot(717), plot(t_vec, squeeze(bfield(:,idx0,:)))
title('x^3 - 3xy^2')
xlabel('ms')
ylabel('mag (mT/m^3)')
%legend('measured','predicted')

%export_fig([fnroot,'-3rdOrder'],'-png')

end