%���ű���cnt�ļ��е����ݽ��д���
%����Preference����
ReloadAvPref();
%��Preferenceͬ����AvPref.mat
SyncAvPref();
%%
%��������ռ�������д���
clear;
clc;

ProcessConfig;

%ʵ������ѡ��
FilterSpec = '.cnt';
DialogTitle = 'Choose cnt file to be processed';
if IsAvPref('LastCntChooseFolder')
    DefaultPath = GetAvPref('LastCntChooseFolder');
else
    DefaultPath = pwd;
end
[CntFileName,CntFolderPath,~] = uigetfile(FilterSpec,DialogTitle,DefaultPath);

if ~isequal(CntFolderPath,0)
    SetAvPref('LastCntChooseFolder',CntFolderPath);
    
    CntFilePath = fullfile(CntFolderPath,CntFileName);
else
    
    return;
end

InputArg = [];
InputArg.Path = CntFilePath;
InputArg.WhichLevel = -2;

OutputResult = GetFolder(InputArg);
ExpFolderName = OutputResult.FolderName;
ExpFolderPath = OutputResult.FolderPath;

%��ȡ��������
SubjectName = cell2mat(regexpi(ExpFolderName,'^[a-zA-Z]+','match'));
%��ȡʵ������
ExpDate = cell2mat(regexpi(ExpFolderName,'[0-9]+$','match'));

%��ȡ�Դ�
[~,ExpNum,~] = fileparts(CntFilePath);
%ExpNum = str2double(ExpNum);

%��ʾ��ǰ����������Ϣ
fprintf(['\n--------Processing ',SubjectName,'-',ExpDate,'-',ExpNum,'--------\n']);

%%
%��1��:���ݶ�ȡ�͸�ʽת��
fprintf('1.Read cnt file and transform it into raw data format of fieldtrip.');
DataRaw = Cnt2FtRaw(CntFilePath);
fprintf('\n');



%%
%��2��,����ѡ��
fprintf('2.Channel selection.\n');
ChannelLabel = GetAvPref('Channel','Label');
ChannelType = GetAvPref('Channel','Type');

NumChannel = numel(ChannelLabel);

IndexEegChannel = strcmpi('EEG',ChannelType);

NumEegChannel = nnz(IndexEegChannel);

SeqEegChannel = find(IndexEegChannel);

IndexMastoidChannel = strcmpi('Mastoid',ChannelType);

%��ȡδ�ɼ��ļ�����ĵ絼������
InputArg = [];
InputArg.ChannelLabel = ChannelLabel;
InputArg.ChannelType = ChannelType;
InputArg.MismatchType = {'EKG','EMG'};

OutputResult = GetMatchChannel(InputArg);

%��δ�ɼ��ĵ�����ΪNaN
DataRaw.trial{1}(~OutputResult.IndexMatchChannel,:) = NaN;

fprintf('Discarded Channel:');
DiscardedChannelLabel = ChannelLabel(~OutputResult.IndexMatchChannel);
for iChannel = 1:numel(DiscardedChannelLabel)
    fprintf([DiscardedChannelLabel{iChannel},' ']);
end

fprintf('\n');



%%
%Ԥ�����3�����زο�
%ȡ������EEG�����Լ���ͻ����������

fprintf('3.Rereference.\n');

DataReref = DataRaw.trial{1};

DataRaw.trial{1} = [];

if strcmpi('Mastoid',RereferenceChannel)
    %ÿ��Eegͨ������ȥ������ͻ�������ݵľ�ֵ
    DataReref(IndexEegChannel,:) = bsxfun(@minus,...
        DataReref(IndexEegChannel,:),...
        mean(DataReref(IndexMastoidChannel,:),1));
    %��������ͻ��������������
    DataReref(strcmpi('Mastoid',ChannelType),:) = 0;
