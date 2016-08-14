function OutputResult = GetMatchChannel(InputArg)
%Necessary input Field:ChannelLabel
%Optional input Field:MatchLabel MismatchLabel ChannelType MatchType
%                     MismatchType
%output Field:IndexMatchChannel LabelMatchChannel
if isfield(InputArg,'ChannelLabel')
    
    if (isfield(InputArg,'MatchLabel') || isfield(InputArg,'MatchType'))...
            && ~isfield(InputArg,'MismatchLabel') &&   ~isfield(InputArg,'MismatchType')
        
        OutputResult.IndexMatchChannel = false(size(InputArg.ChannelLabel));
        
        
        if isfield(InputArg,'MatchLabel')
            if ischar(InputArg.MatchLabel)
                
                IndexMatchLabel = ~cellfun(@isempty,regexpi(InputArg.ChannelLabel,InputArg.MatchLabel));
                OutputResult.IndexMatchChannel(IndexMatchLabel) = true;
            elseif  iscell(InputArg.MatchLabel)
                
                for iLabel = 1:numel(InputArg.MatchLabel)
                    
                    IndexMatchLabel = ~cellfun(@isempty,regexpi(InputArg.ChannelLabel,InputArg.MatchLabel{iLabel}));
                    OutputResult.IndexMatchChannel(IndexMatchLabel) = true;
                    
                end
                
            else
                error('Ilegal input argument ''MatchLabel''');
                
            end
        end
        if  isfield(InputArg,{'ChannelType','MatchType'})
            
            if ischar(InputArg.MatchType)
                
                IndexMatchType = ~cellfun(@isempty,regexpi(InputArg.ChannelType,InputArg.MatchType));
                OutputResult.IndexMatchChannel(IndexMatchType) = true;
                
            elseif  iscell(InputArg.MatchType)
                
                for iType = 1:numel(InputArg.MatchType)
                    
                    IndexMatchType = ~cellfun(@isempty,regexpi(InputArg.ChannelType,InputArg.MatchType{iType}));
                    OutputResult.IndexMatchChannel(IndexMatchType) = true;
                    
                end
                
            else
                error('Ilegal input argument ''MatchType''');
                
            end
            
        else
            error('Ilegal input argument ''MatchType''');
        end
        
        
    elseif (isfield(InputArg,'MismatchLabel') || isfield(InputArg,'MismatchType'))...
            && ~isfield(InputArg,'MatchLabel') &&   ~isfield(InputArg,'MatchType')
        
        OutputResult.IndexMatchChannel = true(size(InputArg.ChannelLabel));
        
        if isfield(InputArg,'MismatchLabel')
            if ischar(InputArg.MismatchLabel)
                
                IndexMismatchLabel = ~cellfun(@isempty,regexpi(InputArg.ChannelLabel,InputArg.MismatchLabel));
                OutputResult.IndexMatchChannel(IndexMismatchLabel) = false;
                
            elseif  iscell(InputArg.MismatchLabel)
                
                for iLabel = 1:numel(InputArg.MismatchLabel)
                    
                    IndexMismatchLabel = ~cellfun(@isempty,regexpi(InputArg.ChannelLabel,InputArg.MismatchLabel{iLabel}));
                    OutputResult.IndexMatchChannel(IndexMismatchLabel) = false;
                    
                end
                
            else
                error('Ilegal input argument ''MismatchLabel''');
                
            end
        end
        if isfield(InputArg,{'ChannelType','MismatchType'})
            
            
            if ischar(InputArg.MismatchType)
                
                IndexMismatchType = ~cellfun(@isempty,regexpi(InputArg.ChannelType,InputArg.MismatchType));
                OutputResult.IndexMatchChannel(IndexMismatchType) = false;
                
            elseif  iscell(InputArg.MismatchType)
                
                for iType = 1:numel(InputArg.MismatchType)
                    
                    IndexMismatchType = ~cellfun(@isempty,regexpi(InputArg.ChannelType,InputArg.MismatchType{iType}));
                    OutputResult.IndexMatchChannel(IndexMismatchType) = false;
                    
                end
                
            else
                error('Ilegal input argument ''MismatchType''');
                
            end
        else
            
            error('Both ''MismatchType'' and ''ChannelType'' should be given.')
            
        end
        
    else
        error('Can''t handle ''Match*'' and ''Mismatch*'' at the same time.')
    end
    
    if nnz(OutputResult.IndexMatchChannel) == 0
    
        warning('No channel has been selected!');
    
    end
    OutputResult.LabelMatchChannel = InputArg.ChannelLabel(OutputResult.IndexMatchChannel);
else
    error('Missing necessary input ''ChannelLabel''');
end


end