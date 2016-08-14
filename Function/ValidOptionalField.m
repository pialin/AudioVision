function output = ValidOptionalField(Struct,varargin)
if mod(numel(varargin),2)==0
    output = Struct;
    for iArg = 1:2:numel(varargin)
        
        if isfield(Struct,varargin{iArg})
            
            output.(varargin{iArg})= Struct.(varargin{iArg});
        elseif ~isempty(varargin{iArg+1})
            
            output.(varargin{iArg})= varargin{iArg+1};
        end
        
    end
    
    
else
    error('Illegal Field Name-Value Pairs!')
end


end