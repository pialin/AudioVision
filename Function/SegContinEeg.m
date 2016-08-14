function SegmentInfo = SegContinEeg(Event,SampleRange)

NumEvent = numel(Event);
EventSample = [Event.sample];
EventValue = [Event.value];
EventName = {Event.EventName};


LabelName = GetAvPref('EventType','Name');

LabelNumber = GetAvPref('EventType','Number');

NumPattern = GetAvPref('NumPattern');

LabelNumberFirstLabel= LabelNumber{strcmpi(LabelName,'Pattern1')};
LabelNumberLastLabel = LabelNumber{strcmpi(LabelName,['Pattern',num2str(NumPattern)])};

LabelNumberNoise = LabelNumber{strcmpi(LabelName,'Noise')};
LabelNumberExpEnd = LabelNumber{strcmpi(LabelName,'ExpEnd')};



TimeSound = GetAvPref('Time','Sound');
TimeNoise = GetAvPref('Time','Noise');
TimeSilence = GetAvPref('Time','Silence');


SampleRate = GetAvPref('Data','SampleRate');
NumSegEstimated = ceil((SampleRange(2)-SampleRange(1))/(mean(struct2array(GetAvPref('Time'))*SampleRate)));

SegmentInfo(1:NumSegEstimated) = struct('Range',NaN(1,2),'Label','');

iSeg = 1;


SegmentInfo(iSeg).Range = [1,EventSample(1)-1];
SegmentInfo(iSeg).Label = 'BeforeExp';

iSeg = iSeg + 1;



for iEvent = 1:NumEvent
    
    if EventValue(iEvent)>= LabelNumberFirstLabel && EventValue(iEvent)<= LabelNumberLastLabel
        
        if iEvent < NumEvent
            SoundSegStart = EventSample(iEvent):...
                round((TimeSound+TimeSilence)*SampleRate):...
                EventSample(iEvent+1)-1;
            
            
            
            SoundSegEnd = min(SoundSegStart + round(TimeSound*SampleRate) - 1,EventSample(iEvent+1)-1);
            
            SilenceSegStart = EventSample(iEvent)+ round(TimeSound*SampleRate):...
                round((TimeSound+TimeSilence)*SampleRate):...
                EventSample(iEvent+1)-1;
            
            SilenceSegEnd = min(SilenceSegStart + round(TimeSilence*SampleRate) - 1,EventSample(iEvent+1)-1);
            
            
        elseif iEvent == NumEvent
            
            SoundSegStart = EventSample(iEvent):...
                round((TimeSound+TimeSilence)*SampleRate):...
                SegRange(2);
            
            SoundSegEnd = min(SoundSegStart + round(TimeSound*SampleRate) - 1,SegRange(2));
            
            SilenceSegStart = EventSample(iEvent)+ round(TimeSound*SampleRate):...
                round((TimeSound+TimeSilence)*SampleRate):...
                SegRange(2);
            
            SilenceSegEnd = min(SilenceSegStart + round(TimeSilence*SampleRate) - 1,SegRange(2));
            
            
        end
        
        SoundRound = 1:numel(SoundSegStart);
        SilenceRound = 1:numel(SilenceSegStart);
        
        SoundLabel = arrayfun(@(x) ['Sound',num2str(EventValue(iEvent),'%02d'),'-',num2str(x,'%02d')],SoundRound, 'UniformOutput', false);
        SilenceLabel = arrayfun(@(x) ['Silence',num2str(EventValue(iEvent),'%02d'),'-',num2str(x,'%02d')],SilenceRound, 'UniformOutput', false);
        
        [SegStart,SortIndex] = sort([SoundSegStart,SilenceSegStart]);
        SegEnd = [SoundSegEnd,SilenceSegEnd];
        SegEnd = SegEnd(SortIndex);
        
        SegRange = num2cell([SegStart',SegEnd'],2);
        
        SegLabel = [SoundLabel,SilenceLabel];
        SegLabel = SegLabel(SortIndex);
        
        
        [SegmentInfo(iSeg:iSeg+numel(SegLabel)-1).Range] = SegRange{:};
        [SegmentInfo(iSeg:iSeg+numel(SegLabel)-1).Label] = SegLabel{:};
        
        iSeg = iSeg + numel(SegLabel);
        
    elseif EventValue(iEvent) == LabelNumberNoise
        SegmentInfo(iSeg).Range(1) = EventSample(iEvent);
        SegmentInfo(iSeg).Range(2) = min(EventSample(iEvent)+round(TimeNoise*SampleRate)-1,SampleRange(2));
        SegmentInfo(iSeg).Label = 'Noise';
        
        SegmentInfo(iSeg+1).Range(1) =  min(EventSample(iEvent)+round(TimeNoise*SampleRate),SampleRange(2));
        SegmentInfo(iSeg+1).Range(2) = min(EventSample(iEvent)+round((TimeNoise+TimeSilence)*SampleRate)-1,SampleRange(2));
        SegmentInfo(iSeg+1).Label = 'NoiseSilence';
        
        iSeg = iSeg + 2;
        
    elseif EventValue(iEvent) == LabelNumberExpEnd
        
        SegmentInfo(iSeg).Range(1:2) = EventSample(iEvent);
        
        SegmentInfo(iSeg).Label = 'ExpEnd';
        
        SegmentInfo(iSeg+1).Range(1) =  min(EventSample(iEvent)+1,SampleRange(2));
        SegmentInfo(iSeg+1).Range(2) = SampleRange(2);
        SegmentInfo(iSeg+1).Label = 'AfterExp';
        
        iSeg = iSeg + 2;
    else
        
        SegmentInfo(iSeg).Range(1:2) = EventSample(iEvent);
        
        SegmentInfo(iSeg).Label = EventName{iEvent};
        
        iSeg = iSeg + 1;
        
        
    end
    
    
    
end

SegmentInfo = SegmentInfo(1:max(1,iSeg-1));

end