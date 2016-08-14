function ReloadAvPref()

    RootFolderPath = GetRootFolderPath();
    AvPrefPath = [RootFolderPath,'AvPref',filesep,'AvPref.mat'];
    
    load(AvPrefPath);
    
    AvPref.Path.MatlabPref = [prefdir(1) filesep 'matlabprefs.mat'];
    %Update Path
    AvPref.Path.Root = RootFolderPath;
    AvPref.Path.AvPref = AvPrefPath;
    AvPref.Path.Script = [RootFolderPath,AvPref.FolderName.Script,filesep];
    AvPref.Path.Data = [RootFolderPath,AvPref.FolderName.Data,filesep];
    AvPref.Path.Experiment = [RootFolderPath,AvPref.FolderName.Experiment,filesep];
    AvPref.Path.Figure = [RootFolderPath,AvPref.FolderName.Figure,filesep];
    AvPref.Path.Function = [RootFolderPath,AvPref.FolderName.Function,filesep];
    AvPref.Path.Note = [RootFolderPath,AvPref.FolderName.Note,filesep];
     
    AvPref.Path.Reference = [RootFolderPath,AvPref.FolderName.Reference,filesep];
    AvPref.Path.HeadTopoInfo = [RootFolderPath,'AvPref',filesep,'HeadTopoInfo.mat'];
    
%     %¶þ¼¶Ä¿Â¼
%     AvPref.Path.LoretaData = [AvPref.Path.Data,AvPref.FolderName.LoretaData,filesep];
%     AvPref.Path.FreqDomainData = [AvPref.Path.Data,AvPref.FolderName.FreqDomainData,filesep];
%     AvPref.Path.TimeFreqData = [AvPref.Path.Data,AvPref.FolderName.TimeFreqData,filesep];
    

    if ispref('AvPref')
        DelAvPref();
    end
    addpref('AvPref',fieldnames(AvPref),struct2cell(AvPref));

end