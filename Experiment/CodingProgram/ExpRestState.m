LptAddress = 53264;
AudioSampleRate=48000;
FreqHintSound = 800;
TimeHintSound = 1;
TimeRestState = 60;
%������ʾ��
t = linspace(0,TimeHintSound,round(TimeHintSound*AudioSampleRate));
DataHintSound =  0.5*sin(2*pi*FreqHintSound*t);

%���뵭����������
NumPointFadeIn = 8000;
NumPointFadeOut = 8000;

t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;
%���㽥����ȵ������Һ�����Ƶ��
FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);
%���㽥����ȵ������Һ����ķ���
AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;

t = (1:round(NumPointFadeOut))/AudioSampleRate;
%���㽥�����ȵ������Һ�����Ƶ��
FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);
%���㽥�����ȵ������Һ����ķ���
AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;

%�����ҷ��ȵ��ƺ�������ʾ����ͷ�ͽ�β���������
DataHintSound(:,1:NumPointFadeIn)=DataHintSound(:,1:NumPointFadeIn).*AmpFadeIn;

DataHintSound(:,end-NumPointFadeIn+1:end)=DataHintSound(:,end-NumPointFadeIn+1:end).*AmpFadeOut;

%��ʼ�ȵȴ�2��
WaitSecs(2);
%������ʾ��
Snd('Open');
Snd('Play',DataHintSound,48000);

WaitSecs(TimeHintSound);
StartTime = GetSecs;
% lptwrite(LptAddress,254);
%������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
WaitSecs(0.1);
%��������0
% lptwrite(LptAddress,0);



WaitSecs(TimeRestState-0.1);

disp(GetSecs - StartTime);


Snd('Play',DataHintSound,48000);

WaitSecs(TimeHintSound);
Snd('Close') ;
