%Process脚本参数配置

%1.重参考导联选择(第3步)
%'Mastoid'  双侧乳突参考(默认)
%'CAR'      共平均参考
%其他正则表达式    根据正则表达式查找导联作为参考
RereferenceChannel = 'Mastoid';

%2.是否进行滤波操作(第4步)
%具体滤波器为40Hz低通以及50Hz陷波滤波器
%'No'   否（默认）
%'Yes'  是
FilterOrNot = 'No';

%3.选择关注的Trial类型(第6步)
%Sound      听编码声音的数据段(默认)
%Silence    无声的数据段
%Noise      白噪声数据段
TrialOfInterest = 'Noise';

%3.从数据中去除哪些伪迹(第7步)
%'Blink'    眨眼
%'EyeMove'  水平眼动
%'Other'    其他伪迹
RejectArtifact = {'Other'};

%4.去基线拟合阶数(第8步,默认为3)
BaselineOrder = 3;

%5.是否保存为Loreta格式文件(第9步)
%'No'   否（默认）
%'Yes'  是
SaveLoretaOrNot = 'Yes';

%6.是否进行频域分析
%'Yes'  是（默认）
%'No'   否
FreqAnalysis = 'Yes';

%6.是否进行小波时频分析
%'No'   否（默认）
%'Yes'  是
TimeFreqAnalysis = 'no';

%7.小波时频分析频段
WaveletfreqRange = [8,12];
