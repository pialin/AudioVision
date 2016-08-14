function ValidNecessaryField(Struct,varargin)
if all(isfield(Struct,varargin))
    %do nothing
else
    
    MissingField = varargin(~isfield(Struct,varargin));
    error(['Missing Necessary Field:',MissingField{1}]);
    
end


end