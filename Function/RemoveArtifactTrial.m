function output = RemoveArtifactTrial(TrialInfo,varargin)

if nargin < 2
    
    error('No enough input arguments!')
    
end

MinSample = min([TrialInfo.Range]);
MaxSample = max([TrialInfo.Range]);

SampleFlag = true(1,MaxSample-MinSample+1);

TrialFlag = false(1,numel(TrialInfo));

for iArtifact = 1:nargin-1
    
    if ismatrix(varargin{iArtifact}) && size(varargin{iArtifact},1)  ==2  && size(varargin{iArtifact},2)  ~=2
        artifact =  fix(varargin{iArtifact})';
    elseif ismatrix(varargin{iArtifact}) && size(varargin{iArtifact},2)  ==2
        artifact =  fix(varargin{iArtifact});
    else
        error('Illegal input argument of artifact !');
    end
    
    for iRow = 1:size(artifact,1)
        if artifact(iRow,1)<MinSample || artifact(iRow,2)> MaxSample
            % do nothing
        else
            SampleFlag(max(MinSample,artifact(iRow,1)):min(artifact(iRow,2),MaxSample)) = false;
        end
    end
    
end

for iTrial = 1:numel(TrialInfo)
    if SampleFlag(TrialInfo(iTrial).Range(1)-MinSample+1:TrialInfo(iTrial).Range(2)-MinSample+1)
        TrialFlag(iTrial) = true;
    end
end

output = TrialInfo(TrialFlag);

end