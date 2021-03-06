% upwelling_offshore_ts_comparison.m
% Kylene Cooley
% 28 Apr 2021
% Compares events and peak rates of warming from three separate time
% series: The original "yellow dot" time series near Punta Lavapie
% upwelling center at the highest SST' in the event from the proposal; The
% spatial average from the 1deg sq box 0.5 degrees west of the yellow
% point, which is representative of the upwelling zone; The spatial average
% from a 1deg sq box in the middle of the offshore region of high SST' that
% appears during most "yellow dot" events. 

load("sstSwA.mat")

% get indices for lat and lon of either point or center of box
ptLat = [-35.5,-36,-29];        % deg N of dot or center of box
ptLon = [-72.75,-73.75,-77.75]; % deg E of dot or center of box
ind = NaN(2,3);
ind(1,:) = find(ismembertol(lat,ptLat));
ind(2,:) = find(ismembertol(lon,ptLon));
[x1,x2,x3] = matsplit(flip(ind(2,:)));          % not sstSwA dim order is lon,lat,time
[y1,y2,y3] = matsplit(circshift(ind(1,:),2));

% time series at yellow dot
ts1 = squeeze(sstSwA(x1,y1,:));

% time series at green box
ts2 = squeeze(mean(sstSwA(x2-2:x2+2,y2-2:y2+2,:),[1 2],'omitnan'));

% time series at offshore box
ts3 = squeeze(mean(sstSwA(x3-2:x3+2,y3-2:y3+2,:),[1 2],'omitnan'));

% remove swath data from workspace to save RAM
clear sstSwA

% take 1st difference approx to time derivative
dts1 = (ts1(2:end)-ts1(1:end-1))*4;         % multiply by 4 for degC/day
dts2 = (ts2(2:end)-ts2(1:end-1))*4; 
dts3 = (ts3(2:end)-ts3(1:end-1))*4; 

% ID events
[sumSST1,sumDates1,sumdSST1,sumdDates1] = SSTevents(time1,ts1,dts1);
[sumSST2,sumDates2,sumdSST2,sumdDates2] = SSTevents(time1,ts2,dts2);
[sumSST3,sumDates3,sumdSST3,sumdDates3] = SSTevents(time1,ts3,dts3);

% plot 3 time series of each variable in same figure with 3 different line
% styles
figure(1)

yyaxis left                 % SST' time series
plot(time1,ts1,'-',sumDates1,sumSST1,'*','MarkerSize',12,'LineWidth',1)
hold on
plot(time1,ts2,'--',sumDates2,sumSST2,'*','MarkerSize',12,'LineWidth',1)
plot(time1,ts3,'-.',sumDates3,sumSST3,'*','MarkerSize',12,'LineWidth',1)
yline(0,'-k')
xlabel('Date')
datetick('x','yyyy-mmm','keeplimits','keepticks')
ylabel("SST' [^{\circ}C]",'Interpreter','tex')
title("10-day to 6-month bandpass filtered SST' and $\frac{\partial \textsf{SST'}}{\partial \textsf{t}}$",'Interpreter','latex')

yyaxis right                % dSST'/dt time series
plot(time1(1:end-1),dts1,"-",sumdDates1,sumdSST1,'*','MarkerSize',12,'LineWidth',1)
hold on
plot(time1(1:end-1),dts2,"--",sumdDates2,sumdSST2,'*','MarkerSize',12,'LineWidth',1)
plot(time1(1:end-1),dts3,"-.",sumdDates3,sumdSST3,'*','MarkerSize',12,'LineWidth',1)
yline(0,'-k')
ylabel("$\frac{\partial \textsf{SST'}}{\partial \textsf{t}} \textsf{[}^{\circ}\textsf{C/day]}$",'Interpreter','latex')
datetick('x','yyyy-mmm','keeplimits','keepticks')

%% Plotting each location on a separate subplot
figure(2)

ax1 = subplot(3,1,1);
yyaxis left                 % SST' time series
plot(time1,ts1,'-',sumDates1,sumSST1,'*','MarkerSize',12,'LineWidth',1)
hold on
yline(0,'-k')
ylabel("SST' [^{\circ}C]",'Interpreter','tex')
yyaxis right                % dSST'/dt time series
plot(time1(1:end-1),dts1,"-",sumdDates1,sumdSST1,'*','MarkerSize',12,'LineWidth',1)
hold on
yline(0,'-k')
ylabel("$\frac{\partial \textsf{SST'}}{\partial \textsf{t}} \textsf{[}^{\circ}\textsf{C/day]}$",'Interpreter','latex')
datetick('x','yyyy-mmm','keeplimits','keepticks')
title("Nearshore point (N_{events}=31)")

ax2 = subplot(3,1,2);
yyaxis left                 % SST' time series
plot(time1,ts2,'--',sumDates2,sumSST2,'*','MarkerSize',12,'LineWidth',1)
hold on
yline(0,'-k')
ylabel("SST' [^{\circ}C]",'Interpreter','tex')
yyaxis right                % dSST'/dt time series
plot(time1(1:end-1),dts2,"--",sumdDates2,sumdSST2,'*','MarkerSize',12,'LineWidth',1)
hold on
yline(0,'-k')
ylabel("$\frac{\partial \textsf{SST'}}{\partial \textsf{t}} \textsf{[}^{\circ}\textsf{C/day]}$",'Interpreter','latex')
datetick('x','yyyy-mmm','keeplimits','keepticks')
title("Spatial mean within nearshore box (N_{events}=36)")

ax3 = subplot(3,1,3);
yyaxis left                 % SST' time series
plot(time1,ts3,'-.',sumDates3,sumSST3,'*','MarkerSize',12,'LineWidth',1)
hold on
yline(0,'-k')
xlabel('Date')
datetick('x','yyyy-mmm','keeplimits','keepticks')
ylabel("SST' [^{\circ}C]",'Interpreter','tex')
yyaxis right                % dSST'/dt time series
plot(time1(1:end-1),dts3,"-.",sumdDates3,sumdSST3,'*','MarkerSize',12,'LineWidth',1)
hold on
yline(0,'-k')
ylabel("$\frac{\partial \textsf{SST'}}{\partial \textsf{t}} \textsf{[}^{\circ}\textsf{C/day]}$",'Interpreter','latex')
datetick('x','yyyy-mmm','keeplimits','keepticks')
title("Spatial mean within offshore box (N_{events}=41)")

sgtitle("10-day to 6-month bandpass filtered SST' and $\frac{\partial \textsf{SST'}}{\partial \textsf{t}}$",'Interpreter','latex')
linkaxes([ax1 ax2 ax3],'x')