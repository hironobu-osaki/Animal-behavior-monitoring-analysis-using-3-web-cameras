% function s = MouseDetectionTrackBall
clear;
if ispc
    [Fname, Pname] = uigetfile('D:\TrackBallMovie\*Combined.avi','MultiSelect','off');
elseif ismac
    [Fname, Pname] = uigetfile('/Users/moeko/Desktop/R139R140/*Combined.avi','MultiSelect','off');
end

tic;
fn = Fname;



AVIFileName = fullfile(Pname, fn);
Image = VideoReader(AVIFileName);
vidHeight = Image.Height;
vidWidth = Image.Width;
s = struct('Data', zeros(vidHeight,vidWidth, 1,'uint8'),'colormap',[]);
k = 1;
steps = Image.Duration*Image.FrameRate;

disp('Reading avi data...');
while hasFrame(Image)
    Data = readFrame(Image);
    s(k).Data = Data(:,:,1);
    k = k+1;
end

Ex=[75,100];
Ey=[45,70];

BaseImage = s(1).Data(70:95,75:180);%72:92,95:173)
BaseImageBall = s(1).Data(450:end,457:928);

disp(toc);
disp('             ... finished!');

for i = 1:steps
    LowerWhiskerLumiL = mean(mean(s(i).Data(110:150,1:80)));
    LowerWhiskerLumiR = mean(mean(s(i).Data(380:410,370:440)));
    
    EarL =s(i).Data(71:115,195:215);
    EarR =s(i).Data(341:380,240:255);
    
    EarLaxis = 1:(115-71);
    EarRaxis = 1:(380-341);
    
    EarLumidiffL = diff(mean(EarL,2));
    EarLumidiffR = diff(mean(EarR,2));
    
    EarPosiL = EarLaxis(EarLumidiffL==min(EarLumidiffL));
    if length(EarPosiL)>1
        EarPosiL = EarPosiL(1);
    end
    EarPosiR = EarRaxis(EarLumidiffR==min(EarLumidiffR));
    if length(EarPosiR)>1
        EarPosiR = EarPosiR(1);
    end
    
    EyeLumi = s(i).Data(Ey(1):Ey(2),Ex(1):Ex(2));
    EyeLumi = reshape(EyeLumi,[],1);
    s(i).EyeBlink = mean(topkrows(EyeLumi,50,'ascend'));
    LaserLumiC = s(i).Data(25:60,600:680);
    LaserLumi = mean(mean(topkrows(LaserLumiC,50)));

    ChR2LaserLumi = s(i).Data(119:139,705:750);
    ChR2LaserLumi = reshape(ChR2LaserLumi,[],1);
    
    ChR2LaserLumi = mean(topkrows(ChR2LaserLumi,50));
    s(i).Laser = LaserLumi;
    s(i).ChR2Laser = mean(mean(ChR2LaserLumi));
    s(i).BaseLumi = mean(mean(s(i).Data(18:54,192:289)));
    s(i).LowerWhiskLumi =mean([LowerWhiskerLumiL,LowerWhiskerLumiR]);
    s(i).EarPosiL = EarPosiL;
    s(i).EarPosiR = EarPosiR;
    
    Line = mean((s(i).Data(259:288,457:928)),1);
    Xaxis = 1:472;
    s(i).Position = mean(Xaxis(Line<110));
    
    if i>2
        BaseImageBall = s(i-1).Data(450:end,457:928);
        BaseImage = s(i-1).Data(70:95,75:180);
        BaseImageEye = s(i-1).Data(57:91,21:54);
    end
    Ball = s(i).Data(450:end,457:928);
    s(i).R_Ball = corr2(BaseImageBall, Ball);
    s(i).R = corr2(BaseImage, s(i).Data(70:95,75:180));
    
end

Laser = vertcat(s.Laser);
ChR2Laser = vertcat(s.ChR2Laser);
figure, plot(Laser, 'r-')
hold on
plot(ChR2Laser, 'b-')
LaserTh = round((256-mean(vertcat(s.Laser)))*0.6+mean(vertcat(s.Laser)));
ChR2Th = round((256-mean(vertcat(s.ChR2Laser)))*0.6+mean(vertcat(s.ChR2Laser)));
plot([0 length(Laser)],[LaserTh LaserTh], 'r-')
plot([0 length(Laser)],[ChR2Th ChR2Th], 'c-')

Laser(Laser<LaserTh)=0;
Laser(Laser>LaserTh)=200;
if Laser(1)==200
    Laser(1)=0;
