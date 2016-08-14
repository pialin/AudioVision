function FilePath = ValidLoadFilePath(FilePath)

%对输入文件路径进行处理
[FolderPath,FileName,FileExtension] = fileparts(FilePath);

if isempty(FolderPath) %如果仅指定文件名，默认在当前路径下的文件
    FolderPath = pwd;
    FilePath = fullfile(FolderPath,[FileName,FileExtension]);
    
end
if ~exist(FilePath,'file')

    error([FilePath,' doesn''t exists!'])
end