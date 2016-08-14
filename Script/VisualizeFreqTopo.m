%%
%数据选择
FilterSpec = '.mat';
DialogTitle = 'Choose mat file to be visualized';

if IsAvPref('LastMatChooseFolder')
    DefaultPath = GetAvPref('LastMatChooseFolder');
else
    DefaultPath = pwd;
end
[MatFileName,MatFolderPath,~] = uigetfile(FilterSpec,DialogTitle,DefaultPath,'MultiSelect','on');
NumMatFile = numel(MatFileName);
if iscell(MatFileName) && NumMatFile==3
    SetAvPref('LastMatChooseFolder',MatFolderPath);
    
else
    
    return;
end

InputArg = [];
InputArg.Path = MatFolderPath;
InputArg.WhichLevel = -1;

OutputResult = GetFolder(InputArg);
ExpFolderName = OutputResult.FolderName;
ExpFolderPath = OutputResult.FolderPath;


%获取受试名称
SubjectName = cell2mat(regexpi(ExpFolderName,'^[a-zA-Z]+','match'));
%获取实验日期
ExpDate = cell2mat(regexpi(ExpFolderName,'[0-9]+$','match'));

FlagTrialType = struct('Sound',false,'Silence',false,'Noise',false);

for iMatFile = 1:NumMatFile
    %获取Trial类型
    [~,FileName,~] = fileparts(MatFileName);
    FileInfo = strsplit(FileName,'_');
    DataType = FileInfo{1};
    TrialType = FileInfo{2};
    switch TrialType
        case {'Sound','sound'}
            FlagTrialType.Sound = true;
        case {'Silence','silence'}
            FlagTrialType.Silence = true;
        case {'Noise','noise'}
            FlagTrialType.Noise = true;
        otherwise
    end
end
if FlagTrialType.Sound && FlagTrialType.Silence && FlagTrialType.Noise
    
    
    % %获取试次
    % ExpNum = FileInfo{3};
    
    FreqRange = [3,48];
    
    load(fullfile(MatFolderPath,MatFileName{iMatfile}));
    
    
    for iFreq = FreqRange(1):FreqRange(2)
        
        FreqPlot = [iFreq-0.5,iFreq+0.5];
      
        figure;
        subplot(2,3,1);
        InputArg = [];
        InputArg.ChannelValue = mean(PsdMtmAll_Silence(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2);
        InputArg.IndexChannel = IndexPsdChannel;
        PlotHeadTopo(InputArg);
        title([SubjectName,ExpDate,'Silence',ExpNum,...
            ' ',num2str(FreqPlot(1)),'-',num2str(FreqPlot(2)),'Hz']);
        
        subplot(2,3,2);
        InputArg = [];
        InputArg.ChannelValue = mean(PsdMtmAll_Sound(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2);
        InputArg.IndexChannel = IndexPsdChannel;
        PlotHeadTopo(InputArg);
        title([SubjectName,ExpDate,'Sound',ExpNum,...
            ' ',num2str(FreqPlot(1)),'-',num2str(FreqPlot(2)),'Hz']);
        
        
        subplot(2,3,3);
        InputArg = [];
        InputArg.ChannelValue = mean(PsdMtmAll_Noise(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2);
        InputArg.IndexChannel = IndexPsdChannel;
        PlotHeadTopo(InputArg);
        title([SubjectName,ExpDate,'Noise',ExpNum,...
            ' ',num2str(FreqPlot(1)),'-',num2str(FreqPlot(2)),'Hz']);
        
        
        subplot(2,3,4);
        InputArg = [];
        InputArg.ChannelValue = mean(PsdMtmAll_Sound(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2) - ...
             mean(PsdMtmAll_Silence(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2);
        InputArg.IndexChannel = IndexPsdChannel;
        PlotHeadTopo(InputArg);
        title([SubjectName,ExpDate,'Sound-Silence',ExpNum,...
            ' ',num2str(FreqPlot(1)),'-',num2str(FreqPlot(2)),'Hz']);
        
        subplot(2,3,6);
        InputArg = [];
        InputArg.ChannelValue = mean(PsdMtmAll_Sound(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2) - ...
             mean(PsdMtmAll_Noise(:,Freq>=FreqPlot(1) & Freq<FreqPlot(2)),2);
        InputArg.IndexChannel = IndexPsdChannel;
        PlotHeadTopo(InputArg);
        title([SubjectName,ExpDate,'Sound-Noise',ExpNum,...
            ' ',num2str(FreqPlot(1)),'-',num2str(FreqPlot(2)),'Hz']);
        
        
        
        save(gcf,[MatFolderPath,'TopoCompare_',num2str(iFreq),'Hz']);
        
    end
    
end