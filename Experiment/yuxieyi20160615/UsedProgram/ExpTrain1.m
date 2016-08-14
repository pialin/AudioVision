%此程序为训练程序
%软件环境：
%Psychtoolbox:3.0.12
%Matlab:R2015a x64
%Windows 8.1 x64

%%
%关闭所有绘图窗口并清除所有变量
close all;
clear;
%关闭已经打开的Psych窗口
sca;


%隐藏光标
HideCursor;

%修改工作路径至当前M文件所在目录
Path=mfilename('fullpath');
FileSepIndex = strfind(Path,filesep);
cd(Path(1:FileSepIndex(end)));

%获取当前Matlab版本
MatlabRelease = version('-release');


%随机数生成器状态设置(保证每一次随机出来的图案顺序都不一样)
if str2double(MatlabRelease(1:end-1))>=2011%Matla为R2011之后版本
    rng('shuffle');
else
    rand('twister',mod(floor(now*8640000),2^31-1));%Matlab为R2011之前版本
end

%%
%显示部分设置
%执行默认设置2
%相当于执行了以下三条语句：
%“AssertOpenGL;” 确保Screen函数被正确安装
%“KbName('UnifyKeyNames');” 设置一套适用于所有操作系统的统一的KeyCode（按键码）和KeyName（按键名）对(MacOS-X),使用“ KbName('KeyNamesOSX')”查看
%在创建窗口后立刻执行“Screen('ColorRange', PointerWindow, 1, [],1);”将颜色的设定方式由3个8位无符号整数组成的三维向量改成3个0到1的浮点数三维向量，目的是为了同时兼容不同颜色位数的显示器（比如8位和16位显示器）
PsychDefaultSetup(2);

% %键盘响应设置
% %Matlab命令行窗口停止响应键盘字符输入（按Crtl+C可以取消这一状态）
% ListenChar(2);

%限制KbCheck响应的按键范围（只有Esc及space键可以触发KbCheck）
RestrictKeysForKbCheck([KbName('ESCAPE'),KbName('space')]);


%获取所有显示器的序号
AllScreen = Screen('Screens');
%取最大的显示器序号：若有外接显示器，保证呈现范式所用的显示器为外接显示器
ScreenNumber = max(AllScreen);

%获取黑白对应的颜色设定值并据此计算其他一些颜色的设定值
white = WhiteIndex(ScreenNumber);
black = BlackIndex(ScreenNumber);