end
LaserOnset = diff(Laser);
[~,LaserOnsetFrame] = findpeaks(LaserOnset,'MinPeakHeight',150,'MinPeakDistance',300);
LaserOnsetFrame = LaserOnsetFrame +1;
[~,LaserOffsetFrame] = findpeaks(-LaserOnset,'MinPeakHeight',150,'MinPeakDistance',300);
LaserOffsetFrame = LaserOffsetFrame +1;
DiffLaserOnset = diff(LaserOnsetFrame);
LaserDurationFrame = LaserOffsetFrame-LaserOnsetFrame;


ChR2Laser(ChR2Laser<ChR2Th)=0;
ChR2Laser(ChR2Laser>ChR2Th)=200;
if ChR2Laser(1)==200
    ChR2Laser(1)=0;
end
ChR2LaserOnset = diff(ChR2Laser);
[~,ChR2LaserOnsetFrame] = findpeaks(ChR2LaserOnset,'MinPeakHeight',150);
ChR2LaserOnsetFrame = ChR2LaserOnsetFrame+1;
%     LaserOnsetFrame(2:end+1)=LaserOnsetFrame;
%     LaserOnsetFrame(1)=1;
[~,ChR2LaserOffsetFrame] = findpeaks(-ChR2LaserOnset,'MinPeakHeight',150);
ChR2LaserOffsetFrame = ChR2LaserOffsetFrame+1;
if ChR2Laser(end)==200
    ChR2LaserOnsetFrame(end) = [];
end
ChR2LaserDurationFrame = ChR2LaserOffsetFrame-ChR2LaserOnsetFrame;
ChR2LaserOnsetFrame(ChR2LaserDurationFrame > 60) = [];
ChR2LaserOffsetFrame(ChR2LaserDurationFrame > 60) = [];
ChR2LaserDurationFrame(ChR2LaserDurationFrame > 60) = [];
ChR2LaserOnsetFrame(ChR2LaserDurationFrame < 25) = [];
ChR2LaserOffsetFrame(ChR2LaserDurationFrame < 25) = [];
ChR2LaserDurationFrame(ChR2LaserDurationFrame < 25) = [];
ChR2Laser = zeros(length(ChR2Laser),1);
for kk = 1:length(ChR2LaserDurationFrame)
    ChR2Laser(ChR2LaserOnsetFrame(kk):ChR2LaserOffsetFrame(kk))=200;
end

ChR2orIR_Laser= ChR2Laser+Laser;
ChR2orIR_Laser(ChR2orIR_Laser>1)=1;
ChR2orIR_LaserOnset = diff(ChR2orIR_Laser);
ChR2orIR_LaserOnsetFrame = find(ChR2orIR_LaserOnset==1)+1;
if length(ChR2orIR_LaserOnsetFrame)==31
    ChR2orIR_LaserOnsetFrame(31) = [];
end
% ChR2LaserdurationとIRlaserdurationを対応づけ
ID_ChR2 = knnsearch(ChR2orIR_LaserOnsetFrame,ChR2LaserOnsetFrame);%ChR2orIR_LaserOnsetに最も近いChR2LaserOnsetを見つける
ID_IR = knnsearch(ChR2orIR_LaserOnsetFrame,LaserOnsetFrame);%ChR2orIR_LaserOnsetに最も近いIRLaserOnsetを見つける


ChR2orIR_LaserDurationFrame = zeros(length(ChR2orIR_LaserOnsetFrame),2);
ChR2orIR_LaserDurationFrame(ID_IR,1) = LaserDurationFrame;
ChR2orIR_LaserDurationFrame(ID_ChR2,2) = 1;
[~,index] = sortrows(ChR2orIR_LaserDurationFrame, [2 1]);
ChR2orIR_LaserDurationFrame(ID_ChR2,2) = ChR2LaserDurationFrame;


Positions =vertcat(s.Position);

d1 = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',0.05,'HalfPowerFrequency2',0.6,'DesignMethod','butter');
dLowpass = designfilt('lowpassiir','FilterOrder',12, ...
    'HalfPowerFrequency',0.01,'DesignMethod','butter');
RawEyeBlink = filtfilt(d1,vertcat(s.EyeBlink));
RawEyeTightening = filtfilt(dLowpass,vertcat(s.EyeBlink));

