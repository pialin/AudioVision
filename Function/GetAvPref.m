function PrefValue = GetAvPref(varargin)

AvPref = getpref('AvPref');
PrefValue = AvPref;

if nargin == 0
    
elseif nargin >= 1 && iscellstr(varargin)
    Statement = cell(1,nargin+4);
    Statement{1} = 'PrefValue = { ';
    Statement{2} = 'AvPref';
    Statement{end-1} = ' }';
    Statement{end} = ';';
    for iArg = 1:nargin
        if isempty(regexp(varargin{iArg},'(\(|\)|\{|\})', 'once')) ||... %Ã»ÓÐÀ¨ºÅ
                xor(isscalar(regexp(varargin{iArg},'^[a-zA-Z_]+\([^\(\)\{\}]*\)$')),isscalar(regexp(varargin{iArg},'^[a-zA-Z_]+\{[^\(\)\{\}]*\}$')))%ÓÐÀ¨ºÅ
            Statement{iArg+2} = ['.',varargin{iArg}];
        else
            error(['Ilegal input argument ',num2str(iArg),' .']);
        end
    end
    
    eval(cell2mat(Statement));
    if numel(PrefValue) == 1
        PrefValue = cell2mat(PrefValue);
    else
        eval(['AvTemp=',cell2mat(Statement(2:end-3)),Statement{end}]);
        
        if isstruct(AvTemp)
            PrefValue = reshape(PrefValue,size(AvTemp));
        end
        
    end
end