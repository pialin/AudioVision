function output = GetFolder(input)
%Necessary input field:Path WhichLevel
%output field = FolderName FolderPath

ValidNecessaryField(input,'Path','WhichLevel');


FileSepIndex = strfind(input.Path,filesep);

if input.WhichLevel == fix(input.WhichLevel)
    %将层数转换成正整数
    if  input.WhichLevel < 0     
        if  FileSepIndex(end) == numel(input.Path)
            FileSepIndex = FileSepIndex(1:end-1);
        end
        
        input.WhichLevel = input.WhichLevel + numel(FileSepIndex) + 1;
        
        
        
    end
    
    if input.WhichLevel > 1 && numel(FileSepIndex)>= input.WhichLevel
        
        output.FolderName = input.Path(FileSepIndex(input.WhichLevel-1)+1:FileSepIndex(input.WhichLevel)-1);
        output.FolderPath = input.Path(1:FileSepIndex(input.WhichLevel));
        
    elseif input.WhichLevel == 1 && numel(FileSepIndex)>= input.WhichLevel
        
        output.FolderName = input.Path(1:FileSepIndex(input.WhichLevel)-1);
        output.FolderPath = input.Path(1:FileSepIndex(input.WhichLevel));
        
    else
        error('Improper argument ''WhichLevel''');
    end
else   
    error('Argument ''WhichLevel'' should be an integer!')
end

end