EyeBlink = RawEyeBlink;
EyeThr = 4;
EyeBlink(EyeBlink < 4) = 0;
EyeBlink(EyeBlink > 4) = 1;
for p =1:length(LaserOffsetFrame)
    EyeBlink(LaserOffsetFrame(p):LaserOffsetFrame(p)+10) =0;    %remove exposer time changing frame
end


Speed = 200-vertcat(s.R_Ball)*200;
ForelimbMove= vertcat(s.R);
BallMove = vertcat(s.R_Ball);
ForelimbMove(BallMove<0.95)=1;
ForelimbMove(Laser>0)=1;
ForelimbMove(LaserOffsetFrame)=1;

EarPosiL = vertcat(s.EarPosiL);
EarPosiR = vertcat(s.EarPosiR);


LowerWhisk =vertcat(s.LowerWhiskLumi);
d = designfilt('lowpassiir','FilterOrder',12, ...
    'HalfPowerFrequency',0.02,'DesignMethod','butter');

WhiskerRetract = filtfilt(d,LowerWhisk);
ThrWhisker = mean(WhiskerRetract) - std(WhiskerRetract);
EarPosiL =  filtfilt(d,EarPosiL);
EarPosiR =  filtfilt(d,EarPosiR);
EarPosi = mean([EarPosiL,EarPosiR],2);


r = groot;
Scr = r.ScreenSize;


h1 =figure;
h1.Name = [Pname(19:22) ' ' fn];
h1.Position = [0 40 2*Scr(3)/3 Scr(4)-120];

if steps < 20000
    subplot(7,5,1:5)
else
    subplot(9,5,1:5)
end
plot(Positions,'b-')
hold on
plot(2*Laser+250,'r-')

plot(200*ForelimbMove,'g-')
plot([0 length(ForelimbMove)],[236 236],'k:')

plot(200*EyeBlink+250,'k-')
plot(Speed,'c-')
plot(ChR2Laser,'b-')
plot(WhiskerRetract,'m-')

plot(RawEyeTightening,'g-')
plot(EarPosi*10,'y-')
plot([0 length(ForelimbMove)], [ThrWhisker ThrWhisker],'r-')
ylabel('Left<- ->Right')
ylim([0 500])
xlabel('(frame)')
legend('Positions','Laser','Forelimb','','Eyeblink','Speed','ChR2','WhiskerRetract','WhiskerThr','EarPosi')
title([fn(1:4) ' ' fn(5:6) ' / ' fn(7:8) ' ' fn(9:10) ':' fn(11:12) ' -  ' Pname(19:22)])
xlim([0 length(ForelimbMove)])
box off

Xaxis = -20*30/1000:1*30/1000:300*30/1000;
A = 1:length(ChR2orIR_LaserOnsetFrame);
B = A(index);
ITI = diff(ChR2orIR_LaserOnsetFrame);
ControlOnsetFrames = ChR2orIR_LaserOnsetFrame(ITI>1000)+507;  %507frameずれたところにcontrolのonsetがある
OnsetFrames = sort(vertcat(ChR2orIR_LaserOnsetFrame,ControlOnsetFrames));

if steps < 20000
    MaxTr = 30;
else
    MaxTr = 40;
end


while length(OnsetFrames)<MaxTr
    if OnsetFrames(1)>520
        ControlOnsetFrames = vertcat(ControlOnsetFrames, OnsetFrames(1)-507);
        AddControlOnsetFrames =  OnsetFrames(1)-507;
        OnsetFrames = sort(vertcat(OnsetFrames,AddControlOnsetFrames));
    elseif length(s) - OnsetFrames(end)>520
        AddControlOnsetFrames = OnsetFrames(end)+507;
        ControlOnsetFrames = vertcat(ControlOnsetFrames,AddControlOnsetFrames);
        OnsetFrames = sort(vertcat(OnsetFrames,AddControlOnsetFrames));
    else
        ITI = diff(OnsetFrames);
        AddControlOnsetFrames = OnsetFrames(ITI>1000)+507;
        ControlOnsetFrames = vertcat(ControlOnsetFrames,AddControlOnsetFrames);
        OnsetFrames = sort(vertcat(OnsetFrames,AddControlOnsetFrames));
    end
    if max(ControlOnsetFrames)+150<length(ForelimbMove)
        disp(['Final trial is ' num2str(length(OnsetFrames)) '.'])
        break
    end
end

if max(ControlOnsetFrames)+150>length(ForelimbMove)
    TrialReduce =1;
    RestFr = 150;
else
    TrialReduce =0;
    RestFr = 150;
end

