function AnswerCheck(SubjectName)
%%
%关闭所有绘图窗口并清除所有变量
close all;
% clear;
%关闭已经打开的Psych窗口
sca;


%显示部分设置
%执行默认设置2
%相当于执行了以下三条语句：
%“AssertOpenGL;” 确保Screen函数被正确安装
%“KbName('UnifyKeyNames');” 设置一套适用于所有操作系统的统一的KeyCode（按键码）和KeyName（按键名）对(MacOS-X),使用“ KbName('KeyNamesOSX')”查看
%在创建窗口后立刻执行“Screen('ColorRange', PointerWindow, 1, [],1);”将颜色的设定方式由3个8位无符号整数组成的三维向量改成3个0到1的浮点数三维向量，目的是为了同时兼容不同颜色位数的显示器（比如8位和16位显示器）
PsychDefaultSetup(2);

%键盘响应设置
%Matlab命令行窗口停止响应键盘字符输入（按Crtl+C可以取消这一状态）
ListenChar(2);

%限制KbCheck响应的按键范围（只有Esc及space键可以触发KbCheck）
RestrictKeysForKbCheck(KbName('ESCAPE'));


%获取所有显示器的序号
AllScreenNumber = Screen('Screens');
%取最大的显示器序号：若有外接显示器，保证呈现范式所用的显示器为外接显示器
ScreenNumber = max(AllScreenNumber);

%获取黑白对应的颜色设定值并据此计算其他一些颜色的设定值
white = WhiteIndex(ScreenNumber);
black = BlackIndex(ScreenNumber);


try
    
    %创建一个窗口对象，返回对象指针PointerWindow,第三个参数设置新建窗口的背景色为白色
    PointerWindow = PsychImaging('OpenWindow', ScreenNumber, white);
    
    
    
    %获取可用的屏幕显示优先级？？
    LevelTopPriority = MaxPriority(PointerWindow,'KbWait');
    
    %设置显示优先级
    Priority( LevelTopPriority);
    
    %获取屏幕分辨率 SizeScreenX,SizeScreenY分别指横向和纵向的分辨率
    [SizeScreenX, SizeScreenY] = Screen('WindowSize', PointerWindow);
    
    ContentList = dir([pwd,filesep,'RecordFile',filesep,SubjectName,filesep]);
    
    RecordList = ContentList(~[ContentList.isdir]);
    
    [~,IndexClosestRecord] = min(abs([RecordList.datenum]-now));
    
    load([pwd,filesep,'RecordFile',filesep,SubjectName,filesep,RecordList(IndexClosestRecord).name]);
    
    NumPattern = numel(PatternHeard);
    
    NumRow = 3;%显示3行
    NumColumn = ceil(NumPattern/NumRow);
    
    PosX = linspace(-1,1,2*NumColumn+1);
    PosY = linspace(-1,1,2*NumRow+1);
    
    [PosX,PosY] = meshgrid(PosX(2:2:end),PosY(2:2:end));
    
    PosX = round(PosX * SizeScreenX/2 + SizeScreenX/2);
    
    PosY = round(PosY * SizeScreenY/2 + SizeScreenY/2);
    
    PosX = PosX';
    PosY = PosY';
    
    ImageSize = fix(min(SizeScreenX/(NumColumn+2)*0.9,SizeScreenY/(NumRow+2)*0.9));
    
    BaseRect = [0,0,ImageSize,ImageSize];
    
    ImageRange = CenterRectOnPointd(BaseRect,PosX(:),PosY(:));
    
    
    
    % Here we load in an image from file. This one is a image of rabbits that
    % is included with PTB
    ImageFolder = [pwd,filesep,'PatternPicture',filesep];
    
    for iImage = 1:NumPattern 
        Image = imread([ImageFolder,num2str(PatternHeard(iImage)),'.bmp']);
        % Make the image into a texture
        Texture = Screen('MakeTexture', PointerWindow, Image);
        % Draw the image to the screen, unless otherwise specified PTB will draw
        % the texture full size in the center of the screen. We first draw the
        % image in its correct orientation.
        Screen('DrawTexture', PointerWindow, Texture, [], ImageRange(iImage,:), 0);
        
    end
    
    
    
    % Flip to the screen
    Screen('Flip', PointerWindow);
    
    %等待按键
    KbWait([],0);
    
    
    
    
    %恢复显示优先级
    Priority(0);
    %关闭所有Psych窗口
    sca;
    %恢复Matlab命令行窗口对键盘输入的响应
    ListenChar(0);
    %恢复KbCheck函数对所有键盘输入的响应
    RestrictKeysForKbCheck([]);
    
    
    
    
    
catch Error
    
    
    %恢复显示优先级
    Priority(0);
    %关闭所有Psych窗口
    sca;
    %恢复Matlab命令行窗口对键盘输入的响应
    ListenChar(0);
    %恢复KbCheck函数对所有键盘输入的响应
    RestrictKeysForKbCheck([]);
    
    
    %在命令行输出错误内容
    rethrow(Error);
    
end
end
