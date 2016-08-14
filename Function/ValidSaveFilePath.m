function FilePath = ValidSaveFilePath(InputArg)

ValidNecessaryField(InputArg,'FilePath');


%对输入文件路径进行处理
[FolderPath,FileName,FileExtension] = fileparts(InputArg.FilePath);

if isempty(FolderPath) %如果仅指定文件名，默认在当前路径下的文件
    FolderPath = pwd;
    FilePath = fullfile(FolderPath,[FileName,FileExtension]);
    
elseif ~exist(FolderPath,'dir')
    mkdir(FolderPath);
end
if ~exist(InputArg.FilePath,'file') || (isfield(InputArg,'OverrideOrNot') && InputArg.OverrideOrNot == true)
    
    FilePath = InputArg.FilePath;
    
else
    error([InputArg.FilePath,' already exists!']);
    
end