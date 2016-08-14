function  TrialDetrend(DataTrial)


SampleRate = GetAvPref('Data','SampleRate');
ChannelType = GetAvPref('Channel','Type');
ChannelLabel = GetAvPref('Channel','Label');
NumChannel = numel(ChannelLabel);
IndexEegChannel = find(strcmpi('EEG',ChannelType));
NumEegChannel = nnz(strcmpi('EEG',ChannelType));
NumTrial = size(DataTrial,3);

InitChannel = 1;
InitTrial = 1;
InitOrder = 0;


TrialTime = (1:size(DataTrial,2))/SampleRate;


DetrendFigHandle = figure();

if   InitChannel <= NumEegChannel && InitTrial <= NumTrial

    [PolyCoef,ErrorSrtuct,mu] = polyfit(TrialTime,DataTrial(IndexEegChannel(InitChannel),:,InitTrial),InitOrder);
    [EstimateBaseLine,~] = polyval(PolyCoef,TrialTime,ErrorSrtuct,mu);
    
    DetrendFigHandle.Name=['Trial',num2str(InitTrial),' ', ChannelLabel{IndexEegChannel(InitChannel)},' ',num2str(InitOrder),'阶基线拟合'];
    
    plot(TrialTime,DataTrial(IndexEegChannel(InitChannel),:,InitTrial),'r',...
        TrialTime,EstimateBaseLine,'b',...
        TrialTime,DataTrial(IndexEegChannel(InitChannel),:,InitTrial) - EstimateBaseLine,'k');
end


setappdata(DetrendFigHandle,'Data_Trial',DataTrial);
setappdata(DetrendFigHandle,'iTrial',InitTrial);
setappdata(DetrendFigHandle,'iChannel',InitChannel);
setappdata(DetrendFigHandle,'iOrder',InitOrder);
setappdata(DetrendFigHandle,'NumTrial',NumTrial);

setappdata(DetrendFigHandle,'NumEegChannel',NumEegChannel);
setappdata(DetrendFigHandle,'IndexEegChannel',IndexEegChannel);
setappdata(DetrendFigHandle,'ChannelLabel',ChannelLabel);

% DetrendFigHandle.WindowKeyPressFcn = @KeyPressCallBack;
DetrendFigHandle.WindowKeyReleaseFcn ={@KeyReleaseCallBack,DetrendFigHandle};
% DetrendFigHandle.CreateFcn = {@PlotFirstDetrend,1,1,1};

TrialBaselineOrder = ones(NumChannel,NumTrial)*-1;
TrialBaselineOrder(~strcmpi('EEG',ChannelType),:) = NaN;
setappdata(DetrendFigHandle,'TrialBaselineOrder',TrialBaselineOrder);
setappdata(DetrendFigHandle,'TrialTime',TrialTime);

% close(DetrendFigHandle);


end

function KeyReleaseCallBack(~,CallbackData,DetrendFigHandle)

if ~isempty(CallbackData.Key) &&  isempty(CallbackData.Modifier)
    
    iOrder = getappdata(DetrendFigHandle,'iOrder');
    iTrial = getappdata(DetrendFigHandle,'iTrial');
    iChannel = getappdata(DetrendFigHandle,'iChannel');
    TrialBaselineOrder =  getappdata(DetrendFigHandle,'TrialBaselineOrder');
    IndexEegChannel =  getappdata(DetrendFigHandle,'IndexEegChannel');
    NumEegChannel = getappdata(DetrendFigHandle,'NumEegChannel');
    NumTrial = getappdata(DetrendFigHandle,'NumTrial');

    
    
    switch CallbackData.Key
        case 'space'
            
            iOrder = iOrder + 1;
            setappdata(DetrendFigHandle,'iOrder',iOrder);
            
        case 'return'
      
            TrialBaselineOrder(IndexEegChannel(iChannel),iTrial) = iOrder;
            setappdata(DetrendFigHandle,'TrialBaselineOrder',TrialBaselineOrder);
            save('TrialBaselineOrderTemp.mat','TrialBaselineOrder');

            if iChannel < NumEegChannel
                iChannel = iChannel + 1;
                setappdata(DetrendFigHandle,'iChannel',iChannel);
            elseif iChannel == NumEegChannel
                if iTrial < NumTrial
                    iTrial = iTrial + 1;
                    setappdata(DetrendFigHandle,'iTrial',iTrial);
                    setappdata(DetrendFigHandle,'iChannel',1);
                elseif iTrial == NumTrial
                    close(DetrendFigHandle);
                    return;
                else
                    error('Illegal iTrial');
                end
            else
                error('Illegal iChannel');
                
            end
            setappdata(DetrendFigHandle,'iOrder',0);
        case 'backspace'
            
            TrialBaselineOrder(IndexEegChannel(iChannel),iTrial) = NaN;
            setappdata(DetrendFigHandle,'TrialBaselineOrder',TrialBaselineOrder);
            save('TrialBaselineOrderTemp.mat','TrialBaselineOrder');
            
            if iChannel < NumEegChannel
                iChannel = iChannel + 1;
                setappdata(DetrendFigHandle,'iChannel',iChannel);
            elseif iChannel == NumEegChannel
                if iTrial < NumTrial
                    iTrial = iTrial + 1;
                    setappdata(DetrendFigHandle,'iTrial',iTrial);
                    setappdata(DetrendFigHandle,'iChannel',1);
                elseif iTrial == NumTrial
                    close(DetrendFigHandle);
                    return;
                else
                    error('Illegal iTrial');
                end
            else
                error('Illegal iChannel');
                
            end
            setappdata(DetrendFigHandle,'iOrder',0);
        case 'escape'
            close(DetrendFigHandle);
            return;
