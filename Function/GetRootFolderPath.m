function  RootFolderPath = GetRootFolderPath()
CurrentDirectory = pwd;
RootFileSep = strfind(CurrentDirectory,[filesep,'AudioVision'])+numel('AudioVision')+1;
if numel(RootFileSep) >= 1
    if numel(RootFileSep) == 1
        RootFolderPath = CurrentDirectory(1:RootFileSep);
    else
        warning('More than 1 possible ''Root Path'' was found and the toppest one would be taken!');
        RootFolderPath = CurrentDirectory(1:RootFileSep(1));
    end
elseif numel(RootFileSep) == 0
    error('Can''t find Root Path');
    
end
end