for st=[0.05,0.1,0.5,1,5,10]
clc
clearvars -except st
hold off
st
dfi=0;
dff=1;
Nd=21;
%delta_f_array=[0, 0.1, 0.2, 1, 2];
delta_f_array=linspace(dfi,dff,Nd);
peaks=zeros(Nd,1);
E=zeros(Nd,1);
err=zeros(Nd,1);
CF=zeros(Nd,1);
Nr=50;
E_f=zeros(Nd,Nr);
nexttile
for j=1:Nd
delta_f=delta_f_array(j)

for l=1:Nr
j
l
tic;
    
Fs = 250;

Ti = 0;
Tf = 110;

smd = 10;

SampleNumber = (Tf-Ti)*Fs;

tiw = 120+200*rand(4*SampleNumber+1,1);
%etas = 8+4*rand(4*SampleNumber+1,1)

% tiwi = randn(4*SampleNumber+1,1);         %Gaussian white noise
% tiw = 120+100*((tiwi+max(tiwi))/max(tiwi));

Tspan = linspace(Ti,Tf,4*SampleNumber);
%%%%%%%%%%%%%%%%%%%
C = 135;
dlta = 7;
eta = 10;

%%%%%%%%%%%%%%%%%%%
e0 = 2.5;     %Hz
v0 = 6;       %mV
r = 0.56;     %(mV)^-1
A = 3.25;     %mV
B = 22;       %mV
a = 100;      %Hz
b = 50;       %Hz
%st= 0.5;        %s 
%%%%%%%%%%%%%%%%%%%%

etas=[eta];
for i=1:(Tf-Ti)/st
    etas=[etas,eta+delta_f*randn*ones(4*Fs*st,1)'];
end
%%%%%%%%%%%%%%%%%%%%
zta = 1.2;
yi = rand(7,1);
yi(7,1) = 0;
k = 1E-6;
options=odeset('RelTol',k);
[t,y] = ode45(@(t,y) odejr(t,y,e0,v0,r,A,B,a,b,dlta,etas,zta,C,Fs,tiw), Tspan, yi, options);
%%%%%%%%%%%%%%%%%%%%
Fs = 1000;

discard = 10;
OutS = y(discard*Fs+1:end,2) - y(discard*Fs+1:end,3);
OutS = OutS-mean(OutS);
%OutS = bp(OutS,Fs);
Nsamps = length(OutS);
xdft1 = fft(OutS);
xdft1 = xdft1(1:floor(Nsamps/2)+1);
psdx1 = (1/(Fs*Nsamps)) * abs(xdft1).^2;
psdx1(2:end-1) = (2*psdx1(2:end-1));


freq = 0:Fs/Nsamps:Fs/2;

E_f(j,l)=sum(psdx1);  %Power in freq-domain
dt=(Tf-Ti)/length(Tspan);
E_x=sum(OutS.^2)*dt; %Power in time-domain
toc;
end

E(j)=mean(E_f(j,:));
err(j)=std(E_f(j,:));
psdxs=smooth(psdx1,smd);
psd_range=psdxs(freq>8 & freq<12);
peaks(j)=max(psdxs(freq>8 & freq<12));

halfMaxValue = peaks(j) / 2; % Find the half max value.
% Find indexes of power where the power first and last is above the half max value.
leftIndex = find(psd_range >= halfMaxValue, 1, 'first');
rightIndex = find(psd_range >= halfMaxValue, 1, 'last');
% Compute the delta time value by using those indexes in the time vector.
fwhm = (rightIndex - leftIndex)*(freq(2)-freq(1));
CF(j)=peaks(j)/fwhm;




%axes('Position', [0.05 0.13 0.42 0.35]);

% hold on;
% dname="\delta_f="+num2str(delta_f);
% %plot(freq',(smooth(psdx1,smd)),'LineWidth',1,'DisplayName',dname);
% plot(freq',psdxs,'LineWidth',1,'DisplayName',dname);
% set(gca,'FontSize',20)
% xlim([8 12]);
% xticks([8 9 10 11 12])
% % yticks([10E-5 10])
% % yticklabels({'10^-5','1'})
% ylabel('PSD (mV^2/Hz)', 'FontSize',20);
% xlabel('Freq(Hz)', 'FontSize',20);
% title("\zeta="+num2str(zta))
% 
% set(gca,'YScale','log','FontName','Times','LineWidth',1,'Fontsize',20,'fontweight','bold');
% lg=legend();
% 
% hold on;
% xline(5,'--','5 Hz','color',[0.6, 0.6, 0.6],'LineWidth',1,'Fontsize',15,'HandleVisibility','off');
% hold on
% xline(10,'--','10 Hz','color',[0.6, 0.6, 0.6],'LineWidth',1,...
%     'Fontsize',15,'LabelVerticalAlignment','bottom','HandleVisibility','off');
% hold on
% 
% 
% drawnow

end
x=delta_f_array;
y=E;
y_upper = y + err;
y_lower = y - err;

% Create Filled area
fill([x fliplr(x)], [y_upper' fliplr(y_lower')], [0.9 0.9 1], 'LineStyle', 'none');
 hold on;
% 
plot(x, y, 'k*', 'LineWidth', 1.5); % 'k-' specifies a black line
% errorbar(delta_f_array,E,err,'Linewidth',3);
title("\zeta="+num2str(zta))
xlabel('\delta_f','FontSize',20)
ylabel('Energy','FontSize',20)  

save("st"+num2str(st)+".mat")
savefig("st"+num2str(st)+".fig")
saveas(gcf,"st"+num2str(st)+".png")
hold off
end
% nexttile
% yyaxis left
% plot(delta_f_array,peaks,'-o','LineWidth',2)
% title("\zeta="+num2str(zta))
% xlabel('\delta_f','FontSize',20)
% ylabel('height','FontSize',20)
% yyaxis right
% plot(delta_f_array,E,'-o','LineWidth',2)
% ylabel('Energy', 'FontSize',20);
% xlabel('\delta_f', 'FontSize',20);

% 
% nexttile
% yyaxis left
% plot(delta_f_array,peaks,'-o','LineWidth',2)
% title("\zeta="+num2str(zta))
% xlabel('\delta_f','FontSize',20)
% ylabel('Height','FontSize',20)
% yyaxis right
% plot(delta_f_array,CF,'-o','LineWidth',2)
% ylabel('Q-value', 'FontSize',20);
% xlabel('\delta_f', 'FontSize',20);
% 
% nexttile
% hold on
% plot(delta_f_array,peaks/peaks(1),'-o','LineWidth',2)
% plot(delta_f_array,CF/CF(1),'-o','LineWidth',2)
% plot(delta_f_array,E/E(1),'-o','LineWidth',2)
% title("\zeta="+num2str(zta))
% legend(["height" "Q-value" "Energy"])
% xlabel('\delta_f','FontSize',20)
% 
