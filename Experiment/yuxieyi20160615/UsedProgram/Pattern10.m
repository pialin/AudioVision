%Pattern10

PatternVertex =...
    [0.1,0.1;
     0.1,0.9;
     0.9,0.1;
     0.9,0.9];
PatternVertex(:,1) = round(OriginX + PatternVertex(:,1)*SizeCanvas);
PatternVertex(:,2) = round(OriginY - PatternVertex(:,2)*SizeCanvas);


NumSeg = 3;
NumPolygon = [1,2,3];
NumPolygonVertex  = 4;
ColorPolygon = white;


SegLength = [0.8,0.8*sqrt(2),0.8];
SumTime = 3;
SegTime = SegLength/sum(SegLength)*SumTime;

SumFrame = round(SumTime*FramePerSecond);
SegFrame(1:NumSeg-1) = round(SegTime(1:NumSeg-1)*FramePerSecond);
SegFrame(NumSeg) = SumFrame - sum(SegFrame(1:NumSeg-1));

PolygonVertex =  ...
    {...
    zeros(NumPolygonVertex,NumPolygon(1)*2,SegFrame(1)),...
    zeros(NumPolygonVertex,NumPolygon(2)*2,SegFrame(2)),...
    zeros(NumPolygonVertex,NumPolygon(3)*2,SegFrame(3))...
    };


iSeg = 1;
%第一段

