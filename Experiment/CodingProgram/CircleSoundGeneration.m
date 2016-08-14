r = 0.4;

x1 = 0.1;
y1 = 0;

x2 = 0.9;
y2 = 0;


MelMin =  100;
MelMax = 1500;
CoefXtoT = 1.5;
SampleRateAudio = 48000;
LengthPerSeg = 0.01;
TimePerSeg = LengthPerSeg * CoefXtoT;
NumPointPerSeg = TimePerSeg*SampleRateAudio;
FreqMin = 700*exp(MelMin/1127-1);
NumPadPoint = ceil (1/FreqMin * SampleRateAudio);



%%

LengthLine = 2*pi*0.4/2;
NumSeg = round(LengthLine/LengthPerSeg)+1;


x = linspace(x1,x2,NumSeg);

y = sqrt(r^2-(x-0.5).^2) + 0.5;

mel =  y*(MelMax-MelMin)+MelMin;

f = 700*exp(mel/1127-1);

DataAudio1 = zeros(1,NumPointPerSeg*(NumSeg-1));
CurrentIndex = 0;

for iSeg = 1:NumSeg - 1

    if abs(f(iSeg)-f(iSeg+1))<1
        
        DataChirp = chirp((1:NumPointPerSeg+NumPadPoint)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'linear');
        
    else
        
        DataChirp = chirp((1:NumPointPerSeg+NumPadPoint)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'logarithmic');
        
    end
    
    if iSeg == 1        
        
        for iStartPoint = 1:NumPointPerSeg+NumPadPoint-1
            
            if DataChirp(iStartPoint)*DataChirp(iStartPoint+1) <= 0
                
                break;
            end
            
        end
        
    else
        iStartPoint = 1;
              
    end
    
    if mod(iSeg,2) == 0
        for iEndPoint = NumPointPerSeg:-1:iStartPoint+1
            
            if DataChirp(iEndPoint)> DataChirp(iEndPoint-1) &&  DataChirp(iEndPoint)> DataChirp(iEndPoint+1)
                
                break;
            end
            
        end
    elseif mod(iSeg,2) == 1
        
        for iEndPoint = NumPointPerSeg:NumPointPerSeg+NumPadPoint-1
            
            if DataChirp(iEndPoint)> DataChirp(iEndPoint-1) &&  DataChirp(iEndPoint)> DataChirp(iEndPoint+1)
                
                break;
            end
            
        end
        
        
    end
   
    AmpRight = linspace(x(iSeg),x(iSeg+1),iEndPoint-iStartPoint+1);
    AmpLeft =1-AmpRight;
    
    DataAudio(1,CurrentIndex+1:CurrentIndex+iEndPoint-iStartPoint+1) = DataChirp(iStartPoint:iEndPoint).*AmpLeft;
    DataAudio(2,CurrentIndex+1:CurrentIndex+iEndPoint-iStartPoint+1) = DataChirp(iStartPoint:iEndPoint).*AmpRight;
    
    CurrentIndex = CurrentIndex+iEndPoint-iStartPoint+1;
    

end


%%
LengthLine = 2*pi*0.4/2;
NumSeg = round(LengthLine/LengthPerSeg)+1;

DataAudio = [DataAudio(:,1:CurrentIndex),zeros(2,(NumPointPerSeg+NumPadPoint)*(NumSeg-1))];

x = linspace(x2,x1,NumSeg);

y = 0.5 - sqrt(r^2-(x-0.5).^2);

mel =  y*(MelMax-MelMin)+MelMin;

f = 700*exp(mel/1127-1);

for iSeg = 1:NumSeg - 1
    
    
    if abs(f(iSeg)-f(iSeg+1))<1
        
        DataChirp = chirp((1:NumPointPerSeg+NumPadPoint)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'linear');
        
    else
        
        DataChirp = chirp((1:NumPointPerSeg+NumPadPoint)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'logarithmic');
        
    end
    
    
    if iSeg ~= NumSeg - 1
        
        if mod(iSeg,2) == 0
            for iEndPoint = NumPointPerSeg:-1:2
                
                if DataChirp(iEndPoint)> DataChirp(iEndPoint-1) &&  DataChirp(iEndPoint)> DataChirp(iEndPoint+1)
                    
                    break;
                end
                
            end
        elseif mod(iSeg,2) == 1
            
            for iEndPoint = NumPointPerSeg:NumPointPerSeg+NumPadPoint-1
                
                if DataChirp(iEndPoint)> DataChirp(iEndPoint-1) &&  DataChirp(iEndPoint)> DataChirp(iEndPoint+1)
                    
                    break;
                end
                
            end
        end
        
        
    else
        
        if mod(iSeg,2) == 0
            for iEndPoint = NumPointPerSeg:-1:2
                
                if DataChirp(iEndPoint)*DataChirp(iEndPoint-1) <=0
                    break;
                end
                
            end
        elseif mod(iSeg,2) == 1
            
            for iEndPoint = NumPointPerSeg:NumPointPerSeg+NumPadPoint-1
                
                if DataChirp(iEndPoint)*DataChirp(iEndPoint+1) <=0
                    
                    break;
                end
                
            end
        end
        
        
        
    end
    AmpRight = linspace(x(iSeg),x(iSeg+1),iEndPoint);
    AmpLeft =1-AmpRight;
    
    DataAudio(1,CurrentIndex+1:CurrentIndex+iEndPoint) = DataChirp(1:iEndPoint).*AmpLeft;
    DataAudio(2,CurrentIndex+1:CurrentIndex+iEndPoint) = DataChirp(1:iEndPoint).*AmpRight;
    
    CurrentIndex =CurrentIndex+iEndPoint;
    

end

DataAudio = DataAudio(:,1:CurrentIndex);

sound(DataAudio,SampleRateAudio);

CircleSound = DataAudio;

save CircleSound.mat CircleSound;


