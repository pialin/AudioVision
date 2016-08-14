
%����Preference����
ReloadAvPref();
%��Preferenceͬ����AvPref.mat
SyncAvPref();

%%
clear;
clc;


CheckConfig;
%%
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
    fprintf('No cnt file has been selected and check script will be aborted!\n');
    return;
end
%%
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
fprintf(['\n--------Checking ',SubjectName,'-',ExpDate,'-',ExpNum,'--------\n']);

%%
%���ݶ�ȡ�͸�ʽת��
fprintf('Read cnt file and transform it into raw data format of fieldtrip.');
DataRaw = Cnt2FtRaw(CntFilePath);
fprintf('\n');


% �ֶ�ȥ�����۵�(գ��,ˮƽ�۶�)���߰�������α�������ݶ�

if strcmpi(BlinkCheck,'yes') ||  strcmpi(EyeMoveCheck,'yes')  || strcmpi(OtherArtifactCheck,'yes')
    cfg = [];

    %ÿ������չʾ���źų��ȣ����᷶Χ,��λ:�룩
    cfg.blocksize = 10;
    %���������ļ�Ϊδ�ָ���������ź�
    cfg.continuous = 'yes';
    
    %�Ƿ���ʾ������־
    cfg.plotlabels = 'yes';
    %�Ƿ���ʾ�¼����
    cfg.ploteventlabels = 'type=value';
    %�����ź���ʾģʽ
    cfg.viewmode = 'vertical';%�����ص��ֲ�
    
    cfg.selectmode = 'markartifact';
    
end

    ArtifactFolder = [ExpFolderPath,'Artifact',filesep];

%%
%ȥգ���۵�
if strcmpi(BlinkCheck,'Yes')
    fprintf('Select data segments contaminated by vertical(blink) EOG .\n')
    %�ֶ�ѡ����գ��Ӱ������ݶ�
    %��ʾ�ĵ���
    cfg.channel = {'FP1','FPz','FP2','AF3','AF4','F7','F5','F3','F1','Fz','F2','VEO'};
    DbOutputCfg = ft_databrowser(cfg,DataRaw);
    %����ĳ�ʼ��Χ��Ϊ�źŷ�ֵ����ֵ�����ֵ
    cfg.ylim = [-150 150];
    BlinkArtifact = DbOutputCfg.artfctdef.visual.artifact;

    save([ArtifactFolder,'BlinkArtifact_temp.mat'],'BlinkArtifact');
elseif strcmpi(BlinkCheck,'No')
else
    error(['Unknown ''BlinkCheck'' option:',BlinkCheck,'!']);
end
%%
%ȥˮƽ�۶��۵�
if  strcmpi(EyeMoveCheck,'Yes')
    fprintf('Select data segments contaminated by horizontal(Eyemove) EOG .\n')
    %�ֶ�ѡ����ˮƽ�۶�Ӱ������ݶ�
    %��ʾ�ĵ���
    cfg.channel = {'AF3','AF4','F7','F5','F3','F1','Fz','F2','F4','F6','F8','HEO'};
    DbOutputCfg = ft_databrowser(cfg,DataRaw);
    EyeMoveArtifact = DbOutputCfg.artfctdef.visual.artifact;
    %����ĳ�ʼ��Χ��Ϊ�źŷ�ֵ����ֵ�����ֵ
    cfg.ylim = [-150 150];
    save([ArtifactFolder,'EyeMoveArtifact_temp.mat'],'EyeMoveArtifact');
elseif strcmpi(EyeMoveCheck,'No')
else
    error(['Unknown ''EyeMoveCheck'' option:',EyeMoveCheck,'!']);
end

%%
%ȥ����α��
if strcmpi(OtherArtifactCheck,'Yes')
    fprintf('Select data segment contaminated by other artifacts.\n')
    cfg.channel = {'all','-EKG','-EMG'};
    %����ĳ�ʼ��Χ��Ϊ�źŷ�ֵ����ֵ�����ֵ
    cfg.ylim = [-30 30];
    DbOutputCfg = ft_databrowser(cfg,DataRaw);
    OtherArtifact = DbOutputCfg.artfctdef.visual.artifact;
    
    save([ArtifactFolder,'OtherArtifact_temp.mat'],'OtherArtifact');
elseif strcmpi(OtherArtifactCheck,'No')
else
    error(['Unknown ''OtherArtifactCheck'' option:',OtherArtifactCheck,'!']);
end



%%
%ȷ���ļ�����
OverrideOrNot = questdlg('Override artifact created before?','Waring','Yes','No','No') ;

if ~exist([ArtifactFolder,'BlinkArtifact_temp.mat'],'file') || ...
        (exist([ArtifactFolder,'BlinkArtifact_temp.mat'],'file') &&...
        exist([ArtifactFolder,'BlinkArtifact_',ExpNum,'.mat'],'file') &&...
        strcmpi(OverrideOrNot,'No'))
else
    movefile([ArtifactFolder,'BlinkArtifact_temp.mat'],[ArtifactFolder,'BlinkArtifact_',ExpNum,'.mat']);
    %     fprintf('\n');
    disp(['Create ',ArtifactFolder,'BlinkArtifact_',ExpNum,'.mat']);
    %     fprintf('\b');
end

if ~exist([ArtifactFolder,'EyeMoveArtifact_temp.mat'],'file') || ...
        (exist([ArtifactFolder,'EyeMoveArtifact_temp.mat'],'file') &&...
        exist([ArtifactFolder,'EyeMoveArtifact_',ExpNum,'.mat'],'file') &&...
        strcmpi(OverrideOrNot,'No'))
else
    movefile([ArtifactFolder,'EyeMoveArtifact_temp.mat'],[ArtifactFolder,'EyeMoveArtifact_',ExpNum,'.mat']);
    %     fprintf('\n');
    disp(['Create ',ArtifactFolder,'EyeMoveArtifact_',ExpNum,'.mat']);
    %     fprintf('\b');
end

if ~exist([ArtifactFolder,'OtherArtifact_temp.mat'],'file') || ...
        (exist([ArtifactFolder,'OtherArtifact_temp.mat'],'file') &&...
        exist([ArtifactFolder,'OtherArtifact_',ExpNum,'.mat'],'file') &&...
        strcmpi(OverrideOrNot,'No'))
else
    movefile([ArtifactFolder,'OtherArtifact_temp.mat'],[ArtifactFolder,'OtherArtifact_',ExpNum,'.mat']);
    %     fprintf('\n');
    disp(['Create ',ArtifactFolder,'OtherArtifact_',ExpNum,'.mat']);
    %     fprintf('\b');
end




%     %��ʾȫ����ѡ��α�����ݶ�
%     cfg.artfctdef.blink.artifact  = BlinkArtifact;
%     cfg.artfctdef.eyemove.artifact  = EyeMoveArtifact;
%      cfg.artfctdef.other.artifact  = OtherArtifact;
%     ft_databrowser(cfg,DataRaw);


% clear BlinkArtifact EyeMoveArtifact OtherArtifact;