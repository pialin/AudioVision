%此程序为正式实验程序
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



%修改工作路径至当前M文件所在目录
Path=mfilename('fullpath');
[Folder,FileName,FileExtension] = fileparts(Path);
cd(Folder);

%从输入对话框获取受试者名字

InputdlgOptions.Resize = 'on';
InputdlgOptions.WindowStyle = 'normal';

%检查是否有上一位受试名称的记录
if exist('LastSubjectName.mat','file')
    %如果有则默认沿用该受试名称(可修改)
    load LastSubjectName.mat;
    SubjectName = inputdlg('Subject Name:','请输入受试者名字',[1,42],{LastSubjectName},InputdlgOptions);
else
    %如果没有则将默认名称设置为'ABC'
    SubjectName = inputdlg('Subject Name:','请输入受试者名字',[1,42],{'ABC'},InputdlgOptions);
end

%如果对话框没有返回值则提示错误并退出程序
if isempty(SubjectName)
    errordlg('受试名称不能为空！','参数错误');
    return;
end

%存储本次输入的名字作为后续实验受试名称的默认值
LastSubjectName = SubjectName{1};

save LastSubjectName.mat LastSubjectName;

%获取含实验开始时间的格式字符串
DateString = datestr(now,'yyyymmdd_HH-MM-SS');



%记录文件路径
RecordPath = ['.',filesep,'RecordFile',filesep,SubjectName{1}];
%如果路径不存在则新建相应的路径
if ~exist(RecordPath,'dir')
    mkdir(RecordPath);
end
%记录文件名
RecordFile = [RecordPath,filesep,DateString,'.mat'];



IsLptwriteExist = isempty(which('lptwrite'));

if ~IsLptwriteExist
    addpath([pwd,filesep,'lpt']);
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
%Matlab命令行窗口停止响应键盘字符输入（按Crtl+C可以取消这一状态）
ListenChar(2);

%限制KbCheck响应的按键范围（只有Esc及space键可以触发KbCheck）
RestrictKeysForKbCheck([KbName('ESCAPE'),KbName('space')]);


%获取所有显示器的序号
AllScreen = Screen('Screens');
%取最大的显示器序号：若有外接显示器，保证呈现范式所用的显示器为外接显示器
ScreenNumber = max(AllScreen);

%获取黑白对应的颜色设定值并据此计算其他一些颜色的设定值
white = WhiteIndex(ScreenNumber);
black = BlackIndex(ScreenNumber);

%运行可能用到的mex函数以节省后续调用时间
GetSecs;
WaitSecs(0.1);
KbWait([],1);

