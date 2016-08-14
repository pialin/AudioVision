function RawData = Cnt2FtRaw(CntPath)
    
    header = ft_read_header(CntPath,'dataformat','ns_cnt');
    RawData.fsample = header.Fs;
    RawData.label = header.label;
    RawData.time = {(1:header.nSamples)/header.Fs};
    RawData.trial ={double(header.orig.data)};
    RawData.sampleinfo = [1,header.nSamples];


    EventType = GetAvPref('EventType');
    
    for ievent = 1:numel(header.orig.event)
        RawData.cfg.event(ievent).type = 'trigger';
        RawData.cfg.event(ievent).sample =  header.orig.event(ievent).offset;
        RawData.cfg.event(ievent).value =  header.orig.event(ievent).stimtype;
%         RawData.cfg.event(ievent).offset = 0;
%         RawData.cfg.event(ievent).duration = 0;
        RawData.cfg.event(ievent).EventName = EventType([EventType.Number] == RawData.cfg.event(ievent).value).Name;
        
    end
    
   
    RawData = ft_datatype_raw(RawData);

end