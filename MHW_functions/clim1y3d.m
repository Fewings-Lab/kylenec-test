% clim1y3d.m 
% Kylene Cooley
% 17 Mar 2021
% Calculate the climatological annual cycle for a 3d data cube and apply a
% low-pass filter to smooth with cutoff period Tc in hours.

function dat0 = clim1y3d(dat, dn, dt, Tc)
    % Make a climatological annual cycle for each lat, lon pair
    dv = datevec(dn); % Convert to datevec
    yd = dn - datenum(dv(:,1),1,1) + 1; % Convert to yearday
    % Vector to use for matching times to 6-hourly data
    yhr = 1:(24/dt):(367-(24/dt));
    % Vector to store climatology
    dat0 = NaN(size(dat));

    % loop by yearday w/ time
    for i=1:366*(24/dt)
       times = ismembertol(yd,yhr(i)); % Logical of times in the 42-yr record that match the yearday and time
       mu = mean(dat(:,:,times),3,'omitnan'); % take the mean along time dimension
       k = find(times); % Indices of the nonzero points in times
       for j = 1:length(k) % Loop through these times
           dat0(:,:,k(j)) = mu; % Assign 2D mean array to the time slice
       end
    end 

    % Low-pass filter climatological annual cycle
    for l=1:length(dat(:,1,1)) % loop along first spatial dimension since pl66 can only filter 2D arrays,
        % we can use either as long as time is the longer dimension
        dat0(l,:,:) = (pl66tn(squeeze(dat0(l,:,:)),dt,Tc))'; % apply filter and assign to 2D first-dimension slice
    end

end