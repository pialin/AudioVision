function Plot2dSpectrum(InputArg)

%Necessary input field:Psd,Freq,ChannelLabel
%Optional input field:FreqMin,FreqMax,IndexChannel

ValidNecessaryField(InputArg,'Psd','Freq','ChannelLabel');
InputArg = ValidOptionalField(InputArg,'FreqMin',min(InputArg.Freq),...
    'FreqMax',max(InputArg.Freq),...
    'IndexChannel',true(numel(InputArg.ChannelLabel),1));

NumChannel = nnz(InputArg.IndexChannel);

ChannelLabel = InputArg.ChannelLabel(InputArg.IndexChannel);

FreqIndex = InputArg.Freq>=InputArg.FreqMin & InputArg.Freq<InputArg.FreqMax;

Freq = InputArg.Freq(FreqIndex);
FreqMax = max(Freq);
FreqMin = min(Freq);


Psd = InputArg.Psd(InputArg.IndexChannel,FreqIndex);

NumFreq = numel(Freq);

% OriZ = reshape(Psd',[],1);
% OriX = repmat(InputArg.Freq(InputArg.Freq>=InputArg.FreqMin & InputArg.Freq<InputArg.FreqMax),NumChannel,1);
% OriY = reshape(repmat(1:NumChannel,NumPoint,1),[],1);

OriZ = Psd';
OriX = repmat(Freq,1,NumChannel);
OriY = repmat((1:NumChannel),NumFreq,1);


% OriX(isnan(OriZ)) = [];
% OriY(isnan(OriZ)) = [];
% ChannelLabel(isnan(OriZ))=[];
% OriZ(isnan(OriZ)) = [];


% %生成XY格点
% [GridX,GridY]=meshgrid(linspace(FreqMin,FreqMax,100),linspace(0,NumChannel+1,100));
% %根据给定的Z数据进行二维插值（V4）
% GridZ = griddata(OriX,OriY,OriZ,GridX,GridY,'v4');


% figure;
%绘制地形图
pcolor(OriX,OriY,OriZ);
% pcolor(GridX,GridY,GridZ);
shading interp;
%显示右侧颜色和值对应条
colorbar;
%设置显示的XY轴的范围
axis([FreqMin,FreqMax,1,NumChannel]);
set(gca,'ytick',1:NumChannel,'yticklabel',ChannelLabel);
xlabel('频率/Hz');
ylabel('导联');
% axis equal;
%隐藏XY坐标轴
% axis off;
%设置颜色映射方案（内置可选：parula/jet/spring/summer/autumn/winter/grey等）
colormap jet; 

end
