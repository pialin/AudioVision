%�˺������������ͨ������������ʽ����Ѱ��ƥ��ĵ缫����
%'all'����ȫѡ��������ʽ��Сд������
function IndexSelectedChannel = GetChannelIndex(ChannelNameRegExp)


%��ȡͨ������˳��
ChannelLabel = GetAvPref('Channel','Label');
IndexSelectedChannel = false(numel(ChannelLabel),1);
if ischar(ChannelNameRegExp)
    if strcmpi(ChannelNameRegExp,'all')
        IndexSelectedChannel = true(numel(ChannelLabel),1);
    else
        IndexSelectedChannel = ~cellfun('isempty',regexpi(ChannelLabel,ChannelNameRegExp));
    end
elseif iscell(ChannelNameRegExp)
    for iExpReg = 1:numel(ChannelNameRegExp)
        if ischar(ChannelNameRegExp{iExpReg})
            
            if strcmpi(ChannelNameRegExp{iExpReg},'all')
                IndexTemp = true(numel(ChannelLabel),1);
            else
                IndexTemp = ~cellfun('isempty',regexpi(ChannelLabel,ChannelNameRegExp{iExpReg}));
                
            end
            IndexSelectedChannel = IndexSelectedChannel | IndexTemp;
        else
            error('Please Input A "Charactor String" or "Charactor String Cell" As Parameter.');
        end
    end
else
    error('Please Input A "Charactor String" or "Charactor String Cell" As Parameter.');
end
%���û��ͨ����ѡ����ʾ����
if nnz(IndexSelectedChannel) == 0
    warning('No Selected Channel!');
end
IndexSelectedChannel = find(IndexSelectedChannel);
end


