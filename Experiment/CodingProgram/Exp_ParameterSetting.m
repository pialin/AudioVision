%ExpTrain��ExpFormal��������

%%
%��ʾ��������
%����ʹ�õ�����ɫ

red = [white,black,black];
green = [black,white,black];
blue = [black,black,white];
gray = white/2;

%����ʹ�С����
FontName = '΢���ź�';
FontSize = 40;

%ͼ����ʾ����Ĵ�С
SizeCanvas = round(SizeScreenY*3/5);

%ͼ����ʾԭ�������
OriginX = round((SizeScreenX - SizeCanvas)/2);
OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);


%ͼ���������
PenWidth = 20;

%%
%��Ƶ��������

%��Ƶ������
AudioSampleRate = 48000;
%��������
AudioVolume = 0.8;
% %����������
% PowerWhiteNoise = 2;

%��ʾ��Ƶ��
FreqHintSound = 800;


%%
%ʵ���������
%���ж��ٸ�Trial
NumTrial = 3;



%�Ѷ�����
DifficultySetting = 1:2;

PatternDifficulty(1,:) =  1: 8;
PatternDifficulty(2,:) =  9:16;
PatternDifficulty(3,:) = 17:24;

%�����Ѷ����ü���ѡ�õ�ͼ����ŷ�Χ
PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);


%��ͼ������
NumPattern = PatternRangeMax -PatternRangeMin +1;

% %%
% NumRun = 6;
% if abs(fix(NumRun*NumTrial/NumPattern)-NumRun*NumTrial/NumPattern) >1e-10
%     errordlg('NumRun*NumTrialӦ�ܱ�NumPattern������','�������ô���');
%     return;
% end
% 
% CurrentDirectory = pwd;
% 
% 
% 
% load LastDifficultyNumTrialNumRun;
% 
% if exist([CurrentDirectory,filesep,'MatrixPattern.mat'],'file')  ...
%         && isequal(NumTrial,NumTrialTemp)...
%         && isequal(NumRun,NumRunTemp)...
%         && isequal(DifficultySetting,DifficultySettingTemp)
%         
%     
%     load MatrixPattern.mat;
%     
%     
% else
%     
%     NumTrialTemp = NumTrial;
%     
%     NumRunTemp = NumRun ;
%     
%     DifficultySettingTemp = DifficultySetting;
%     
%     save LastDifficultyNumTrialNumRun NumTrialTemp NumRunTemp DifficultySettingTemp;
%     
%     %��ȡ��ǰMatlab�汾
%     MatlabRelease = version('-release');
%     
%     %�����������״̬����
%     if str2double(MatlabRelease(1:end-1))>=2011%MatlaΪR2011֮��汾
%         rng('shuffle');
%     else
%         rand('twister',mod(floor(now*8640000),2^31-1));%MatlabΪR2011֮ǰ�汾
%     end
%     
% 
%     
%     MatrixPattern = repmat(PatternRangeMin:PatternRangeMax,1,round(NumRun*NumTrial/NumPattern));
%     
%     MatrixPattern = reshape(Shuffle(MatrixPattern),NumRun,[]);
%     
%     NumUsedRow = 0;
%    
%     save MatrixPattern.mat MatrixPattern NumUsedRow;
% 
% end







%%

%ʱ���������
%��ʾ��ʱ��
TimeHintSound  = 6;
%������ʱ��
TimeWhiteNoise = 3;
%����ʱ��
TimeGapSilence = 3;


%����������ʱ��
TimeSum = 3;


%�����������
LptAddress = 53264;

%���ڱ�Ǻ���˵��
%1-200:��ʾÿ��trial�Ŀ�ʼ
%201-249:����
%250:��ʾ��ʼ���Ÿ�˹������
%251:��ʾʵ�鿪ʼ����ʾ����ʼ���ţ�
%252:����
%253:ʵ����ΪESC�������¶���ֹ
%254:��ʾʵ����������



