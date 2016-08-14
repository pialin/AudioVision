function FilePath = ValidSaveFilePath(InputArg)

ValidNecessaryField(InputArg,'FilePath');


%�������ļ�·�����д���
[FolderPath,FileName,FileExtension] = fileparts(InputArg.FilePath);

if isempty(FolderPath) %�����ָ���ļ�����Ĭ���ڵ�ǰ·���µ��ļ�
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