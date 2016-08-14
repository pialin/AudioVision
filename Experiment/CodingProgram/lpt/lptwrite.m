function lptwrite(LptAddress,LabelNumber)
if LabelNumber == 0
    disp(['Parallel port status has been reset.','(time:',num2str(GetSecs,'%.4f'),'s)']);
else
    disp(['       Label ' num2str(LabelNumber,'%03d'),' -> LPT',num2str(LptAddress),'        (time:',num2str(GetSecs,'%.4f'),'s)']);
end

end
