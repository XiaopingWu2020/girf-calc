function plotGIRFs(girfs, myaxis, fnroot)
%plotGIRFs plot all terms and save figures
%   Usage: plotGIRFs(girfs, myaxis, fnroot)
%
% Input:
%
% girfs: a struct having two fields: Hw (GIRF measurements) and freqs
% (corresponding frequencies in Hz).
%
% myaxis: a cell defining the axis to be used for plotting 0th order, 1st order self, 1st order cross, 2nd order and 3rd order terms. 
% x axis is in kHz.
%
% fnroot: a filename root to be used at the beginning of each filename. For
% example, fnroot= 'hg-' means that the filename will be 'hg-girfs-*'.
% defaults to '', meaning that the plots will be saved in a file named with "girfs-*".
%
%
% see also: calcGIRFs plotFieldMeas plotFieldMeas2
%
%
% Created by Xiaoping Wu, 3/20/2023

if nargin< 3
    fnroot= '';
end
% b0 
myaxis0= myaxis{1};
figure('name','GIRF: b0'), plot(1e-3.*girfs.freqs, abs(girfs.Hw(:,:,1)))
axis(myaxis0)
title('GIRF: zeroth order term')
xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
legend('x -> b_0','y -> b_0','z -> b_0')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
%export_fig([fnroot,'girfs-b0'],'-png')

% 1st order self terms
figure('name','GIRF: 1st order self terms');
%f.Position(3)= f.Position(4)*16/7;
myaxis1_self= myaxis{2};
plot(1e-3*girfs.freqs, [abs(girfs.Hw(:,1,2)) abs(girfs.Hw(:,2,3)) abs(girfs.Hw(:,3,4))])
title('GIRF: first order self terms')
xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> x','y -> y','z -> z')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis1_self)
%export_fig([fnroot,'girfs-1stOrderSelf'],'-png')

% 1st order cross terms
f= figure('name','GIRF: 1st order cross terms');
f.Position(3)= f.Position(4)*16/7;

myaxis1= myaxis{3};
subplot(311), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,2:3,2)))
title('GIRF: first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('y -> x','z -> x')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis1)

subplot(312), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,[1 3],3)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> y','z -> y')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis1)

subplot(313), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,[1 2],4)))
%title('first order cross terms')
xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> z','y -> z')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis1)
%export_fig([fnroot,'girfs-1stOrderCross'],'-png')

%% second order terms
f= figure('name','2nd order terms');
f.Position(3)= f.Position(4)*16/7; f.Position(4)= 1.5.* f.Position(4);

myaxis2= myaxis{4};
idx0= 5;
subplot(511), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
title('GIRF: second order terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> xy','y -> xy','z -> xy')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis2)

idx0= idx0+ 1;
subplot(512), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> yz','y -> yz','z -> yz')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis2)

idx0= idx0+ 1;
subplot(513), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> 2z^2 - (x^2 + y^2)','y -> 2z^2 - (x^2 + y^2)','z -> 2z^2 - (x^2 + y^2)')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis2)

idx0= idx0+ 1;
subplot(514), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> xz','y -> xz','z -> xz')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis2)

idx0= idx0+ 1;
subplot(515), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> x^2 - y^2','y -> x^2 - y^2','z -> x^2 - y^2')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis2)
%export_fig([fnroot,'girfs-2ndOrder'],'-png')

%% third order terms
f= figure('name','GIRF: 3rd order terms');
f.Position(3)= f.Position(4)*16/7; f.Position(4)= 1.5.* f.Position(4) *7/5;

myaxis3= myaxis{5};
idx0= 10;
subplot(711), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
title('GIRF: third order terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> 3x^2y - y^3','y -> 3x^2y - y^3','z -> 3x^2y - y^3')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

idx0= idx0+ 1;
subplot(712), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> xyz','y -> xyz','z -> xyz')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

idx0= idx0+ 1;
subplot(713), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> 4yz^2 - y(x^2 + y^2)','y -> 4yz^2 - y(x^2 + y^2)','z -> 4yz^2 - y(x^2 + y^2)')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

idx0= idx0+ 1;
subplot(714), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> 2z^3 - 3z(x^2 + y^2)','y -> 2z^3 - 3z(x^2 + y^2)','z -> 2z^3 - 3z(x^2 + y^2)')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

idx0= idx0+ 1;
subplot(715), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> 4xz^2 - x(x^2 + y^2)','y -> 4xz^2 - x(x^2 + y^2)','z -> 4xz^2 - x(x^2 + y^2)')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

idx0= idx0+ 1;
subplot(716), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
%xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> x^2z - y^2z','y -> x^2z - y^2z','z -> x^2z - y^2z')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

idx0= idx0+ 1;
subplot(717), plot(1e-3*girfs.freqs, abs(girfs.Hw(:,:,idx0)))
%title('first order cross terms')
xlabel('frequency (kHz)')
ylabel('magnitude (a.u.)')
%legend('GIRF','GIRF no ECC','GIRF ref')
legend('x -> x^3 - 3xy^2','y -> x^3 - 3xy^2','z -> x^3 - 3xy^2')
%legend('X \rightarrow X','Y \rightarrow Y','Z \rightarrow Z')
axis(myaxis3)

%export_fig([fnroot,'girfs-3rdOrder'],'-png')

end