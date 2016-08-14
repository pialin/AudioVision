function OutputResult = GetTrial(InputArg)
%Necessary InputArg Field:SegmentInfo EventType NumTrialSample
%OutputResult Field:Range Label

ValidNecessaryField(InputArg,'SegmentInfo','EventType','NumTrialSample');

NumSeg = numel(InputArg.SegmentInfo);

IndexMatchSeg = false(1,NumSeg);

for iSeg = 1:NumSeg 

    IndexMatchSeg(iSeg) = ~isempty(regexpi(InputArg.SegmentInfo(iSeg).Label,InputArg.EventType)) &&...
        (InputArg.SegmentInfo(iSeg).Range(2) - InputArg.SegmentInfo(iSeg).Range(1) + 1 == InputArg.NumTrialSample);

end

OutputResult = InputArg.SegmentInfo(IndexMatchSeg);



end