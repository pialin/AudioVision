function AnswerCheck(SubjectName)
%%
%�ر����л�ͼ���ڲ�������б���
close all;
% clear;
%�ر��Ѿ��򿪵�Psych����
sca;


%��ʾ��������
%ִ��Ĭ������2
%�൱��ִ��������������䣺
%��AssertOpenGL;�� ȷ��Screen��������ȷ��װ
%��KbName('UnifyKeyNames');�� ����һ�����������в���ϵͳ��ͳһ��KeyCode�������룩��KeyName������������(MacOS-X),ʹ�á� KbName('KeyNamesOSX')���鿴
%�ڴ������ں�����ִ�С�Screen('ColorRange', PointerWindow, 1, [],1);������ɫ���趨��ʽ��3��8λ�޷���������ɵ���ά�����ĳ�3��0��1�ĸ�������ά������Ŀ����Ϊ��ͬʱ���ݲ�ͬ��ɫλ������ʾ��������8λ��16λ��ʾ����
PsychDefaultSetup(2);

%������Ӧ����
%Matlab�����д���ֹͣ��Ӧ�����ַ����루��Crtl+C����ȡ����һ״̬��
ListenChar(2);

%����KbCheck��Ӧ�İ�����Χ��ֻ��Esc��space�����Դ���KbCheck��
RestrictKeysForKbCheck(KbName('ESCAPE'));


%��ȡ������ʾ�������
AllScreenNumber = Screen('Screens');
%ȡ������ʾ����ţ����������ʾ������֤���ַ�ʽ���õ���ʾ��Ϊ�����ʾ��
ScreenNumber = max(AllScreenNumber);

%��ȡ�ڰ׶�Ӧ����ɫ�趨ֵ���ݴ˼�������һЩ��ɫ���趨ֵ
white = WhiteIndex(ScreenNumber);
black = BlackIndex(ScreenNumber);


try
    
    %����һ�����ڶ��󣬷��ض���ָ��PointerWindow,���������������½����ڵı���ɫΪ��ɫ
    PointerWindow = PsychImaging('OpenWindow', ScreenNumber, white);
    
    
    
    %��ȡ���õ���Ļ��ʾ���ȼ�����
    LevelTopPriority = MaxPriority(PointerWindow,'KbWait');
    
    %������ʾ���ȼ�
    Priority( LevelTopPriority);
    
    %��ȡ��Ļ�ֱ��� SizeScreenX,SizeScreenY�ֱ�ָ���������ķֱ���
    [SizeScreenX, SizeScreenY] = Screen('WindowSize', PointerWindow);
    
    ContentList = dir([pwd,filesep,'RecordFile',filesep,SubjectName,filesep]);
    
    RecordList = ContentList(~[ContentList.isdir]);
    
    [~,IndexClosestRecord] = min(abs([RecordList.datenum]-now));
    
    load([pwd,filesep,'RecordFile',filesep,SubjectName,filesep,RecordList(IndexClosestRecord).name]);
    
    NumPattern = numel(PatternHeard);
    
    NumRow = 3;%��ʾ3��
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
    
    %�ȴ�����
    KbWait([],0);
    
    
    
    
    %�ָ���ʾ���ȼ�
    Priority(0);
    %�ر�����Psych����
    sca;
    %�ָ�Matlab�����д��ڶԼ����������Ӧ
    ListenChar(0);
    %�ָ�KbCheck���������м����������Ӧ
    RestrictKeysForKbCheck([]);
    
    
    
    
    
catch Error
    
    
    %�ָ���ʾ���ȼ�
    Priority(0);
    %�ر�����Psych����
    sca;
    %�ָ�Matlab�����д��ڶԼ����������Ӧ
    ListenChar(0);
    %�ָ�KbCheck���������м����������Ӧ
    RestrictKeysForKbCheck([]);
    
    
    %�������������������
    rethrow(Error);
    
end
end
