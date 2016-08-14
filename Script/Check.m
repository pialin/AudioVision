
%载入Preference配置
ReloadAvPref();
%将Preference同步到AvPref.mat
SyncAvPref();

%%
clear;
clc;


CheckConfig;
%%
%实验数据选择
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

%获取受试名称
SubjectName = cell2mat(regexpi(ExpFolderName,'^[a-zA-Z]+','match'));
%获取实验日期
ExpDate = cell2mat(regexpi(ExpFolderName,'[0-9]+$','match'));

%获取试次
[~,ExpNum,~] = fileparts(CntFilePath);
%ExpNum = str2double(ExpNum);

%显示当前处理数据信息
fprintf(['\n--------Checking ',SubjectName,'-',ExpDate,'-',ExpNum,'--------\n']);

%%
%数据读取和格式转换
fprintf('Read cnt file and transform it into raw data format of fieldtrip.');
DataRaw = Cnt2FtRaw(CntFilePath);
fprintf('\n');


% 手动去除带眼电(眨眼,水平眼动)或者包含其他伪迹的数据段

if strcmpi(BlinkCheck,'yes') ||  strcmpi(EyeMoveCheck,'yes')  || strcmpi(OtherArtifactCheck,'yes')
    cfg = [];

    %每个窗口展示的信号长度（横轴范围,单位:秒）
    cfg.blocksize = 10;
    %输入数据文件为未分割过的连续信号
    cfg.continuous = 'yes';
    
    %是否显示导联标志
    cfg.plotlabels = 'yes';
    %是否显示事件标记
    cfg.ploteventlabels = 'type=value';
    %设置信号显示模式
    cfg.viewmode = 'vertical';%纵向不重叠分布
    
    cfg.selectmode = 'markartifact';
    
end

    ArtifactFolder = [ExpFolderPath,'Artifact',filesep];

%%
%去眨眼眼电
if strcmpi(BlinkCheck,'Yes')
    fprintf('Select data segments contaminated by vertical(blink) EOG .\n')
    %手动选中受眨眼影响的数据段
    %显示的导联
    cfg.channel = {'FP1','FPz','FP2','AF3','AF4','F7','F5','F3','F1','Fz','F2','VEO'};
    DbOutputCfg = ft_databrowser(cfg,DataRaw);
    %纵轴的初始范围设为信号幅值绝对值的最大值
    cfg.ylim = [-150 150];
    BlinkArtifact = DbOutputCfg.artfctdef.visual.artifact;

    save([ArtifactFolder,'BlinkArtifact_temp.mat'],'BlinkArtifact');
elseif strcmpi(BlinkCheck,'No')
else
    error(['Unknown ''BlinkCheck'' option:',BlinkCheck,'!']);
end
%%
%去水平眼动眼电
if  strcmpi(EyeMoveCheck,'Yes')
    fprintf('Select data segments contaminated by horizontal(Eyemove) EOG .\n')
    %手动选中受水平眼动影响的数据段
    %显示的导联
    cfg.channel = {'AF3','AF4','F7','F5','F3','F1','Fz','F2','F4','F6','F8','HEO'};
    DbOutputCfg = ft_databrowser(cfg,DataRaw);
    EyeMoveArtifact = DbOutputCfg.artfctdef.visual.artifact;
    %纵轴的初始范围设为信号幅值绝对值的最大值
    cfg.ylim = [-150 150];
    save([ArtifactFolder,'EyeMoveArtifact_temp.mat'],'EyeMoveArtifact');
elseif strcmpi(EyeMoveCheck,'No')
else
    error(['Unknown ''EyeMoveCheck'' option:',EyeMoveCheck,'!']);
end

%%
%去其他伪迹
if strcmpi(OtherArtifactCheck,'Yes')
    fprintf('Select data segment contaminated by other artifacts.\n')
    cfg.channel = {'all','-EKG','-EMG'};
    %纵轴的初始范围设为信号幅值绝对值的最大值
    cfg.ylim = [-30 30];
    DbOutputCfg = ft_databrowser(cfg,DataRaw);
    OtherArtifact = DbOutputCfg.artfctdef.visual.artifact;
    
    save([ArtifactFolder,'OtherArtifact_temp.mat'],'OtherArtifact');
elseif strcmpi(OtherArtifactCheck,'No')
else
    error(['Unknown ''OtherArtifactCheck'' option:',OtherArtifactCheck,'!']);
end



%%
%确认文件覆盖
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




%     %显示全部已选中伪迹数据段
%     cfg.artfctdef.blink.artifact  = BlinkArtifact;
%     cfg.artfctdef.eyemove.artifact  = EyeMoveArtifact;
%      cfg.artfctdef.other.artifact  = OtherArtifact;
%     ft_databrowser(cfg,DataRaw);


% clear BlinkArtifact EyeMoveArtifact OtherArtifact;