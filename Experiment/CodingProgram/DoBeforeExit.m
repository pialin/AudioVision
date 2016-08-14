function DoBeforeExit()

%恢复显示优先级
Priority(0);
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

if any(strfind(path,[pwd,filesep,'lpt',pathsep]))
    rmpath([pwd,filesep,'lpt']);
end
end

