%Sound23
clear;
syms mel y t f kf ka;
fi = sym('f',[3,1]);
infi = sym('f',[3,1]);
AmpR = sym('AmpR',[3,1]);

% f =sym('700*exp(mel/1127-1)');
f =sym('700*(10^(mel/2595)-1)');

f = subs(f,mel,sym('100+y*1200'));


AudioSampleRate = 48000;

TimeSound = 3;

NumSumPoint = round(TimeSound*AudioSampleRate);
ValueIntf = zeros(1,NumSumPoint);
ValueFreq = zeros(1,NumSumPoint);
ValueAmpR = zeros(1,NumSumPoint);


LenSum = 0.4*pi;
CoefLen2Time = TimeSound/LenSum;

NumSeg = 2;

iSeg = 1;

LenSeg = zeros(1,NumSeg);
TimeSeg = zeros(1,NumSeg);
NumSegPoint = zeros(1,NumSeg);
SegStartPoint = zeros(1,NumSeg);
SegStartPoint(1) = 1;
%¶Î1 _
LenSeg(iSeg) = 0.2*pi;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);
SegStartPoint(iSeg+1) = SegStartPoint(iSeg) +NumSegPoint(iSeg);

fi(iSeg) = subs(f,y,sym('0.5-0.2*sin(kf*t)'));
fi(iSeg) = subs(fi(iSeg),kf,pi/TimeSeg(iSeg));

ValueF =  double(subs(fi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
   
AmpR(iSeg) = sym('0.3-0.2*cos(ka*t)');
AmpR(iSeg) = subs(AmpR(iSeg),ka,pi/TimeSeg(iSeg));

T = linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg));
ValueFreq(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(fi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
ValueIntf(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) =cumtrapz(T,ValueF); 
    
ValueAmpR(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));


iSeg = iSeg +1;
% %¶Î2 |
% LenSeg(iSeg) = 0.2*pi;
% TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
% NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);
% SegStartPoint(iSeg+1) = SegStartPoint(iSeg) +NumSegPoint(iSeg);
% 
% fi(iSeg) = subs(f,y,sym('0.5-0.2*sin(kf*t)'));
% fi(iSeg) = subs(fi(iSeg),kf,pi/TimeSeg(iSeg));
% ValueF =  double(subs(fi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
% 
% AmpR(iSeg) = sym('0.7-0.2*cos(ka*t)');
% AmpR(iSeg) = subs(AmpR(iSeg),ka,pi/TimeSeg(iSeg));
% T = linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg));
% 
% ValueIntf(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) =...
%     cumtrapz(T,ValueF)+ValueIntf(SegStartPoint(iSeg)-1); 
% ValueAmpR(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
%     double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
% 
% 
% 
% iSeg = iSeg +1;
%¶Î3 -
LenSeg(iSeg) =  0.2*pi;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = NumSumPoint-sum(NumSegPoint(1:iSeg-1));

fi(iSeg) = subs(f,y,sym('0.5+0.2*sin(kf*t)'));
fi(iSeg) = subs(fi(iSeg),kf,pi/TimeSeg(iSeg));
ValueF =  double(subs(fi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
  
AmpR(iSeg) = sym('0.7-0.2*cos(ka*t)');
AmpR(iSeg) = subs(AmpR(iSeg),ka,pi/TimeSeg(iSeg));

T = linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg));
ValueFreq(SegStartPoint(iSeg):end) = ...
    double(subs(fi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
ValueIntf(SegStartPoint(iSeg):end) =...
    cumtrapz(T,ValueF)+ValueIntf(SegStartPoint(iSeg)-1); 

ValueAmpR(SegStartPoint(iSeg):end) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));


ValueAmpL = 1 - ValueAmpR; 

DataAudio= [ValueAmpL;ValueAmpR].*repmat(cos(2*pi*ValueIntf),2,1);



%µ­Èëµ­³ö
NumPointFadeIn = 1000;

NumPointFadeOut = 1000;

t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;

FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);

AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;

t = (1:round(NumPointFadeOut))/AudioSampleRate;

FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);

AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;


DataAudio(:,1:NumPointFadeIn)=DataAudio(:,1:NumPointFadeIn).*repmat(AmpFadeIn,2,1);


DataAudio(:,end-NumPointFadeIn+1:end)=DataAudio(:,end-NumPointFadeIn+1:end).*repmat(AmpFadeOut,2,1);

%%
figure;
plot(ValueFreq);
figure;
spectrogram(DataAudio(1,:),1024,512,1024,48000,'yaxis');
axis([0,3,0,2000]);

sound(DataAudio,AudioSampleRate);


save Sound23.mat DataAudio;

% audiowrite('Sound13.wav',DataAudio',AudioSampleRate);
wavwrite(DataAudio',AudioSampleRate,'Sound23.wav');