%%
%try catch语句保证在程序执行过程中出错可以及时关闭创建的window和PortAudio对象，正确退出程序
try
    
    %创建一个窗口对象，返回对象指针PointerWindow,第三个参数设置新建窗口的背景色为黑色
    PointerWindow = PsychImaging('OpenWindow', ScreenNumber, black);
    
    %获取每次帧刷新之间的时间间隔
    TimePerFlip = Screen('GetFlipInterval', PointerWindow);
    
    %计算每秒刷新的帧数
    FramePerSecond =1/TimePerFlip;
    
    %获取可用的屏幕显示优先级？？
    LevelTopPriority = MaxPriority(PointerWindow,'KbCheck','KbWait');
    %获取屏幕分辨率 SizeScreenX,SizeScreenY分别指横向和纵向的分辨率
    [SizeScreenX, SizeScreenY] = Screen('WindowSize', PointerWindow);
    
    %调用Exp_ParameterSetting.m设置相应参数
    Exp_ParameterSetting;
    
    %字体和大小设定
    Screen('TextFont', PointerWindow, FontName);
    Screen('TextSize', PointerWindow ,FontSize);
    %设置Alpha-Blending相应参数
    Screen('BlendFunction', PointerWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %等待帧数设定，后面用于保证准确的帧刷新时序
    FrameWait = 1;
    
    
    %%
    %音频设置
    
    %开启低延迟模式
    EnableSoundLowLatencyMode = 1;
    InitializePsychSound(EnableSoundLowLatencyMode);
    
    %设置音频声道数为2，即左右双声道立体声
    NumAudioChannel = 2;
    
    %PsyPortAudio('Start',...)语句执行后立刻开始播放声音
    AudioStartTime = 0;
    %等待声音真正播放后退出语句执行下面语句
    WaitUntilDeviceStart = 1;
    
    
    
    % 创建PortAudio对象，对应的参数如下
    % (1) [] ,调用默认的声卡
    % (2) 1 ,仅进行声音播放（不进行声音录制）
    % (3) 1 , 默认延迟模式
    % (4) SampleRateAudio,音频采样率
    % (5) 2 ,输出声道数为2
    HandlePortAudio = PsychPortAudio('Open', [], 1, EnableSoundLowLatencyMode,AudioSampleRate, NumAudioChannel);
    
    %播放音量设置
    PsychPortAudio('Volume', HandlePortAudio, AudioVolume);
    
    
    
%     %根据设置的难度确定选取图案的序号范围
%     PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
%     PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    
    [~, KeyCode,~] = KbWait([],0,GetSecs+TimeGapSilence);
    if KeyCode(KbName('ESCAPE'))
        %关闭PortAudio对象
        PsychPortAudio('Close');
        %恢复Matlab命令行窗口对键盘输入的响应
        ListenChar(0);
        %恢复KbCheck函数对所有键盘输入的响应
        RestrictKeysForKbCheck([]);
        sca;
        %终止程序
        return;
    end
    
    
    %标志当前是否需要跳至下一个图案
    FlagNext = true;
    %将初始图案序号归零
    SeqPattern = PatternRangeMin:PatternRangeMax;
    
    %进行第一次Flip以获取时间
    vbl = Screen('Flip', PointerWindow);
    %每次编码图案的序号
    iPattern = 0;
    
    while 1
        %如果FlagNext为真则跳至下一个图案
        if FlagNext ==true
            %             %将上一个图案序号保存于iPatternTemp中
            %             iPatternTemp = iPattern;
            %生成下一个图案的序号
            %如果是第一个图案
            if iPattern == 0 
                iPattern = PatternRangeMin;   
            elseif iPattern < PatternRangeMax && iPattern >= PatternRangeMin
                iPattern = iPattern + 1;
            elseif  iPattern == PatternRangeMax
                iPattern = PatternRangeMin;
            end
                
            
            FlagNext = false;
            %仅当前后两次的图案序号不同时读取声音和图案绘制数据
            %             if iPattern ~= iPatternTemp
            eval(['Pattern',num2str(iPattern)]);
            eval(['load Sound',num2str(iPattern),'.mat']);
            %             end
            
            
            PsychPortAudio('Stop', HandlePortAudio);
            
            %填充编码声音数据到PortAudio对象的Buffer中
            PsychPortAudio('FillBuffer', HandlePortAudio,[DataAudio,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
            %播放声音(除非被停止否则无限循环播放)
            PsychPortAudio('Start', HandlePortAudio, 0, AudioStartTime, WaitUntilDeviceStart);
            
        end
        
        
        %%
        %根据图案的序号对应不同的图案绘制方法
        if iPattern>=1 && iPattern<=16
            %每一段图案的绘制
            for iSeg =1:NumSeg
                %如果空格键按下则立刻停止绘图
                if FlagNext == true
                    break;
                end
                %每一帧图案的绘制
                for iFrame = 1:SegFrame(iSeg)
                    %每一个多边形的绘制
                    for iPolygon = 1:NumPolygon(iSeg)
                        Screen('FillPoly',PointerWindow,white,PolygonVertex{iSeg}(:,2*iPolygon-1:2*iPolygon,iFrame),1);
                    end
                    
                    %提示程序绘图已经完成
                    Screen('DrawingFinished', PointerWindow);
                    %将绘制的图形显示在屏幕上
                    vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
                    %读取键盘输入，若Esc键被按下则立刻退出程序
                    [IsKeyDown,~,KeyCode] = KbCheck;
                    if IsKeyDown && KeyCode(KbName('ESCAPE'))
                        %关闭PortAudio对象
                        PsychPortAudio('Close');
                        %恢复显示优先级
                        Priority(0);
                        %关闭所有窗口对象
                        sca;
                        %恢复键盘设定
                        %恢复Matlab命令行窗口对键盘输入的响应
                        ListenChar(0);
                        %恢复KbCheck函数对所有键盘输入的响应
                        RestrictKeysForKbCheck([]);
                        %终止程序
                        return;
                        %如果空格键按下则停止绘图跳至下一个图案
                    elseif IsKeyDown && KeyCode(KbName('space'))
                        %将跳转到下一个图案的标志变量置1
                        FlagNext = true;
                        
                        PsychPortAudio('Stop', HandlePortAudio);
                        %等待空格键松开
                        KbWait([],1);
                        break;
                    end
                end
                
            end
            
        elseif iPattern>=17 && iPattern<=20
            %每一段图案的绘制
            for iSeg =1:NumSeg
                
                if FlagNext == true
                    break;
                end
                %每一帧图案的绘制
                for iFrame = 1:SegFrame(iSeg)
                    %每一个多边形和扇形的绘制
                    if iSeg == NumSeg
                        Screen('FillArc',PointerWindow,ColorRoundOut,RectRoundOut,StartAngle,ArcAngle(iFrame));
                        Screen('FillArc',PointerWindow,ColorRoundIn,RectRoundIn,StartAngle,ArcAngle(iFrame));
                    end
                    
                    for iPolygon = 1:NumPolygon(iSeg)
                        Screen('FillPoly',PointerWindow,white,PolygonVertex{iSeg}(:,2*iPolygon-1:2*iPolygon,iFrame),1);
                    end
                    
                    
                    Screen('DrawingFinished', PointerWindow);
                    vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
                    %读取键盘输入，若Esc键被按下则立刻退出程序
                    [IsKeyDown,~,KeyCode] = KbCheck;
                    if IsKeyDown && KeyCode(KbName('ESCAPE'))
                        %关闭PortAudio对象
                        PsychPortAudio('Close');
                        %恢复显示优先级
                        Priority(0);
                        %关闭所有窗口对象
                        sca;
                        %恢复键盘设定
                        %恢复Matlab命令行窗口对键盘输入的响应
                        ListenChar(0);
                        %恢复KbCheck函数对所有键盘输入的响应
                        RestrictKeysForKbCheck([]);
                        %终止程序
                        return;
                    elseif IsKeyDown && KeyCode(KbName('space'))
                        
                        FlagNext = true;
                        
                        PsychPortAudio('Stop', HandlePortAudio);
                        %等待空格键松开
                        KbWait([],1);
                        break;
                        
                    end
                end
            end
            
        elseif iPattern>=21 && iPattern<=24
            %每一段图形的绘制
            for iSeg = 1:NumSeg
                
                if FlagNext == true
                    break;
                end
                %每一帧图形的绘制
                for iFrame = 1:SegFrame(iSeg)
                    %每一个扇形的绘制
                    for iArc = 1:NumArc(iSeg)
                        
                        Screen('FillArc',PointerWindow,ColorRoundOut,RectRoundOut{iSeg}(iArc,:),StartAngle(iSeg),ArcAngle{iSeg}(iArc,iFrame));
                        Screen('FillArc',PointerWindow,ColorRoundIn,RectRoundIn{iSeg}(iArc,:),StartAngle(iSeg),ArcAngle{iSeg}(iArc,iFrame));
                        
                    end
                    
                    
                    Screen('DrawingFinished', PointerWindow);
                    vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
                    
                    %读取键盘输入，若Esc键被按下则立刻退出程序
                    [IsKeyDown,~,KeyCode] = KbCheck;
                    if IsKeyDown && KeyCode(KbName('ESCAPE'))
                        %关闭PortAudio对象
                        PsychPortAudio('Close');
                        %恢复显示优先级
                        Priority(0);
                        %关闭所有窗口对象
                        sca;
                        %恢复键盘设定
                        %恢复Matlab命令行窗口对键盘输入的响应
                        ListenChar(0);
                        %恢复KbCheck函数对所有键盘输入的响应
                        RestrictKeysForKbCheck([]);
                        %终止程序
                        return;
                    elseif IsKeyDown && KeyCode(KbName('space'))
                        
                        FlagNext = true;
                        PsychPortAudio('Stop', HandlePortAudio);
                        %等待空格键松开
                        KbWait([],1);
                        
                        break;
                        
                    end
                end
            end
            
        end
        
        if FlagNext == false
            
            [~, KeyCode,~] = KbWait([],0,GetSecs+TimeGapSilence);
            if KeyCode(KbName('ESCAPE'))
                %关闭PortAudio对象
                PsychPortAudio('Close');
                %恢复显示优先级
                Priority(0);
                %关闭所有窗口对象
                sca;
                %恢复键盘设定
                %恢复Matlab命令行窗口对键盘输入的响应
                ListenChar(0);
                %恢复KbCheck函数对所有键盘输入的响应
                RestrictKeysForKbCheck([]);
                %终止程序
                return;
            elseif  KeyCode(KbName('space'))
                FlagNext = true;
                PsychPortAudio('Stop', HandlePortAudio);
                %等待空格键松开
                KbWait([],1);
            end
        end
        
    end
    
    
    %恢复Matlab命令行窗口对键盘输入的响应
    ListenChar(0);
    %恢复KbCheck函数对所有键盘输入的响应
    RestrictKeysForKbCheck([]);
    %关闭PsychPortAudio
    PsychPortAudio('Close');
    %关闭所有Psych窗口
    sca;
    %显示光标
    ShowCursor;
    
    
    
    %%
    %如果程序执行出错则执行下面程序
catch Error
    %关闭PsychPortAudio
    PsychPortAudio('Close');
    %关闭所有Psych窗口
    sca;
    %恢复Matlab命令行窗口对键盘输入的响应
    ListenChar(0);
    %恢复KbCheck函数对所有键盘输入的响应
    RestrictKeysForKbCheck([]);
    %显示光标
    ShowCursor;
    %在命令行输出错误的内容
    rethrow(Error);
    
end


