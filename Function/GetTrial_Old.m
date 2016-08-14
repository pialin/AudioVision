function Trial = GetTrial_Old(Event,SampleRange,StartEventName,SegRange,TrialRange, EndEventName)

if all(fix(SampleRange) == SampleRange) && all(SampleRange>0) && numel(SampleRange)==2
    
    StartSample = SampleRange(1);
    EndSample = SampleRange(2);
    
else
    error('Illegal input argument ''SampleRange'' ');
end

if all(fix(SegRange) == SegRange) && all(SegRange>=0) && numel(SegRange)==3
    
    SegOnset = SegRange(1);
    SegLength = SegRange(2);
    SegOffset = SegRange(3);
    
    
else
    error('Illegal input argument ''SegRange'' ');
end

if all(fix(TrialRange) == TrialRange) && all(TrialRange>=0) && numel(TrialRange)==2
    
    TrialOnset= TrialRange(1);
    TrialOffset= TrialRange(2);
    TrialLength = TrialOffset - TrialOnset + 1;
    
else
    error('Illegal input argument ''TrialRange'' ');
end



if isfield(Event,{'sample','value','EventName'})
    NumEvent = numel(Event);
    EventSample = [Event.sample];
    EventValue = [Event.value];
    EventName = {Event.EventName};
    
else
    
    error('Input argument ''Event'' should contains field ''sample'',''value'' and ''EventName''');
    
end



IndexStartEvent = false(1,NumEvent);

if iscellstr(StartEventName)
    for iName = 1:numel(StartEventName)
        
        IndexStartEvent = IndexStartEvent | strcmpi(StartEventName,EventName);
        
    end
    
elseif ischar(StartEventName) && size(StartEventName,1) == 1
    IndexStartEvent = strcmpi(StartEventName,EventName);
else
    error('Illegal input argument ''StartEventName''(should be a charactor string or charactor string cell)');
end

IndexStartEvent = find(IndexStartEvent);

IndexEndEvent = false(1,NumEvent);

if iscellstr(EndEventName)
    for iName = 1:numel(EndEventName)
        
        IndexEndEvent  = IndexEndEvent  | strcmpi(EndEventName{iName},EventName);
        
    end
    
elseif ischar(EndEventName) && size(EndEventName,1) == 1
    IndexEndEvent  = strcmpi(EndEventName,EventName);
elseif isempty(EndEventName)
    IndexEndEvent = [];
else
    error('Illegal input argument ''EndEventName''(should be a charactor string or charactor string cell)');
end

if isempty(IndexEndEvent)
    IndexEndEvent = IndexStartEvent + 1;
else
    IndexEndEvent = find(IndexEndEvent);
end

if isinf(TrialLength)
    MaxNumTrial = numel(IndexStartEvent);
else
    MaxNumTrial = ceil((EndSample-StartSample)/TrialLength);
end
Trial  = zeros(MaxNumTrial,3);
TrialCursor = 1;
if numel(IndexStartEvent) == numel(IndexEndEvent)
    
    for iEvent = 1:numel(IndexStartEvent)
        
        EventStartSample = EventSample(IndexStartEvent(iEvent));
        
        if IndexEndEvent(iEvent) <=NumEvent
            EventEndSample = EventSample(IndexEndEvent(iEvent));
        else
            EventEndSample = EndSample;
        end
        
        if ~isinf(SegOnset) && ~isinf(SegLength)
            
            SegStart =  (EventStartSample + SegOnset ) :SegLength : min(EventStartSample + SegOffset,EventEndSample);

            SegStart = SegStart';

            SegEnd = min(SegStart + SegLength -1,EventEndSample);
            
            
        elseif ~isinf(SegOnset) && isinf(SegLength)
            
            SegStart =  EventStartSample + SegOnset;
            SegEnd = min(EventStartSample + SegOffset,EventEndSample) ;
            
            
        else
            error('Illeagal argument : ''SegRange''');
        end
        
        if ~isinf(TrialOnset)
            
            
            if SegStart(end) + TrialOffset >= SegEnd(end)
                if numel(SegStart) > 1
                    SegStart = SegStart(1:end-1);
                else

                    continue;
                end
 
            end
            
            TrialStart = SegStart + TrialOnset;
            TrialEnd = SegStart + TrialOffset;
            
        else
            error('Illeagal argument : ''TrialRange''');
            
        end
        
        Trial(TrialCursor:TrialCursor+numel(TrialStart)-1,1) = TrialStart;
        Trial(TrialCursor:TrialCursor+numel(TrialStart)-1,2) = TrialEnd;
        
        [~,SortedIndex] = sort([TrialStart(1),EventSample,TrialEnd(end)]);
        TrialEventRange = EventValue(find(SortedIndex==1):find(SortedIndex==(NumEvent+2))-2);
        IndexPattern = find(TrialEventRange>=1 & TrialEventRange<=24);
        if isscalar(IndexPattern)
            Trial(TrialCursor:TrialCursor+numel(TrialStart)-1,3) = TrialEventRange(IndexPattern);
        else
            error('No or more than one event value were found for this trial ');
        end
        
        TrialCursor = TrialCursor + numel(TrialStart);
    end
    if TrialCursor >= 2
        Trial = Trial(1:TrialCursor-1,:);
    else
        Trial = [];
    end
else
    error('The numbers of start and end events don''t match.')
end

end