%         otherwise
%             error('Unknown Key Pressed!')
    end


    
    if iChannel <= NumEegChannel && iTrial <= NumTrial
        
        iOrder = getappdata(DetrendFigHandle,'iOrder');
        iTrial = getappdata(DetrendFigHandle,'iTrial');
        iChannel = getappdata(DetrendFigHandle,'iChannel');
        Data_Trial = getappdata(DetrendFigHandle,'Data_Trial');
        ChannelLabel = getappdata(DetrendFigHandle,'ChannelLabel');
        TrialTime = getappdata(DetrendFigHandle,'TrialTime');
           
        [PolyCoef,ErrorSrtuct,mu] = polyfit(getappdata(DetrendFigHandle,'TrialTime'),Data_Trial(IndexEegChannel(iChannel),:,iTrial),iOrder);
        [EstimateBaseLine,~] = polyval(PolyCoef,TrialTime,ErrorSrtuct,mu);
        
        DetrendFigHandle.Name=['Trial',num2str(iTrial),' ', ChannelLabel{IndexEegChannel(iChannel)},' ',num2str(iOrder),'阶基线拟合'];
        
        Data_Detrend = Data_Trial;
        Data_Detrend(IndexEegChannel(iChannel),:,iTrial) = Data_Trial(IndexEegChannel(iChannel),:,iTrial) - EstimateBaseLine;
        
        plot(TrialTime,Data_Trial(IndexEegChannel(iChannel),:,iTrial),'r',...
            TrialTime,EstimateBaseLine,'b',...
            TrialTime, Data_Detrend(IndexEegChannel(iChannel),:,iTrial),'k');
        if strcmpi(CallbackData.Key,'return')
            
            save('DataDetrendTemp.mat','Data_Detrend');
            
        end
    else
        error('Illegal iChannel or iTrial');
    end
end

end
% function PlotFirstDetrend(DetrendFigHandle,~,InitChannel,InitTrial,InitOrder)
% % [~,DetrendFigHandle] = gcbo;
% IndexEegChannel =  getappdata(DetrendFigHandle,'IndexEegChannel');
% NumTrial = getappdata(DetrendFigHandle,'NumTrial');
% if   InitChannel <= NumEegChannel && InitTrial <= NumTrial
%     
%     Data_Trial = getappdata(DetrendFigHandle,'Data_Trial');
%     ChannelLabel = getappdata(DetrendFigHandle,'ChannelLabel');
%     
%     [PolyCoef,ErrorSrtuct,mu] = polyfit(getappdata(DetrendFigHandle,'TrialTime'),Data_Trial(IndexEegChannel(InitChannel),:,InitTrial),InitOrder);
%     [EstimateBaseLine,~] = polyval(PolyCoef,TrialTime,ErrorSrtuct,mu);
%     
%     DetrendFigHandle.Name=['Trial',num2str(InitTrial),' ', ChannelLabel{IndexEegChannel(InitChannel)},'',num2str(InitOrder),'阶基线拟合'];
%     
%     plot(TrialTime,Data_Trial(IndexEegChannel(InitChannel),:,InitTrial),'r',...
%         TrialTime,EstimateBaseLine,'b',...
%         TrialTime,Data_Trial(IndexEegChannel(InitChannel),:,InitTrial) - EstimateBaseLine,'k');
% end
% end




