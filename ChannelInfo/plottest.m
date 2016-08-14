%%
load ChannelPlotInfo;
figure;
hold on;
axis([-0.6 0.6 -0.6 0.6]);
axis equal;
axis off;

alpha = linspace(0,2*pi,500);
%���
x=ChannelPlotInfo.LeftEarOutline.Center(1)+ChannelPlotInfo.LeftEarOutline.RadiusX*cos(alpha);
y=ChannelPlotInfo.LeftEarOutline.Center(2)+ChannelPlotInfo.LeftEarOutline.RadiusY*sin(alpha);
plot(x,y,'-k','linewidth',3);
%�Ҷ�
x=ChannelPlotInfo.RightEarOutline.Center(1)+ChannelPlotInfo.RightEarOutline.RadiusX*cos(alpha);
y=ChannelPlotInfo.RightEarOutline.Center(2)+ChannelPlotInfo.RightEarOutline.RadiusY*sin(alpha);
plot(x,y,'-k','linewidth',3);


plot(ChannelPlotInfo.NoseOutline(:,1),ChannelPlotInfo.NoseOutline(:,2),'-k','linewidth',3);



R=ChannelPlotInfo.HeadOutline.Radius;
x=ChannelPlotInfo.HeadOutline.Center(1) + R*cos(alpha);
y=ChannelPlotInfo.HeadOutline.Center(2) + R*sin(alpha);
fill(x,y,'w');
plot(x,y,'-k','linewidth',3);

plot(ChannelPlotInfo.ElectrodePos(:,1),ChannelPlotInfo.ElectrodePos(:,2),'ok','markersize',4);


% LabelPosX = zeros(numel(ChannelPlotInfo.Label),1);
% LabelPosY = zeros(numel(ChannelPlotInfo.Label),1);
% 
% IndexTwoCharElectrode = ~cellfun('isempty',regexp(ChannelPlotInfo.Label,'^..$'));
% IndexThreeCharElectrode = ~cellfun('isempty',regexp(ChannelPlotInfo.Label,'^...$'));
% 
% %�ֱ��趨˫�ַ��缫�����ַ��缫�ı�עˮƽλ��
% LabelPosX(IndexTwoCharElectrode) =  ChannelPlotInfo.PosX(IndexTwoCharElectrode)-0.018;
% LabelPosX(IndexThreeCharElectrode) =  ChannelPlotInfo.PosX(IndexThreeCharElectrode)-0.025;
% 
% ChannelPlotInfo.LabelPosX = LabelPosX;
% 
% IndexCB1CB2Electrode = ~cellfun('isempty',regexp(ChannelPlotInfo.Label,'^CB.$'));
% %�ֱ��趨CB1(58)��CB2��62���������缫�ı�ע��ֱλ��
% LabelPosY(IndexCB1CB2Electrode) = ChannelPlotInfo.PosY(IndexCB1CB2Electrode)+0.03;
% 
% LabelPosY(~IndexCB1CB2Electrode) = ChannelPlotInfo.PosY(~IndexCB1CB2Electrode)-0.03;
% 
% ChannelPlotInfo.LabelPosY = LabelPosY;



text(ChannelPlotInfo.LabelPos(:,1),ChannelPlotInfo.LabelPos(:,2),ChannelPlotInfo.Label,'FontName','Roboto','FontWeight','Bold');

hold off;