for i=1:length(ChR2orIR_LaserOnsetFrame)
    if steps < 20000
        subplot(7,5,i+10)
    else
        subplot(9,5,i+10)
    end
    
    
    if ChR2orIR_LaserOnsetFrame(B(i))-20>0 && ChR2orIR_LaserOnsetFrame(B(i))+300<length(Positions)
        plot(Xaxis,Positions(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
        hold on
        plot(Xaxis,2*Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300)+250,'r-')
        plot(Xaxis,200*ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'g-')
        plot([-20*30/1000 300*30/1000],[236 236],'k:')
        plot(Xaxis,200*EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300)+300,'k-')
        plot(Xaxis,Speed(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'c-')
        plot(Xaxis,ChR2Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
        plot(Xaxis,WhiskerRetract(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'m-')
        plot(Xaxis,10*EarPosi(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'g-')
        plot(Xaxis,RawEyeTightening(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'k-')
        plot([Xaxis(1) Xaxis(end)], [ThrWhisker ThrWhisker],'g-')
    elseif ChR2orIR_LaserOnsetFrame(B(i))+300<length(Positions)
        plot(Xaxis(20:end),Positions(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
        hold on
        plot(Xaxis(20:end),2*Laser(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300)+250,'r-')
        plot(Xaxis(20:end),200*ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'g-')
        plot([-20*30/1000 300*30/1000],[236 236],'k:')
        plot(Xaxis(20:end),200*EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300)+300,'k-')
        plot(Xaxis(20:end),Speed(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'c-')
        plot(Xaxis(20:end),ChR2Laser(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
        plot(Xaxis(20:end),WhiskerRetract(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))),'m-')
        plot(Xaxis(20:end),10*EarPosi(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))),'g-')
        plot(Xaxis(20:end),RawEyeTightening(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))),'k-')
        plot([Xaxis(20) Xaxis(end)], [ThrWhisker ThrWhisker],'g-')
    else
        plot(Xaxis(1:RestFr+21),Positions(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+RestFr),'b-')
        hold on
        plot(Xaxis(1:RestFr+21),2*Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+RestFr)+250,'r-')
        plot(Xaxis(1:RestFr+21),200*ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+RestFr),'g-')
        plot([-20*30/1000 300*30/1000],[236 236],'k:')
        plot(Xaxis(1:RestFr+21),200*EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+RestFr)+300,'k-')
        plot(Xaxis(1:RestFr+21),Speed(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+RestFr),'c-')
        plot(Xaxis(1:RestFr+21),ChR2Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+RestFr),'b-')
        plot(Xaxis(1:RestFr+21),WhiskerRetract(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))),'m-')
        plot(Xaxis(1:RestFr+21),10*EarPosi(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))),'g-')
        plot(Xaxis(1:RestFr+21),RawEyeTightening(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))),'k-')
        plot([Xaxis(1) Xaxis(RestFr+21)], [ThrWhisker ThrWhisker],'g-')
    end
    
    % Calculate 100ms(frame +3) - 5000ms(frame +RestFr)
    Params(i).DiffPosi = Positions(ChR2orIR_LaserOnsetFrame(B(i))-1) - min(Positions(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));
    Params(i).FlimbMove = sum(1-ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));
    EyeBlinkDiff = diff(EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));
    [~, EBlinkCount] = findpeaks(EyeBlinkDiff);
    Params(i).EBlinkCount = length(EBlinkCount);
    Params(i).Distance = sum(Speed(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));
    Params(i).MaxSpeed = max(Speed(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));
    Params(i).WhiskerRetract =max(ThrWhisker - min(WhiskerRetract(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr)));  %髭引けば値大きく
    Params(i).EarPosi = EarPosi(ChR2orIR_LaserOnsetFrame(B(i)))-min(EarPosi(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));  %耳下がれば値大きく
    Params(i).EyeTightening = max(RawEyeTightening(ChR2orIR_LaserOnsetFrame(B(i))+3:ChR2orIR_LaserOnsetFrame(B(i))+RestFr));  %目を細めれば値大きく
    Params(i).IRlaserFrDuration = ChR2orIR_LaserDurationFrame(B(i),1);
    Params(i).ChR2laserFrDuration = ChR2orIR_LaserDurationFrame(B(i),2);
    Params(i).TrialIdx = B(i);
    title(['L' num2str(B(i))])
    
    
    ylabel('Left<- ->Right')
    
    if MaxTr == 30
        if i == 1
            ylabel('IR(S)')
        elseif i == 6
            ylabel('IR(L)')
        elseif i == 11
            ylabel('ChR2')
        elseif i == 16
            ylabel('IR(S)+ChR2')
        elseif i == 21
            ylabel('IR(L)+ChR2')
        end
    else
        if i == 1
            ylabel('IR(S)')
        elseif i == 6
            ylabel('IR(M)')
        elseif i == 11
            ylabel('IR(L)')
        elseif i == 16
            ylabel('ChR2')
        elseif i == 21
            ylabel('IR(S)+ChR2')
        elseif i == 26
            ylabel('IR(M)+ChR2')
        elseif i == 31
            ylabel('IR(L)+ChR2')
        end
    end
    ylim([0 500])
    xlabel('(sec)')
    xlim([-20*30/1000 300*30/1000])
    %         if i ==1
    %             legend('Position','Laser','Forelimb','','Eyeblink','Speed')
    %         end
    box off