elseif  strcmpi('CAR',RereferenceChannel)
    %ÿ��ͨ����ȥ����EEG������ƽ��
    DataReref(IndexEegChannel,:) = bsxfun(@minus,...
        DataReref(IndexEegChannel,:),...
        mean(DataReref(IndexEegChannel,:),1));
else
    error(['Unknown RereferenceChannel Option:',RereferenceChannel]);
end


%%
%��4�����˲�����ѡ��
fprintf('4.Filter(optional).\n')
SampleRate = GetAvPref('Data','SampleRate');

if strcmpi('Yes',FilterOrNot)
    %40Hz��ͨ�˲�
    %�˲������
    % Butterworth Lowpass filter designed using FDESIGN.LOWPASS.
    
    % All frequency values are in Hz.
    Fs = 1000;  % Sampling Frequency
    
    Fpass = 40;          % Passband Frequency
    Fstop = 60;          % Stopband Frequency
    Apass = 1;           % Passband Ripple (dB)
    Astop = 60;          % Stopband Attenuation (dB)
    match = 'passband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    FilterSpecification  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
    FilterStruct = design(FilterSpecification, 'butter', 'MatchExactly', match);
    
    DataFilter = zeros(size(DataReref));
    DataFilter(~IndexEegChannel,:)  = DataReref(~IndexEegChannel,:);
    DataFilter(IndexEegChannel,:)  = filtfilt(FilterStruct.sosMatrix,FilterStruct.ScaleValues,DataReref(IndexEegChannel,:)')';
    
    %50Hz�ݲ��˲�
    %�˲������
    % Butterworth Bandstop filter designed using FDESIGN.BANDSTOP.
    
    % All frequency values are in Hz.
    Fs = 1000;  % Sampling Frequency
    
    Fpass1 = 48;          % First Passband Frequency
    Fstop1 = 49;          % First Stopband Frequency
    Fstop2 = 51;          % Second Stopband Frequency
    Fpass2 = 52;          % Second Passband Frequency
    Apass1 = 0.5;         % First Passband Ripple (dB)
    Astop  = 60;          % Stopband Attenuation (dB)
    Apass2 = 1;           % Second Passband Ripple (dB)
    match  = 'stopband';  % Band to match exactly
    
    % Construct an FDESIGN object and call its BUTTER method.
    FilterSpecification  = fdesign.bandstop(Fpass1, Fstop1, Fstop2, Fpass2, Apass1, Astop, ...
        Apass2, Fs);
    FilterStruct = design(FilterSpecification, 'butter', 'MatchExactly', match);
    
    DataFilter(IndexEegChannel,:)  = filtfilt(FilterStruct.sosMatrix,FilterStruct.ScaleValues,DataFilter(IndexEegChannel,:)')';
elseif strcmpi('No',FilterOrNot)
    
    DataFilter = DataReref;
else
    
    error(['Unknown  ''FilterOrNOt'' option:',FilterOrNot,'!']);
    
end

clear DataReref;

%%
%��5��������Event�����ݷָ�����ݶΣ�ÿһ���������Ӧ
fprintf('5.Segment continuous data trial by trial according to event information.\n')

SegmentInfo = SegContinEeg(DataRaw.cfg.event,DataRaw.sampleinfo);

fprintf('We got %d segments.\n',numel(SegmentInfo));


%%
%��6����ѡ���ע��Trial����(Sound/Silence/Noise)
fprintf('6.Choose trial of interest.\n')

InputArg = [];

if ~strcmpi('Sound',TrialOfInterest) &&  ~strcmpi('Silence',TrialOfInterest) && ~strcmpi('Noise',TrialOfInterest)
    
    error(['Unknown  ''TrialOfInterest'' option:',TrialOfInterest,'!']);
    
end
InputArg.EventType = TrialOfInterest;


InputArg.NumTrialSample = round(GetAvPref('Time',InputArg.EventType)*GetAvPref('Data','SampleRate'));

InputArg.SegmentInfo = SegmentInfo;

SelectedTrialInfo = GetTrial(InputArg);

fprintf('We get %d %s trials.\n',numel(SelectedTrialInfo),InputArg.EventType);

clear SegmentInfo;


%%
%��7��:����ǰ���޳���α������λ���޳���α�����ŵ�trial
fprintf('7.Reject trials contaminated by artifact.\n');

ArtifactFolder = [ExpFolderPath,'Artifact',filesep];

Artifact = [];

if any(strcmpi('Blink',RejectArtifact))
    load([ArtifactFolder,'BlinkArtifact_',ExpNum,'.mat']);
    Artifact = [Artifact;BlinkArtifact];
end

if any(strcmpi('EyeMove',RejectArtifact))
    load([ArtifactFolder,'EyeMoveArtifact_',ExpNum,'.mat']);
    Artifact = [Artifact;EyeMoveArtifact];
end

if any(strcmpi('Other',RejectArtifact))
    load([ArtifactFolder,'OtherArtifact_',ExpNum,'.mat']);
    Artifact = [Artifact;OtherArtifact];
end
CleanTrialInfo = RemoveArtifactTrial(SelectedTrialInfo,Artifact);

NumTrial = numel(CleanTrialInfo);
fprintf('%d trials left.\n',NumTrial);

clear BlinkArtifact EyeMoveArtifact OtherArtifact Artifact;


clear SelectedTrialInfo;

%%
%Ԥ�����8��:�Էֶ����ݷֱ���ȥ���ߴ���(���ڶ���ʽ���)
fprintf('8.Baseline removement.\n');

if fix(BaselineOrder) ~= BaselineOrder ||  BaselineOrder < 0
    
    error('BaselineOrder should be a non-negetive integer.');
    
end

TrialRange = [1,CleanTrialInfo(1).Range(2)-CleanTrialInfo(1).Range(1)+1];
NumTrialSample = TrialRange(2) - TrialRange(1) + 1;
TrialTime = (TrialRange(1):TrialRange(2))/SampleRate;
DataDetrend = zeros(size(DataFilter,1),...
    TrialRange(2)-TrialRange(1)+1,...
    NumTrial);

DispProgress(0);

for iTrial = 1:NumTrial
    
    DataDetrend(:,:,iTrial) =  DataFilter(:,CleanTrialInfo(iTrial).Range(1):CleanTrialInfo(iTrial).Range(2));
    
    for iChannel = 1:numel(SeqEegChannel)
        
        [PolyCoef,ErrorSrtuct,mu] = polyfit(TrialTime,DataDetrend(SeqEegChannel(iChannel),:,iTrial),BaselineOrder);
        [EstimateBaseLine,~] = polyval(PolyCoef,TrialTime,ErrorSrtuct,mu);
        DataDetrend(SeqEegChannel(iChannel),:,iTrial) = DataDetrend(SeqEegChannel(iChannel),:,iTrial) - EstimateBaseLine;
        
        
        DispProgress(((iTrial-1)*numel(SeqEegChannel)+iChannel)...
            /(NumTrial*numel(SeqEegChannel)));
        
    end
    
end

clear DataFilter;


%%
%��9��������ת����Loreta��ʽ
fprintf('9.Transform data into loreta format(Optional).');

if strcmpi('Yes',SaveLoretaOrNot)
    
    InputArg = [];
    InputArg.FilePath = [ExpFolderPath,GetAvPref('FolderName','LoretaData'),filesep,'LoretaChannel.txt'];
    OutputResult = GetLoretaChannel(InputArg);
    IndexLoretaChannel = OutputResult.IndexLoretaChannel;
    
    InputArg = [];
    InputArg.TrialMat = DataDetrend(IndexLoretaChannel,:,:);
    InputArg.FilePath = [ExpFolderPath,GetAvPref('FolderName','LoretaData'),filesep,...
        TrialOfInterest,filesep,'Trial',TrialOfInterest,'_',ExpNum,'.asc'];
    
    fprintf('\n');
    TrialMat2Loreta(InputArg);
    
    InputArg = [];
elseif strcmpi('No',SaveLoretaOrNot)
    
else
    error(['Unknown  ''TransformOrNot'' option:',TransformOrNot,'!']);
end

load chirp
sound(y,Fs)

%%
%��10����Ƶ����
fprintf('10.Frequency Domain Process.');
if strcmpi('Yes',FreqAnalysis)
    %Ƶ����
    FftRange = TrialRange;
    
    NumFftPt = FftRange(2)-FftRange(1)+1;
    
    %�ֶ���������ͼ�׹���
    % AmpSpectrum = fft(DataTrial(IndexEegChannel,SoundRange(1):SoundRange(2),:),[],2);
    % AmpSpectrum = AmpSpectrum(1:NumFftPt/2+1);
    % AmpSpectrum = abs(AmpSpectrum/NumFftPt);
    % AmpSpectrum(2:end-1) = 2*AmpSpectrum(2:end-1);
    
    % PsdPeriod = NaN(NumChannel,FftRange(2)-FftRange(1)+1,NumTrial);
    % PsdPeriod(IndexEegChannel,:,:)  = fft(DataTrial(IndexEegChannel,FftRange(1):FftRange(2),:),[],2);
    % PsdPeriod = PsdPeriod (:,1:NumFftPt/2+1,:);
    % PsdPeriod = (1/(SampleRate*NumFftPt))*abs(PsdPeriod).^2;
    % PsdPeriod(:,2:end-1,:) = 2*PsdPeriod(:,2:end-1,:);
    
    %Freq = (0:NumFftPt/2)*SampleRate/NumFftPt;
    %�����ݻ��ɶ�ά����ʽ��������׹�������
    DataFft =  reshape(permute(DataDetrend(:,FftRange(1):FftRange(2),:),[2,1,3]),NumFftPt,NumChannel*NumTrial);
    
    
    % %����ͼ���׹���
    % [PsdPeriod,Freq] = periodogram(DataFft,rectwin(NumFftPt),NumFftPt,SampleRate);
    % PsdPeriod = permute(reshape(PsdPeriod,NumFftPt/2+1,NumChannel,NumTrial),[2,1,3]);
    % PsdPeriod = mean(PsdPeriod,3);
    %
    % PsdPeriodAlpha = mean(PsdPeriod(:,Freq>=8 & Freq<12),2);
    
    
    %     plot(Freq,10*log10(PsdPeriod(1,:,3)));
    
    %Multi Tapers Method �׹���
    NW = 4;
    [PsdMtm,Freq] = pmtm(DataFft,NW,NumFftPt,SampleRate);
    PsdMtm = permute(reshape(PsdMtm,NumFftPt/2+1,NumChannel,NumTrial),[2,1,3]);
    PsdMtm= mean(PsdMtm,3);
    %     plot(Freq,10*log10(PsdMtm(1,:,3)));
    
    IndexPsdChannel = IndexEegChannel;
    
    FreqDomainFolder = [ExpFolderPath,GetAvPref('FolderName','FreqDomainData'),filesep,TrialOfInterest,filesep];
    
    VsfInputArg = [];
    VsfInputArg.FilePath = [FreqDomainFolder,'Psd_',TrialOfInterest,'_temp.mat'];
    VsfInputArg.Interrupt = true;
    
    FilePath = ValidSaveFilePath(VsfInputArg);
    
    save(FilePath,'PsdMtm','Freq','IndexPsdChannel','NumTrial');
    
    if  exist([FreqDomainFolder,'Psd_',TrialOfInterest,'_',ExpNum,'.mat'],'file')
        OverrideOrNot = questdlg('Override Psd created before?','Waring','Yes','No','No') ;
        
        if strcmpi(OverrideOrNot,'Yes')
            movefile([FreqDomainFolder,'Psd_',TrialOfInterest,'_temp.mat'],...
                [FreqDomainFolder,'Psd_',TrialOfInterest,'_',ExpNum,'.mat']);
            fprintf('\n');
            disp(['Create ',FreqDomainFolder,'Psd_',TrialOfInterest,'_',ExpNum,'.mat']);
            fprintf('\b');
        end
    else
        movefile([FreqDomainFolder,'Psd_',TrialOfInterest,'_temp.mat'],...
            [FreqDomainFolder,'Psd_',TrialOfInterest,'_',ExpNum,'.mat']);
        fprintf('\n');
        disp(['Create ',FreqDomainFolder,'Psd_',TrialOfInterest,'_',ExpNum,'.mat']);
        fprintf('\b');
    end
    
    
    clear DataFft;
elseif strcmpi('No',FreqAnalysis);

else
    error(['Unknown  ''FreqAnalysis'' option:',FreqAnalysis,'!']);
end

fprintf('\n');
%%
%��11����С��ʱƵ����    
fprintf('11.Time-frequency process via wavelet.');
if strcmpi('Yes',TimeFreqAnalysis)

    WaveletName = 'morl';
    WaveletFreqCenter = centfrq(WaveletName);
    
    ScaleRange = WaveletFreqCenter*SampleRate./WaveletFreqRange;
    ScaleRange = sort(fix(ScaleRange));
    
    NumScale = ScaleRange(2)-ScaleRange(1)+1;
    
    CwtCoefSum = zeros(NumScale,NumTrialSample);
    CwtCoefTemp = zeros(NumScale,NumTrialSample);
    CwtCoefMean = zeros(NumChannel,NumScale,NumTrialSample);
    
    
    DispProgress(0);
    for iChannel = 1:NumEegChannel
        for iTrial = 1:NumTrial
            
            CwtCoefTemp =  cwt(DataDetrend(SeqEegChannel(iChannel),:,iTrial),ScaleRange(1):ScaleRange(2),WaveletName);
            CwtCoefSum = CwtCoefSum + CwtCoefTemp;
            
            DispProgress(((iChannel-1)*NumTrial+iTrial)/(NumTrial*NumEegChannel));
            
        end
        
        CwtCoefMean(SeqEegChannel(iChannel),:,:) = CwtCoefSum./NumEegChannel;
        
        
    end
    
    
    CwtFreq = scal2frq(ScaleRange(1):ScaleRange(2),'morl',1/SampleRate);
    
    TimeFreqFolder = [ExpFolderPath,'TimeFreq',filesep];
    
    IndexCwtChannel = IndexEegChannel;

    VsfInputArg = [];
    VsfInputArg.FilePath = [TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_temp.mat'];
    VsfInputArg.Interrupt = true;
    
    FilePath = ValidSaveFilePath(VsfInputArg);
    
    save(FilePath,'CwtCoefMean','CwtFreq','IndexCwtChannel')
    
    if  exist([TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_',ExpNum,'.mat'],'file')
        OverrideOrNot = questdlg('Override Cwtcoef created before?','Waring','Yes','No','No') ;
        
        if strcmpi(OverrideOrNot,'Yes')
            movefile([TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_temp.mat'],...
                [TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_',ExpNum,'.mat']);
  
            fprintf('\n');
            disp(['Create ',TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_',ExpNum,'.mat']);
            fprintf('\b');
        end
    else
        movefile([TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_temp.mat'],...
            [TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_',ExpNum,'.mat']);
        fprintf('\n');
        disp(['Create ',TimeFreqFolder,'CwtCoef_',TrialOfInterest,'_',ExpNum,'.mat']);
        fprintf('\b');
    end
    
    
elseif strcmpi('No',TimeFreqAnalysis)
    
else
    error(['Unknown  ''TimeFreqAnalysis'' option:',TimeFreqAnalysis,'!']);
    
end

fprintf('\n');

%%


% NFFT = 2^nextpow2(size(DataFilter,2)); % Next power of 2 from length of y
% Y = fft(DataFilter(1,:,1),NFFT)/size(DataFilter,2);
% f = SampleRate/2*linspace(0,1,NFFT/2+1);
% figure;
% % Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) ;
% title('Single-Sided Amplitude Spectrum');
% xlabel('Frequency (Hz)');
% ylabel('|Y(f)|');
%
% Y = fft(DataReref(1,:,1),NFFT)/size(DataFilter,2);
% f = SampleRate/2*linspace(0,1,NFFT/2+1);
%
% figure;
% % Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1)))
% title('Single-Sided Amplitude Spectrum')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')




% %ͨ���߽��һ��Ƶ��
% WPass = 40/(1/2*SampleRate);
% %����߽��һ��Ƶ��
% WStop = 60/(1/2*SampleRate);
% %ͨ�������Ʋ�����λ��dB��
% RPass = 1;
% %���˥���ٶȣ���λ��dB��
% RStop = 60;
% %��������Ҫ��İ�����˹�˲�������ͽ���NumOrder �ͽ�ֹ(-3dB)��һ��Ƶ��WCutoff
% [NumOrder,WCutoff] = buttord(WPass,WStop,RPass,RStop);
% %�����˲�����A��B����
% [FilterB,FilterA] = butter(NumOrder,WCutoff,'low');
%fvtool(FilterB,FilterA);


% %50Hz�ݲ��˲���
% %ͨ���߽��һ��Ƶ��
% WPass = [48/(1/2*SampleRate) ,  52/(1/2*SampleRate)];
% %����߽��һ��Ƶ��
% WStop = [49/(1/2*SampleRate) ,  51/(1/2*SampleRate)];
% %ͨ�������Ʋ�����λ��dB��
% RPass = 1;
% %���˥���ٶȣ���λ��dB��
% RStop = 60;
% %��������Ҫ��İ�����˹�˲�������ͽ���NumOrder �ͽ�ֹ(-3dB)��һ��Ƶ��WCutoff
% [NumOrder,WCutoff] = buttord(WPass,WStop,RPass,RStop);
% %�����˲�����A��B����
% [FilterB,FilterA] = butter(NumOrder,WCutoff,'stop');
%
% %fvtool(FilterB,FilterA);





%%

% TimePadding  = 1;%Trialǰ����������ݳ���(��λ:��)
%
% DataDetrend = zeros(NumChannel,TimeSound*SampleRate+2*TimePadding*SampleRate,size(CleanTrial,1));
% %Ԥ������岽:�����ݷֶβ��ֱ���ȥ���ߴ���(�������)
% for iTrial = 1:NumTrial
%     DataDetrend(:,:,iTrial) =  detrend(DataFilter(:,CleanTrial(iTrial,1)-TimePadding*SampleRate:CleanTrial(iTrial,2) + TimePadding*SampleRate)')';
% end





% % TrialDetrend(DataTrial);
% %
% % movefile('TrialBaselineOrderTemp.mat',...
% %     [ArtifactFolder,'TrialBaselineOrder',num2str(ExpNum),'.mat']);
% % % movefile('TrialFitDeltaTemp.mat',...
% % %     [ArtifactFolder,'TrialFitDelta',num2str(ExpNum),'.mat']);
% % load DataDetrendTemp.mat;
% % clear DataTrial;




for iChannel = 1:62
    TrialTime = (1:NumTrialPt)/SampleRate;
    CwtFreq = scal2frq(ScaleRange(1):ScaleRange(2),'morl',1/SampleRate);
    figure(iChannel);
    imagesc(TrialTime,CwtFreq,abs(CwtCoefMean(:,:,iChannel)));
    colormap jet;
end
