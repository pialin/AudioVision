function DispProgress(Progress)
if Progress<0 || Progress>1
    error('Ilegal Input Progress(should be a number between 0 and 1!)') 
end

persistent CursorPos;
persistent ProgressPercent;
if isempty(CursorPos) || Progress == 0
    CursorPos = 0;
    ProgressPercent = 0;
%     fprintf('\n');
end

NumProgressBarChar = 50;

NumEqu = fix(Progress*NumProgressBarChar);%'='
NumGrater = (NumEqu < NumProgressBarChar)*1;%'>'
NumSpace = NumProgressBarChar - NumEqu - NumGrater;%' '

if ProgressPercent ~= fix(Progress*100)
fprintf(repmat('\b',1,CursorPos));

CursorPos = fprintf(['[',repmat('=',1,NumEqu),repmat('>',NumGrater),repmat(' ',1,NumSpace),']',...
    repmat('-',1,4),'%3d%%'],fix(Progress*100));

 ProgressPercent =  fix(Progress*100);
end

if Progress == 1
    CursorPos = 0;
    ProgressPercent = 0;
    fprintf('\n');
end


end