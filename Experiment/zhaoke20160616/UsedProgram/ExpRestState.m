LptAddress = 53264;
AudioSampleRate=48000;
FreqHintSound = 800;
TimeHintSound = 1;
TimeRestState = 60;
%生成提示音
t = linspace(0,TimeHintSound,round(TimeHintSound*AudioSampleRate));
DataHintSound =  0.5*sin(2*pi*FreqHintSound*t);

%淡入淡出点数设置
NumPointFadeIn = 8000;
NumPointFadeOut = 8000;

t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;
%计算渐入幅度调制正弦函数的频率
FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);
%计算渐入幅度调制正弦函数的幅度
AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;

t = (1:round(NumPointFadeOut))/AudioSampleRate;
%计算渐出幅度调制正弦函数的频率
FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);
%计算渐出幅度调制正弦函数的幅度
AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;

%将正弦幅度调制函数和提示音开头和结尾的数据相乘
DataHintSound(:,1:NumPointFadeIn)=DataHintSound(:,1:NumPointFadeIn).*AmpFadeIn;

DataHintSound(:,end-NumPointFadeIn+1:end)=DataHintSound(:,end-NumPointFadeIn+1:end).*AmpFadeOut;

%开始先等待2秒
WaitSecs(2);
%播放提示音
Snd('Open');
Snd('Play',DataHintSound,48000);

WaitSecs(TimeHintSound);
StartTime = GetSecs;
% lptwrite(LptAddress,254);
%将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
WaitSecs(0.1);
%将并口置0
% lptwrite(LptAddress,0);



WaitSecs(TimeRestState-0.1);

disp(GetSecs - StartTime);


Snd('Play',DataHintSound,48000);

WaitSecs(TimeHintSound);
Snd('Close') ;
