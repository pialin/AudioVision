function TrialMat2Loreta(InputArg)
%Necessary input Field:FilePath TrialMat(1d:Channel,2d:Sample,3d:Trial)
%Optional input Field:ChannelLabel MatchLabel MismatchLabel
%                     ChannelType MatchType MismatchType
%output Field:IndexMatchChannel LabelMatchChannel
ValidNecessaryField(InputArg,'FilePath','TrialMat');


[FolderPath,FileName,FileExtension] = fileparts(InputArg.FilePath);



DispProgress(0);
for iTrial = 1:size(InputArg.TrialMat,3)

    FilePath = fullfile(FolderPath,[FileName,'_',num2str(iTrial),FileExtension]);
    
    VsfInputArg.FilePath = FilePath;
    VsfInputArg.OverrideOrNot = true;
    ValidedFilePath = ValidSaveFilePath(VsfInputArg);
   
    
    dlmwrite(ValidedFilePath,squeeze(InputArg.TrialMat(:,:,iTrial))','delimiter','\t','precision','%+6.5e');
    
    DispProgress(iTrial/size(InputArg.TrialMat,3));
    
end
end