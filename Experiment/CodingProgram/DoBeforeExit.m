function DoBeforeExit()

%�ָ���ʾ���ȼ�
Priority(0);
%�ر�PsychPortAudio
PsychPortAudio('Close');
%�ر�����Psych����
sca;
%�ָ�Matlab�����д��ڶԼ����������Ӧ
ListenChar(0);
%�ָ�KbCheck���������м����������Ӧ
RestrictKeysForKbCheck([]);

%��ʾ���
ShowCursor;

if any(strfind(path,[pwd,filesep,'lpt',pathsep]))
    rmpath([pwd,filesep,'lpt']);
end
end

