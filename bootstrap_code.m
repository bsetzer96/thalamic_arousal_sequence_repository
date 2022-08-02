load('7T_arousal_traces.mat')

%index of whole thalamus
whole_thal_ind=find(strcmp(rois_hdr, 'wholeThalamus')==1);

%index of thalamic nuclei
thal_nuc_ind=31:39;

%number of nuclei
num_nuc=length(thal_nuc_ind);

%time step (has been interpolated to 4x original.
dt=t(2)-t(1);

%define timeseries
thal_nuc = all_arousals(:,thal_nuc_ind,:);
whole_thal=all_arousals(:,whole_thal_ind,:);

%list of thalamic nuclei
thal_hdr = rois_hdr(thal_nuc_ind); 

%% cross-correlation for means

%average timeseries
avg_nuc=mean(thal_nuc,3);
avg_thal=mean(whole_thal,3);

%preallocate
lag_mean=zeros(num_nuc,1);
range=50; %range to shift accross for cross cor

%loop through each roi and calculate cross correlation with thalamus
for c=1:num_nuc %for each ROI
    %cross-correlation  
    [xc, lags] = xcorr(avg_nuc(:,c), avg_thal,range,'coeff');
    [m,in]= max(abs(xc)); %extracting max correlation 
    lag_mean(c)= lags(in)*dt; %defining lag of max cor
end

%% bootstrap for confidance intervals

%number of arousals
n=size(all_arousals,3); 

%preallocate space
Cor=zeros(num_nuc,1000);
Lcor=zeros(num_nuc,1000);

% i = # of bootstraps
for i = 1:1000
    %preallocate
    boot_rois_nuc=[];
    boot_rois_thal=[];

    %resample from arousals
    bind=ceil(rand(n,1)*n); %k long vector of random sample from 1-k

    %thalamic nuclei bootstrap mean
    all_boot_nuc=thal_nuc(:,:,bind); %extracting matrix of ROIs from bind arousals
    avg_boot_nuc= mean(all_boot_nuc,3); %averaging accross bootstrapped arousals
    cent_boot_nuc=avg_boot_nuc-mean(avg_boot_nuc(1:50,:)); %centering to first 3 sec

    %thalamic bootstrapped mean
    all_boot_thal=whole_thal(:,:,bind);
    avg_boot_thal=mean(all_boot_thal,3);
    cent_boot_thal=avg_boot_thal-mean(avg_boot_thal(1:50,:)); %centering to first 3 sec

    %cross correlation for each region
    for c=1:num_nuc %for each ROI
        [xc, lags] = xcorr(cent_boot_nuc(:,c), cent_boot_thal ,range,'coeff');
        [m,in]= max(abs(xc)); %extracting max correlation 
        Lcor(c,i)= lags(in)*dt; %defining lag of max cor
        Cor(c,i)= xc(in);
    end
end
%%

bnds=prctile(Lcor, [2.5, 97.5], 2);
lowerb=bnds(:,1);
upperb=bnds(:,2);

[a,b]=sort(lag_mean); %sort lag so that negative lags are first
figure()
for i=1:num_nuc
    rectangle('Position', [lowerb(b(i)), i-0.4, upperb(b(i))-lowerb(b(i)),  0.8]); hold on
    plot([lag_mean(b(i)),lag_mean(b(i))], [i-0.4, i+0.4])
end

plot([0,0], [0,10])
xlim([-2, 2])
set(gca, 'YTick', 1:30, 'YTickLabel', thal_hdr(b))
title('Arousal-locked cortical activity sequence')
ylabel('Thalamic nuclei')
xlabel('Time (s)')