end

for i=1:length(ControlOnsetFrames)-TrialReduce
    if steps < 20000
        subplot(7,5,i+5)
        Plus = 25;
    else
        subplot(9,5,i+5)
        Plus = 35;
    end
    
    if ControlOnsetFrames(i)-20>0 && ControlOnsetFrames(i)+300<length(Positions)
        plot(Xaxis,Positions(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300),'b-')
        hold on
        plot(Xaxis,2*Laser(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300)+250,'r-')
        plot(Xaxis,200*ForelimbMove(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300),'g-')
        plot([-20*30/1000 300*30/1000],[236 236],'k:')
        plot(Xaxis,200*EyeBlink(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300)+300,'k-')
        plot(Xaxis,Speed(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300),'c-')
        plot(Xaxis,ChR2Laser(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300),'b-')
        plot(Xaxis,WhiskerRetract(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300),'m-')
        plot(Xaxis,10*EarPosi(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300)+300,'g-')
        plot(Xaxis,RawEyeTightening(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+300),'k-')
        plot([Xaxis(1) Xaxis(end)], [ThrWhisker ThrWhisker],'g-')
        
    else
        plot(Xaxis(1:150+21),Positions(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'b-')
        hold on
        plot(Xaxis(1:150+21),2*Laser(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150)+250,'r-')
        plot(Xaxis(1:150+21),200*ForelimbMove(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'g-')
        plot([-20*30/1000 300*30/1000],[236 236],'k:')
        plot(Xaxis(1:150+21),200*EyeBlink(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150)+300,'k-')
        plot(Xaxis(1:150+21),Speed(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'c-')
        plot(Xaxis(1:150+21),ChR2Laser(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'b-')
        plot(Xaxis(1:150+21),WhiskerRetract(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'m-')
        plot(Xaxis(1:150+21),10*EarPosi(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'g-')
        plot(Xaxis(1:150+21),RawEyeTightening(ControlOnsetFrames(i)-20:ControlOnsetFrames(i)+150),'k-')
        plot([Xaxis(1) Xaxis(150+21)], [ThrWhisker ThrWhisker],'g-')
    end
    
    Params(i+Plus).DiffPosi = Positions(ControlOnsetFrames(i)-1) - min(Positions(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));
    Params(i+Plus).FlimbMove = sum(1-ForelimbMove(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));
    EyeBlinkDiff = diff(EyeBlink(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));
    [~, EBlinkCount] = findpeaks(EyeBlinkDiff);
    Params(i+Plus).EBlinkCount = length(EBlinkCount);
    Params(i+Plus).Distance = sum(Speed(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));
    Params(i+Plus).MaxSpeed = max(Speed(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));
    
    Params(i+Plus).WhiskerRetract = max(ThrWhisker - min(WhiskerRetract(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150)));  %髭引けば値大きく
    Params(i+Plus).EarPosi = EarPosi(ControlOnsetFrames(i))-min(EarPosi(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));  %耳下がれば値大きく
    Params(i+Plus).EyeTightening = max(RawEyeTightening(ControlOnsetFrames(i)+3:ControlOnsetFrames(i)+150));  %目を細めれば値大きく
    Params(i+Plus).IRlaserFrDuration = 0;
    Params(i+Plus).ChR2laserFrDuration = 0;
    Params(i+Plus).TrialIdx = i+Plus;
    
    title('Control')
    
    
    ylabel('Left<- ->Right')
    if i==1
        ylabel('Control')
    end
    
    ylim([0 500])
    xlabel('(sec)')
    xlim([-20*30/1000 300*30/1000])
    %         if i ==1
    %             legend('Position','Laser','Forelimb','','Eyeblink','Speed')
    %         end
    box off
end

Frames = 1:length(EyeBlink);
h2 =figure;
h2.Name = [Pname(19:22) ' ' fn];
h2.Position = [2*Scr(3)/3 40 Scr(3)/3 3*Scr(4)/4];
subplot(4,2,1)

Eye = vertcat(s.EyeBlink);
Eye(Eye==0)=[];


imagesc(s((Frames(Eye == min(Eye)))).Data(30:120,30:150)),colormap(gray)
title(['Eye open F=' num2str(Frames(Eye == min(Eye)))])
subplot(4,2,2)
imagesc(s(min(Frames(EyeBlink==1))+1).Data(30:120,30:150)),colormap(gray)
title(['Eye close F=' num2str(min(Frames(EyeBlink==1)+1))])
subplot(4,1,2)
plot(vertcat(s.EyeBlink))
ylabel('open <- -> close')

axis tight
subplot(4,1,3)
plot(RawEyeBlink)
hold on
plot([0 length(RawEyeBlink)],[EyeThr EyeThr],'k-')
axis tight
xlabel('(frame)')

subplot(4,1,4)
plot(RawEyeTightening)
title('RawEyeTightening (high=severe)')
axis tight
xlabel('(frame)')
ylabel('open <- -> close')

h3 = figure;
h3.Name = [Pname(19:22) ' ' fn];
h3.Position = [2*Scr(3)/3 10 Scr(3)/5 Scr(4)-100];
subplot(9,1,2)
if MaxTr==30
    X = [ones(1,5)*3,ones(1,5)*5,ones(1,5)*2,ones(1,5)*4,ones(1,5)*6,ones(1,5)];
    X2 = [3,5,2,4,6,1];
elseif MaxTr==40
    X = [ones(1,5)*3,ones(1,5)*5,ones(1,5)*7,ones(1,5)*2,ones(1,5)*4,ones(1,5)*6,ones(1,5)*8,ones(1,5)];
    X2 = [3,5,7,2,4,6,8,1];
end
Y = vertcat(Params.DiffPosi);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end

title('DiffPosi')
subplot(9,1,3)
Y = vertcat(Params.Distance);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
title('Distance')
subplot(9,1,4)
Y = vertcat(Params.MaxSpeed);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
title('MaxSpeed')
subplot(9,1,5)
Y = vertcat(Params.FlimbMove);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
title('FlimbMove')
subplot(9,1,6)
Y = vertcat(Params.EBlinkCount);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
title('EBlinkCount')



subplot(9,3,1)
plot(RawEyeTightening)
ylabel('->Tightening')
title('EyeTightening')
subplot(9,3,2)
plot(EarPosi)
ylabel('low<->high')
title('EarPosi')
subplot(9,3,3)
plot(WhiskerRetract)
title('WhiskerRetract')
ylabel('retract<-')

subplot(9,1,7)
Y = vertcat(Params.WhiskerRetract);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
title('WhiskerRetract(high=Severe)')

subplot(9,1,8)
Y = vertcat(Params.EarPosi);
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
title('EarPosi(high=Severe)')

subplot(9,1,9)
Y = vertcat(Params.EyeTightening);
ylim([min(Y) max(Y)])
if length(Y)<MaxTr
    Y=vertcat(Y,1);
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    Y2(end)=mean(Y(26:29));
    bar(X2,Y2,'w')
    hold on
    plot(X(1:end-1),Y(1:end-1),'o')
else
    Y2 = mean(reshape(Y,[5,MaxTr/5]),1);
    bar(X2,Y2,'w')
    hold on
    plot(X,Y,'o')
end
Y = vertcat(Params.EyeTightening);
ylim([min(Y) max(Y)])
title('EyeTightening(high=Severe)')

txt1 = ['1=control, 2=ChR(+),3=LaserS,4=LaserS+ChR,5=LaserL,6=LaserL+ChR2'];
text(-2,-3,txt1)

h1.Renderer = 'painters';
h3.Renderer = 'painters';
saveas(h1,[Pname fn(1:end-12) 'Alltrial.pdf'],'pdf')
saveas(h3,[Pname fn(1:end-12) 'hist.pdf'],'pdf')

SaveFname = fullfile(Pname, [fn(1:end-12) 'AnalyzedData.mat']);
save(SaveFname, 'Params')
disp([SaveFname ' was saved.'])