%初始4个顶点
PolygonVertexStart(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(1,2) = round(PatternVertex(iSeg,2) + PenWidth/2);

PolygonVertexStart(2,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(2,2) = round(PatternVertex(iSeg,2) + PenWidth/2);


PolygonVertexStart(3,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(3,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

PolygonVertexStart(4,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(4,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

%结束时4个顶点
PolygonVertexEnd(1,1) = PolygonVertexStart(1,1);
PolygonVertexEnd(1,2) = PolygonVertexStart(1,2);

PolygonVertexEnd(2,1) = PolygonVertexStart(2,1);
PolygonVertexEnd(2,2) = PolygonVertexStart(2,2);


PolygonVertexEnd(3,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(3,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2 + PenWidth);

PolygonVertexEnd(4,1) = round(PatternVertex(iSeg+1,1) - PenWidth/2);
PolygonVertexEnd(4,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2);


if iSeg > 1
    PolygonVertex{iSeg}(:,1:2*(iSeg-1),:) = repmat(PolygonVertex{iSeg-1}(:,:,end),[1,1,SegFrame(iSeg)]);
end

PolygonVertex{iSeg}(1,2*iSeg-1,:)=round(linspace(PolygonVertexStart(1,1),PolygonVertexEnd(1,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(1,2*iSeg  ,:)=round(linspace(PolygonVertexStart(1,2),PolygonVertexEnd(1,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(2,2*iSeg-1,:)=round(linspace(PolygonVertexStart(2,1),PolygonVertexEnd(2,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(2,2*iSeg  ,:)=round(linspace(PolygonVertexStart(2,2),PolygonVertexEnd(2,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(3,2*iSeg-1,:)=round(linspace(PolygonVertexStart(3,1),PolygonVertexEnd(3,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(3,2*iSeg  ,:)=round(linspace(PolygonVertexStart(3,2),PolygonVertexEnd(3,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(4,2*iSeg-1,:)=round(linspace(PolygonVertexStart(4,1),PolygonVertexEnd(4,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(4,2*iSeg  ,:)=round(linspace(PolygonVertexStart(4,2),PolygonVertexEnd(4,2),SegFrame(iSeg)));

%第二段

iSeg = iSeg + 1;


%初始4个顶点
PolygonVertexStart(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(1,2) = round(PatternVertex(iSeg,2) + PenWidth/2 + PenWidth*(sqrt(2)-1));

PolygonVertexStart(2,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(2,2) = round(PatternVertex(iSeg,2) - PenWidth/2);


PolygonVertexStart(3,1) = round(PatternVertex(iSeg,1) + PenWidth/2 );
PolygonVertexStart(3,2) = round(PatternVertex(iSeg,2) - PenWidth/2 + PenWidth);

PolygonVertexStart(4,1) = round(PatternVertex(iSeg,1) + PenWidth/2 );
PolygonVertexStart(4,2) = round(PatternVertex(iSeg,2) + PenWidth/2 + PenWidth*sqrt(2));

%结束时4个顶点
PolygonVertexEnd(1,1) = PolygonVertexStart(1,1);
PolygonVertexEnd(1,2) = PolygonVertexStart(1,2);

PolygonVertexEnd(2,1) = PolygonVertexStart(2,1);
PolygonVertexEnd(2,2) = PolygonVertexStart(2,2);


PolygonVertexEnd(3,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2 );
PolygonVertexEnd(3,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2 - PenWidth*(sqrt(2)-1));

PolygonVertexEnd(4,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(4,2) = round(PatternVertex(iSeg+1,2) + PenWidth/2);

if iSeg > 1
    PolygonVertex{iSeg}(:,1:2*(iSeg-1),:) = repmat(PolygonVertex{iSeg-1}(:,:,end),[1,1,SegFrame(iSeg)]);
end

PolygonVertex{iSeg}(1,2*iSeg-1,:)=round(linspace(PolygonVertexStart(1,1),PolygonVertexEnd(1,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(1,2*iSeg  ,:)=round(linspace(PolygonVertexStart(1,2),PolygonVertexEnd(1,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(2,2*iSeg-1,:)=round(linspace(PolygonVertexStart(2,1),PolygonVertexEnd(2,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(2,2*iSeg  ,:)=round(linspace(PolygonVertexStart(2,2),PolygonVertexEnd(2,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(3,2*iSeg-1,:)=round(linspace(PolygonVertexStart(3,1),PolygonVertexEnd(3,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(3,2*iSeg  ,:)=round(linspace(PolygonVertexStart(3,2),PolygonVertexEnd(3,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(4,2*iSeg-1,:)=round(linspace(PolygonVertexStart(4,1),PolygonVertexEnd(4,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(4,2*iSeg  ,:)=round(linspace(PolygonVertexStart(4,2),PolygonVertexEnd(4,2),SegFrame(iSeg)));


%第3段
iSeg = iSeg + 1;


%初始4个顶点
PolygonVertexStart(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(1,2) = round(PatternVertex(iSeg,2) + PenWidth/2 - PenWidth);

PolygonVertexStart(2,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(2,2) = round(PatternVertex(iSeg,2) + PenWidth/2);


PolygonVertexStart(3,1) = round(PatternVertex(iSeg,1) + PenWidth/2 );
PolygonVertexStart(3,2) = round(PatternVertex(iSeg,2) - PenWidth/2  - PenWidth*(sqrt(2)-1));

PolygonVertexStart(4,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(4,2) = round(PatternVertex(iSeg,2) - PenWidth/2 - PenWidth*sqrt(2) );

%结束时4个顶点
PolygonVertexEnd(1,1) = PolygonVertexStart(1,1);
PolygonVertexEnd(1,2) = PolygonVertexStart(1,2);

PolygonVertexEnd(2,1) = PolygonVertexStart(2,1);
PolygonVertexEnd(2,2) = PolygonVertexStart(2,2);


PolygonVertexEnd(3,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(3,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2);

PolygonVertexEnd(4,1) = round(PatternVertex(iSeg+1,1) - PenWidth/2);
PolygonVertexEnd(4,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2);

if iSeg > 1
    PolygonVertex{iSeg}(:,1:2*(iSeg-1),:) = repmat(PolygonVertex{iSeg-1}(:,:,end),[1,1,SegFrame(iSeg)]);
end

PolygonVertex{iSeg}(1,2*iSeg-1,:)=round(linspace(PolygonVertexStart(1,1),PolygonVertexEnd(1,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(1,2*iSeg  ,:)=round(linspace(PolygonVertexStart(1,2),PolygonVertexEnd(1,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(2,2*iSeg-1,:)=round(linspace(PolygonVertexStart(2,1),PolygonVertexEnd(2,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(2,2*iSeg  ,:)=round(linspace(PolygonVertexStart(2,2),PolygonVertexEnd(2,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(3,2*iSeg-1,:)=round(linspace(PolygonVertexStart(3,1),PolygonVertexEnd(3,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(3,2*iSeg  ,:)=round(linspace(PolygonVertexStart(3,2),PolygonVertexEnd(3,2),SegFrame(iSeg)));
PolygonVertex{iSeg}(4,2*iSeg-1,:)=round(linspace(PolygonVertexStart(4,1),PolygonVertexEnd(4,1),SegFrame(iSeg)));
PolygonVertex{iSeg}(4,2*iSeg  ,:)=round(linspace(PolygonVertexStart(4,2),PolygonVertexEnd(4,2),SegFrame(iSeg)));




