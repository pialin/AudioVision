function PlotHeadTopo(InputArg)

%%
load(GetAvPref('Path','HeadTopoInfo'));

NumChannel = numel(HeadTopoInfo.Label);

ValidNecessaryField(InputArg,'ChannelValue');

InputArg = ValidOptionalField(InputArg,'IndexChannel',true(NumChannel,1));

if numel(InputArg.IndexChannel) ~= numel(InputArg.ChannelValue) 
    error('''IndexChannel'' and ''ChannelValue'' should match each other!')
elseif ~isnumeric(InputArg.ChannelValue)
    error('''ChannelValue'' should be a numeric vector!');
else
    ChannelValue =reshape(InputArg.ChannelValue,[],1);
end
%���ԭ��figure������
clf;

hold on;
axis([-0.6 0.6 -0.6 0.6]);
axis equal;
axis off;

alpha = linspace(0,2*pi,500);
%���
x=HeadTopoInfo.LeftEarOutline.Center(1)+HeadTopoInfo.LeftEarOutline.RadiusX*cos(alpha);
y=HeadTopoInfo.LeftEarOutline.Center(2)+HeadTopoInfo.LeftEarOutline.RadiusY*sin(alpha);
plot(x,y,'-k','linewidth',3);
%�Ҷ�
x=HeadTopoInfo.RightEarOutline.Center(1)+HeadTopoInfo.RightEarOutline.RadiusX*cos(alpha);
y=HeadTopoInfo.RightEarOutline.Center(2)+HeadTopoInfo.RightEarOutline.RadiusY*sin(alpha);
plot(x,y,'-k','linewidth',3);

plot(HeadTopoInfo.NoseOutline(:,1),HeadTopoInfo.NoseOutline(:,2),'-k','linewidth',3);

R=HeadTopoInfo.HeadOutline.Radius;
x=HeadTopoInfo.HeadOutline.Center(1) + R*cos(alpha);
y=HeadTopoInfo.HeadOutline.Center(2) + R*sin(alpha);

% fill(x,y,'w');

%����XY���
[GridX,GridY]=meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);
%���ݸ�����Z���ݽ��ж�ά��ֵ��V4��
GridZ = griddata(HeadTopoInfo.LabelPos(InputArg.IndexChannel,1),...
    HeadTopoInfo.LabelPos(InputArg.IndexChannel,2),ChannelValue(InputArg.IndexChannel),GridX,GridY,'v4');

%��ͷ��������������ݵ���ΪNaN������
isin = GridX.^2+GridY.^2<= 0.2;
GridZ(~isin) = NaN;

% figure;
%���Ƶ���ͼ
pcolor(GridX,GridY,GridZ);
shading interp;
colormap jet;
%��ʾ�Ҳ���ɫ��ֵ��Ӧ��
colorbar;

plot(x,y,'-k','linewidth',3);

plot(HeadTopoInfo.ElectrodePos(InputArg.IndexChannel,1),...
    HeadTopoInfo.ElectrodePos(InputArg.IndexChannel,2),'ok','markersize',4);

text(HeadTopoInfo.LabelPos(InputArg.IndexChannel,1),...
    HeadTopoInfo.LabelPos(InputArg.IndexChannel,2),HeadTopoInfo.Label(InputArg.IndexChannel),'FontName','Roboto','FontWeight','Bold');

hold off;
 

end
