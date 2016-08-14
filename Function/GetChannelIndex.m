%此函数根据输入的通道名称正则表达式依照寻找匹配的电极索引
%'all'代表全选，正则表达式大小写不敏感
function IndexSelectedChannel = GetChannelIndex(ChannelNameRegExp)


%获取通道排列顺序
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
%如果没有通道被选中显示警告
if nnz(IndexSelectedChannel) == 0
    warning('No Selected Channel!');
end
IndexSelectedChannel = find(IndexSelectedChannel);
end


