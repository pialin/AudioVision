function OutputResult = GetLoretaChannel(InputArg)
%Necessary Input Field:
%Optional InputArg Field:FilePath ChannelLabel MatchLabel MismatchLabel
%                     ChannelType MatchType MismatchType
%output Field:IndexMatchChannel LabelMatchChannel


GmcInput = ValidOptionalField(InputArg,'ChannelLabel',GetAvPref('Channel','Label'),...
    'MatchLabel',[],...
    'MismatchLabel','CB[12]',...
    'ChannelType',GetAvPref('Channel','Type'),...
    'MatchType',[],...
    'MismatchType',{'EOG','EKG','EMG','Mastoid'});




GmcOutput = GetMatchChannel(GmcInput);

OutputResult.IndexLoretaChannel = GmcOutput.IndexMatchChannel;
OutputResult.LabelLoretaChannel = GmcOutput.LabelMatchChannel;

if isfield(InputArg,'FilePath')
    
    
    VsfInputArg.FilePath = InputArg.FilePath;
    VsfInputArg.OverrideOrNot = true;
    ValidedFilePath = ValidSaveFilePath(VsfInputArg);
    
    FileId = fopen(ValidedFilePath,'w');
    for iChannel = 1:numel(OutputResult.LabelLoretaChannel)
        if iChannel ~= numel(OutputResult.LabelLoretaChannel)
            fprintf(FileId, '%s\n',OutputResult.LabelLoretaChannel{iChannel});
        else
            fprintf(FileId, '%s',OutputResult.LabelLoretaChannel{iChannel});
        end
    end
    fclose(FileId);
end
end