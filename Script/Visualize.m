
% %载入Preference配置
% ReloadAvPref();
% %将Preference同步到AvPref.mat
% SyncAvPref();

clear;

clc;




%数据选择
FilterSpec = '.mat';
DialogTitle = 'Choose mat file to be visualized';

if IsAvPref('LastMatChooseFolder')
    DefaultPath = GetAvPref('LastMatChooseFolder');
else
    DefaultPath = pwd;
end
[MatFileName,MatFolderPath,~] = uigetfile(FilterSpec,DialogTitle,DefaultPath,'MultiSelect','on');

if ~isequal(MatFolderPath,0)
    SetAvPref('LastMatChooseFolder',MatFolderPath);
    if ischar(MatFileName)
        
        MatFileName = {MatFileName};
        
    end
    
else
    
    return;
end

InputArg = [];
InputArg.Path = MatFolderPath;
InputArg.WhichLevel = -3;

OutputResult = GetFolder(InputArg);
ExpFolderName = OutputResult.FolderName;
ExpFolderPath = OutputResult.FolderPath;


InputArg = [];
InputArg.Path = MatFolderPath;
InputArg.WhichLevel = -2;

OutputResult = GetFolder(InputArg);
FreqDomainFolderName = OutputResult.FolderName;
FreqDomainPath = OutputResult.FolderPath;



%获取受试名称
SubjectName = cell2mat(regexpi(ExpFolderName,'^[a-zA-Z]+','match'));
%获取实验日期
ExpDate = cell2mat(regexpi(ExpFolderName,'[0-9]+$','match'));

NumMatFile = numel(MatFileName);

ExpNum = cell(1,NumMatFile);
%获取Trial类型
[~,FileName,~] = fileparts(MatFileName{1});
FileInfo = strsplit(FileName,'_');
DataType = FileInfo{1};
TrialType = FileInfo{2};
%获取试次
ExpNum{1} = FileInfo{3};

FreqRange = [3,48];

%%
if  strcmpi(DataType,'Psd')
    
    load(fullfile(MatFolderPath,MatFileName{1}));
    NumAllTrial =  NumTrial;
    PsdMtmAll = PsdMtm*NumTrial;

    for iMatFile = 2:NumMatFile
        
        load(fullfile(MatFolderPath,MatFileName{iMatFile}),'PsdMtm','NumTrial');
        PsdMtmAll = PsdMtmAll + PsdMtm*NumTrial;
        NumAllTrial =  NumAllTrial + NumTrial;
        [~,FileName,~] = fileparts(MatFileName{iMatFile});
        FileInfo = strsplit(FileName,'_');
        ExpNum{iMatFile} = FileInfo{3};
        
    end
    
    PsdMtmAll =  PsdMtmAll./NumAllTrial;
    
    eval(['PsdMtmAll_',TrialType,' =  PsdMtmAll./NumAllTrial;']);
    
    PsdAllPath = [FreqDomainPath,'Psd_',TrialType,'_all.mat'];
    
    eval(['save(PsdAllPath,''NumAllTrial'',''IndexPsdChannel'',''Freq'',''TrialType'',''PsdMtmAll_',...
        TrialType,''')']);
    
    PsdMtmAll(IndexPsdChannel,Freq>= 48 & Freq <=52) = NaN;
    
    InputArg = [];
    InputArg.Psd = PsdMtmAll;
    InputArg.Freq = Freq;
    InputArg.ChannelLabel = GetAvPref('Channel','Label');
    InputArg.IndexChannel = IndexPsdChannel;
    InputArg.FreqMin = FreqRange(1);
    InputArg.FreqMax = FreqRange(2);
    HandleFig = figure;
    Plot2dSpectrum(InputArg);
    HandleFig.Name =[SubjectName,ExpDate,TrialType,strjoin(ExpNum,' '),...
        ' ',num2str(FreqRange(1)),'-',num2str(FreqRange(2)),'Hz'];
    

end






