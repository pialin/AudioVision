function FilePath = ValidLoadFilePath(FilePath)

%�������ļ�·�����д���
[FolderPath,FileName,FileExtension] = fileparts(FilePath);

if isempty(FolderPath) %�����ָ���ļ�����Ĭ���ڵ�ǰ·���µ��ļ�
    FolderPath = pwd;
    FilePath = fullfile(FolderPath,[FileName,FileExtension]);
    
end
if ~exist(FilePath,'file')

    error([FilePath,' doesn''t exists!'])
end