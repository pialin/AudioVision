2016年07月25日
1.今天在搜索Loreta的时候发现了eegfmri的博客，http://blog.sina.com.cn/eegfmri 里面可以学到很多EEG溯源方面的知识吧
2.博客中http://blog.sina.com.cn/s/blog_60a751620100fy9g.html中提到了一种理解脑电的新角度 来自于一篇文献 Mining Event-Related Brain Dynamics 有时间好好看看
3.http://blog.sina.com.cn/s/blog_60a751620100gu22.html中比较了溯源的几种方法：ECD（BESA软件中） LORETA 还有 基于Bayes的源定位(SPM8)
Review on solving the inverse problem in EEG source analysis是一篇讨论这个问题的综述
4.http://blog.sina.com.cn/s/blog_60a7516201015m7q.html中提到了估计网络连接强度的方法 相干(coherence)，相位同步，延迟指数(phase lag index)，同步似然指数(synchronization likelihood) 还有博主觉得很巧妙的能量包络方法 
Hipp et al., 2012 Nature Neuroscience: Large-scale cortical correlation structure of spontaneous oscillatory activity
5.关于脑电信号的非线性
http://home.kpn.nl/stam7883/graph_introduction.html，
Van De Ville et al., 2010 PNAS： EEG microstate sequences in healthy humans at rest reveal scale-free dynamics
6.Nature脑连接特刊 The Heavily Connected Brain
Connection, Connection, Connection…
Reviews Cortical High-Density Counterstream Architectures
Structural and Functional Brain Networks: From Connections to Cognition
Functional Interactions as Big Data in the Human Brain
Predispositions and Plasticity in Music and Speech Learning: Neural Correlates and Implications

2016年8月6日
1.由fieldtrip教程 http://www.fieldtriptoolbox.org/tutorial/beamformingextended 得知 视觉区域可能存在40-70Hz的振荡，为保险起见改变滤波策略，对于从频域角度出发的处理的数据不作滤波处理（对50Hz工频也不作滤除）对于时域处理方向则采用40Hz低通以及50Hz陷波处理

2016年8月7日
1.Loreta的频带细分
delta:1.5-6Hz
theta:6.5-8Hz
alpha1:8.5-10Hz
alpha2:10.5-12Hz
beta1:12.5-18Hz
beta2:18.5-21Hz
beta3:21.5-30Hz
