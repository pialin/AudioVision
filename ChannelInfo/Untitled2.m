for i= 1:68
    AvPref.Channel(i,1).Label = l{i};   
end
for i= 1:68
    AvPref.Channel(i,1).Type = 'EEG';   
end
for i= 67:68
    AvPref.Channel(i,1).Type = l{i}; 
     
end

AvPref.Channel(33,1).Type = 'Mastoid';
AvPref.Channel(43,1).Type = 'Mastoid';
AvPref.Channel(65,1).Type = 'EOG';
AvPref.Channel(66,1).Type = 'EOG';

AvPref.Channel(2,1).Label = 'FPz';
AvPref.Channel(10,1).Label = 'Fz';
AvPref.Channel(19,1).Label = 'FCz';
AvPref.Channel(28,1).Label = 'Cz';
AvPref.Channel(38,1).Label = 'CPz';
AvPref.Channel(48,1).Label = 'Pz';
AvPref.Channel(56,1).Label = 'POz';
AvPref.Channel(62,1).Label = 'Oz';

ChannelPlotInfo.LabelPos(1:68,:) =   NewChannelInfo.LabelPos(1:68,:);
ChannelPlotInfo.ElectrodePos(1:68,:) = NewChannelInfo.Pos(1:68,:);
ChannelPlotInfo.Label(1:68,1) = NewChannelInfo.Label(1:68,1);

ChannelPlotInfo.HeadOutline = NewChannelInfo.HeadOutline;
ChannelPlotInfo.NoseOutline = NewChannelInfo.NoseOutline;
ChannelPlotInfo.LeftEarOutline = NewChannelInfo.LeftEarOutline;
ChannelPlotInfo.RightEarOutline = NewChannelInfo.RightEarOutline;

NewChannelInfo = ChannelInfo;

NewChannelInfo.Label(1:68,1)  = ChannelInfo.Label([1:32,59,33:41,60,42:51,65,52:54,66,55,67,56:58,68,62,61,63:64],1);
NewChannelInfo.LabelPos(1:68,1)  = ChannelInfo.LabelPosX([1:32,59,33:41,60,42:51,65,52:54,66,55,67,56:58,68,62,61,63:64],1);
NewChannelInfo.LabelPos(1:68,2)  = ChannelInfo.LabelPosY([1:32,59,33:41,60,42:51,65,52:54,66,55,67,56:58,68,62,61,63:64],1);
NewChannelInfo.Pos(1:68,1)  = ChannelInfo.PosX([1:32,59,33:41,60,42:51,65,52:54,66,55,67,56:58,68,62,61,63:64],1);
NewChannelInfo.Pos(1:68,2)  = ChannelInfo.PosY([1:32,59,33:41,60,42:51,65,52:54,66,55,67,56:58,68,62,61,63:64],1);
NewChannelInfo.Type(1:68,1)  = ChannelInfo.type([1:32,59,33:41,60,42:51,65,52:54,66,55,67,56:58,68,62,61,63:64],1);

save NewChannelInfo.mat NewChannelInfo;



% NewChannelInfo.Label(34:42)  = ChannelInfo.Label(33:41);
% NewChannelInfo.Label(43)  = ChannelInfo.Label(60);
% NewChannelInfo.Label(44:53)  = ChannelInfo.Label(42:51);
% NewChannelInfo.Label(54)  = ChannelInfo.Label(65);
% NewChannelInfo.Label(55:57)  = ChannelInfo.Label(52:54);
% NewChannelInfo.Label(58)  = ChannelInfo.Label(66);
% NewChannelInfo.Label(59)  = ChannelInfo.Label(65);
% NewChannelInfo.Label(60)  = ChannelInfo.Label(67);
% NewChannelInfo.Label(61:63)  = ChannelInfo.Label(56:58);
% NewChannelInfo.Label(64)  = ChannelInfo.Label(68);
% NewChannelInfo.Label(65:68)  = ChannelInfo.Label(61:64);



NewChannelInfo.LabelPosX
NewChannelInfo.LabelPosY
NewChannelInfo.PosX
NewChannelInfo.PosY


NewChannelInfo.type


  
  
  