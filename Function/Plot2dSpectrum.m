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


% %����XY���
% [GridX,GridY]=meshgrid(linspace(FreqMin,FreqMax,100),linspace(0,NumChannel+1,100));
% %���ݸ�����Z���ݽ��ж�ά��ֵ��V4��
% GridZ = griddata(OriX,OriY,OriZ,GridX,GridY,'v4');


% figure;
%���Ƶ���ͼ
pcolor(OriX,OriY,OriZ);
% pcolor(GridX,GridY,GridZ);
shading interp;
%��ʾ�Ҳ���ɫ��ֵ��Ӧ��
colorbar;
%������ʾ��XY��ķ�Χ
axis([FreqMin,FreqMax,1,NumChannel]);
set(gca,'ytick',1:NumChannel,'yticklabel',ChannelLabel);
xlabel('Ƶ��/Hz');
ylabel('����');
% axis equal;
%����XY������
% axis off;
%������ɫӳ�䷽�������ÿ�ѡ��parula/jet/spring/summer/autumn/winter/grey�ȣ�
colormap jet; 

end
