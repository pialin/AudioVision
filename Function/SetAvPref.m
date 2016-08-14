function  SetAvPref(varargin)


% %将Preference同步到AvPref.mat
% SyncAvPref();

MatlabPrefPath = GetAvPref('Path','MatlabPref');

load(MatlabPrefPath);

if nargin <= 1
    
    error('Not enough input arguments.');
    
elseif nargin > 1 && iscellstr(varargin(1:end-1))
   
    Statement = cell(1,nargin+1);
    Statement{1} = 'Preferences.AvPref';
    Statement{end} = '= varargin{end};';
    for iArg = 1:nargin-1
        if isempty(regexp(varargin{iArg},'(\(|\)|\{|\})', 'once')) ||... %没有括号
                xor(isscalar(regexp(varargin{iArg},'^[a-zA-Z_]+\([^\(\)\{\}]*\)$')),isscalar(regexp(varargin{iArg},'^[a-zA-Z_]+\{[^\(\)\{\}]*\}$')))%有括号
            Statement{iArg+1} = ['.',varargin{iArg}];
        else
            error(['Ilegal input argument ',num2str(iArg),' .']);
        end
    end
    
    eval(cell2mat(Statement));
end

save(MatlabPrefPath,'Preferences');


end