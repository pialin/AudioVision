%Process�ű���������

%1.�زο�����ѡ��(��3��)
%'Mastoid'  ˫����ͻ�ο�(Ĭ��)
%'CAR'      ��ƽ���ο�
%����������ʽ    ����������ʽ���ҵ�����Ϊ�ο�
RereferenceChannel = 'Mastoid';

%2.�Ƿ�����˲�����(��4��)
%�����˲���Ϊ40Hz��ͨ�Լ�50Hz�ݲ��˲���
%'No'   ��Ĭ�ϣ�
%'Yes'  ��
FilterOrNot = 'No';

%3.ѡ���ע��Trial����(��6��)
%Sound      ���������������ݶ�(Ĭ��)
%Silence    ���������ݶ�
%Noise      ���������ݶ�
TrialOfInterest = 'Noise';

%3.��������ȥ����Щα��(��7��)
%'Blink'    գ��
%'EyeMove'  ˮƽ�۶�
%'Other'    ����α��
RejectArtifact = {'Other'};

%4.ȥ������Ͻ���(��8��,Ĭ��Ϊ3)
BaselineOrder = 3;

%5.�Ƿ񱣴�ΪLoreta��ʽ�ļ�(��9��)
%'No'   ��Ĭ�ϣ�
%'Yes'  ��
SaveLoretaOrNot = 'Yes';

%6.�Ƿ����Ƶ�����
%'Yes'  �ǣ�Ĭ�ϣ�
%'No'   ��
FreqAnalysis = 'Yes';

%6.�Ƿ����С��ʱƵ����
%'No'   ��Ĭ�ϣ�
%'Yes'  ��
TimeFreqAnalysis = 'no';

%7.С��ʱƵ����Ƶ��
WaveletfreqRange = [8,12];