%隐藏光标
HideCursor;

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
    LevelTopPriority = MaxPriority(PointerWindow,'KbCheck','KbWait','GetSecs');
    
    %设置显示优先级
    Priority( LevelTopPriority);
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
    %%
    %白噪声生成
    
    %高斯白噪声数据生成
    %     DataWhiteNoise = wgn(2,round(TimeWhiteNoise*AudioSampleRate),PowerWhiteNoise);
    DataWhiteNoise = randn(2,round(TimeWhiteNoise*AudioSampleRate));
    %归一化并降低幅度(避免白噪声音量过大)
    DataWhiteNoise = DataWhiteNoise/max(abs(DataWhiteNoise(:)))*0.4;
    
    %淡入淡出（正弦规律幅度调制）
    
    %淡入淡出点数设置
    NumPointFadeIn = 1000;
    NumPointFadeOut = 1000;
    
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
    
    %将正弦幅度调制函数和白噪声开头和结尾的数据相乘
    DataWhiteNoise(:,1:NumPointFadeIn)=DataWhiteNoise(:,1:NumPointFadeIn).*repmat(AmpFadeIn,2,1);
    
    DataWhiteNoise(:,end-NumPointFadeIn+1:end)=DataWhiteNoise(:,end-NumPointFadeIn+1:end).*repmat(AmpFadeOut,2,1);
    
    %新建一个buffer用于存放白噪声数据
    HandleWhiteNoiseBuffer = PsychPortAudio('CreateBuffer',HandlePortAudio,DataWhiteNoise);
    %         [DataWhiteNoise,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
    
    
    
    %%
    %生成提示音
    
    %计算提示音(三声连续纯音)数据
    
    t = linspace(0,TimeHintSound/6,round(TimeHintSound/6*AudioSampleRate));
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
    
    
    DataHintSound = repmat([DataHintSound,zeros(1,TimeHintSound/6*AudioSampleRate)],1,3);
    
    PsychPortAudio('Stop', HandlePortAudio);
    
    %将提示音填充到PortAudio对象的Buffer中
    PsychPortAudio('FillBuffer', HandlePortAudio,repmat(DataHintSound,2,1));
    %播放提示音
    PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
    
    %等待键盘输入，提示音播放完毕自动跳过等待
    [~, KeyCode,~] = KbWait([],0,GetSecs+TimeHintSound);
    %如果Esc键被按下
    if KeyCode(KbName('ESCAPE'))
        %并口标记253表示实验因Esc键被按下而提前结束
        lptwrite(LptAddress,253);
        %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
        WaitSecs(0.1);
        %将并口置0
        lptwrite(LptAddress,0);
        
        DoBeforeExit();
        %终止程序
        return;
    end
    
    %停止提示音播放
    PsychPortAudio('Stop', HandlePortAudio);
    
    %根据设置的难度确定选取图案的序号范围
    PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    %获取当前Run的图案序列
    iPattern = randi([PatternRangeMin,PatternRangeMax],1,NumTrial);
    
    
    %将iTrial计数值归零
    iTrial = 0;
    
    %并口标记251表示实验开始
    lptwrite(LptAddress,251);
    %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
    WaitSecs(0.1);
    %将并口置0
    lptwrite(LptAddress,0);
    
    
    %进行第一次Flip以获取当前时间
    vbl = Screen('Flip', PointerWindow);
    
    FlagFinish = false;
    
    while  iTrial < NumTrial
        
        PatternHeard = iPattern(1:iTrial);
        %存储的变量
        save(RecordFile,'PatternHeard','FlagFinish');
        
        %Trial计数器加一
        iTrial = iTrial + 1;
        %当第一个Trial或者本次图案与上次不同时才读取声音和图案的绘图数据
        %         if iTrial == 1 ||(iTrial >1 && iPattern(iTrial-1) ~= iPattern(iTrial))
        eval(['Pattern',num2str(iPattern(iTrial))]);
        eval(['load Sound',num2str(iPattern(iTrial)),'.mat']);
        %         end
        PsychPortAudio('Stop', HandlePortAudio);
        %填充白噪声到PortAudio对象的Buffer中
        PsychPortAudio('FillBuffer', HandlePortAudio,HandleWhiteNoiseBuffer);
        %播放声音
        PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
        NoiseStartTime = GetSecs;
        %并口标记250表示开始Trial开始(高斯->无声->编码声音->无声->编码声音->无声...)
        lptwrite(LptAddress,250);
        %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
        WaitSecs(0.1);
        %将并口置0
        lptwrite(LptAddress,0);
        
        %等待键盘输入
        [~, KeyCode,~] = KbWait([],0,NoiseStartTime+TimeWhiteNoise+TimeGapSilence);
        %如果Esc键被按下
        if KeyCode(KbName('ESCAPE'))
            %并口标记253表示实验因Esc键被按下而提前结束
            lptwrite(LptAddress,253);
            %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
            WaitSecs(0.1);
            %将并口置0
            lptwrite(LptAddress,0);
            
            DoBeforeExit();
            %终止程序
            return;
            
            %如果空格键被按下则跳转至下一个图案
        elseif KeyCode(KbName('space'))
            
            %并口标记252表示实验跳转至下一个图案
            lptwrite(LptAddress,252);
            %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
            WaitSecs(0.1);
            %将并口置0
            lptwrite(LptAddress,0);
            PsychPortAudio('Stop', HandlePortAudio);
            %等待空格键松开
            KbWait([],1);
            
            %为了避免连续多次按键触发先等待一段时间再（1秒）
            WaitSecs(1);
            
            %等待按键再次按下（记录完毕）
            [~, KeyCode,~] = KbWait([],0);
            
            if KeyCode(KbName('ESCAPE'))
                
                %并口标记253表示实验因Esc键被按下而提前结束
                lptwrite(LptAddress,253);
                %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
                WaitSecs(0.1);
                %将并口置0
                lptwrite(LptAddress,0);
                
                DoBeforeExit();
                
                %终止程序
                return;
            end
            
            %等待空格键松开
            KbWait([],1);
            
            %跳至下一个while循环
            continue;
        end
        
        PsychPortAudio('Stop', HandlePortAudio);
        %填充编码声音数据到PortAudio对象的Buffer中
        PsychPortAudio('FillBuffer', HandlePortAudio,...
            [DataAudio,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
        %播放声音
        PsychPortAudio('Start', HandlePortAudio, 0, AudioStartTime, WaitUntilDeviceStart);
        
        %并口标记表示编码声音开始播放
        lptwrite(LptAddress,mod(iPattern(iTrial)-1,200)+1);
        %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
        WaitSecs(0.1);
        %将并口置0
        lptwrite(LptAddress,0);
        
        
        %等待直到ESC键被按下（退出实验）或者空格键被按下（跳转至下一个图案）
        [~, KeyCode,~] = KbWait([],0);
        %如果ESC键被按下
        if KeyCode(KbName('ESCAPE'))
            
            %并口标记253表示实验因Esc键被按下而提前结束
            lptwrite(LptAddress,253);
            %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
            WaitSecs(0.1);
            %将并口置0
            lptwrite(LptAddress,0);
            
            DoBeforeExit();
            
            %终止程序
            return;
            %如果空格键被按下
        elseif KeyCode(KbName('space'))
            %并口标记252表示实验跳转至下一个图案
            lptwrite(LptAddress,252);
            %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
            WaitSecs(0.1);
            %将并口置0
            lptwrite(LptAddress,0);
            PsychPortAudio('Stop', HandlePortAudio);
            
            
            %等待空格键松开
            KbWait([],1);
            
            %为了避免连续多次按键触发先等待一段时间再（1秒）
            WaitSecs(1);
            
            %等待按键再次按下（记录完毕）
            [~, KeyCode,~] = KbWait([],0);
            
            if KeyCode(KbName('ESCAPE'))
                
                %并口标记253表示实验因Esc键被按下而提前结束
                lptwrite(LptAddress,253);
                %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
                WaitSecs(0.1);
                %将并口置0
                lptwrite(LptAddress,0);
                
                DoBeforeExit();
                
                %终止程序
                return;
            end
            
            %等待空格键松开
            KbWait([],1);
            
            %跳至下一个while循环
            continue;
        end
    
    end
    
    
    %并口标记254表示实验正常结束
    lptwrite(LptAddress,254);
    %将并口状态保持一段时间（时长不低于NeuroScan的采样时间间隔）
    WaitSecs(0.1);
    %将并口置0
    lptwrite(LptAddress,0);
    
    %%
    FlagFinish = true;
    PatternHeard = iPattern(1:iTrial);
    %存储的变量
    save(RecordFile,'PatternHeard','FlagFinish');

    %答案校对
    AnswerCheck(SubjectName{1});
    
    DoBeforeExit();
    
    %%
    %如果程序执行出错则执行下面程序
catch Error
    
    DoBeforeExit();
    
    %在命令行输出错误内容
    rethrow(Error);
    
end


