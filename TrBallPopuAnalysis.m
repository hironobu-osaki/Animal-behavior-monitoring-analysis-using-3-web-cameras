clear
R148fn = {'D:\TrackBallMovie\R148\Combined\201907041357AnalyzedData.mat',... 
    'D:\TrackBallMovie\R148\Combined\201907041406AnalyzedData.mat',... 
    'D:\TrackBallMovie\R148\Combined\201907041416AnalyzedData.mat'...
    };
R149fn = {'D:\TrackBallMovie\R149\Combined\201907051330AnalyzedData.mat',... 
    'D:\TrackBallMovie\R149\Combined\201907051349AnalyzedData.mat'... 
    };
R150fn = {'D:\TrackBallMovie\R150\Combined\201907031442AnalyzedData.mat',... 
    'D:\TrackBallMovie\R150\Combined\201907031455AnalyzedData.mat',... 
    'D:\TrackBallMovie\R150\Combined\201907031505AnalyzedData.mat'...
    };

for i = 1:length(R148fn)
    A = load(R148fn{i});
    Zscored(i).DiffPosi = zscore(vertcat(A.Params.DiffPosi));
    Zscored(i).FlimbMove = zscore(vertcat(A.Params.FlimbMove));
    Zscored(i).EBlinkCount = zscore(vertcat(A.Params.EBlinkCount));
    Zscored(i).Distance = zscore(vertcat(A.Params.Distance));
    Zscored(i).MaxSpeed = zscore(vertcat(A.Params.MaxSpeed));
    Zscored(i).EarPosi = zscore(vertcat(A.Params.EarPosi));
    Zscored(i).EyeTightening = zscore(vertcat(A.Params.EyeTightening));
    Zscored(i).IRlaserFrDuration = vertcat(A.Params.IRlaserFrDuration);
    Zscored(i).ChR2laserFrDuration = vertcat(A.Params.ChR2laserFrDuration);
end
    DiffPosi = vertcat(Zscored.DiffPosi);
    FlimbMove = vertcat(Zscored.FlimbMove);
    EBlinkCount = vertcat(Zscored.EBlinkCount);
    Distance = vertcat(Zscored.Distance);
    MaxSpeed = vertcat(Zscored.MaxSpeed);
    EarPosi = vertcat(Zscored.EarPosi);
    EyeTightening = vertcat(Zscored.EyeTightening);
    IRlaserFrDuration = vertcat(Zscored.IRlaserFrDuration);
    ChR2laserFrDuration = vertcat(Zscored.ChR2laserFrDuration);
    
    Mean_zDiffPosi(1) = mean(DiffPosi(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(2) = mean(DiffPosi(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zDiffPosi(3) = mean(DiffPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(4) = mean(DiffPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zDiffPosi(5) = mean(DiffPosi(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(6) = mean(DiffPosi(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    
    Mean_zFlimbMove(1) = mean(FlimbMove(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(2) = mean(FlimbMove(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(3) = mean(FlimbMove(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(4) = mean(FlimbMove(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(5) = mean(FlimbMove(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(6) = mean(FlimbMove(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(1) = mean(EBlinkCount(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(2) = mean(EBlinkCount(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(3) = mean(EBlinkCount(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(4) = mean(EBlinkCount(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(5) = mean(EBlinkCount(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(6) = mean(EBlinkCount(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(1) = mean(MaxSpeed(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(2) = mean(MaxSpeed(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(3) = mean(MaxSpeed(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(4) = mean(MaxSpeed(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(5) = mean(MaxSpeed(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(6) = mean(MaxSpeed(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEarPosi(1) = mean(EarPosi(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEarPosi(2) = mean(EarPosi(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEarPosi(3) = mean(EarPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEarPosi(4) = mean(EarPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEarPosi(5) = mean(EarPosi(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEarPosi(6) = mean(EarPosi(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(1) = mean(EyeTightening(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(2) = mean(EyeTightening(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(3) = mean(EyeTightening(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(4) = mean(EyeTightening(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(5) = mean(EyeTightening(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(6) = mean(EyeTightening(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    
    Mean_zDistance(1) = mean(Distance(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zDistance(2) = mean(Distance(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zDistance(3) = mean(Distance(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zDistance(4) = mean(Distance(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zDistance(5) = mean(Distance(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zDistance(6) = mean(Distance(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    R148Mean.zDistance = Mean_zDistance;
    R148Mean.zDiffPosi = Mean_zDiffPosi;
    R148Mean.zFlimbMove = Mean_zFlimbMove;
    R148Mean.zEBlinkCount = Mean_zEBlinkCount;
    R148Mean.zMaxSpeed = Mean_zMaxSpeed;
    R148Mean.zEarPosi = Mean_zEarPosi;
    R148Mean.zEyeTightening = Mean_zEyeTightening;
    
for i = 1:length(R149fn)
    A = load(R149fn{i});
    Zscored(i).DiffPosi = zscore(vertcat(A.Params.DiffPosi));
    Zscored(i).FlimbMove = zscore(vertcat(A.Params.FlimbMove));
    Zscored(i).EBlinkCount = zscore(vertcat(A.Params.EBlinkCount));
    Zscored(i).Distance = zscore(vertcat(A.Params.Distance));
    Zscored(i).MaxSpeed = zscore(vertcat(A.Params.MaxSpeed));
    Zscored(i).EarPosi = zscore(vertcat(A.Params.EarPosi));
    Zscored(i).EyeTightening = zscore(vertcat(A.Params.EyeTightening));
    Zscored(i).IRlaserFrDuration = vertcat(A.Params.IRlaserFrDuration);
    Zscored(i).ChR2laserFrDuration = vertcat(A.Params.ChR2laserFrDuration);
end
    DiffPosi = vertcat(Zscored.DiffPosi);
    FlimbMove = vertcat(Zscored.FlimbMove);
    EBlinkCount = vertcat(Zscored.EBlinkCount);
    MaxSpeed = vertcat(Zscored.MaxSpeed);
    Distance = vertcat(Zscored.Distance);
    EarPosi = vertcat(Zscored.EarPosi);
    EyeTightening = vertcat(Zscored.EyeTightening);
    IRlaserFrDuration = vertcat(Zscored.IRlaserFrDuration);
    ChR2laserFrDuration = vertcat(Zscored.ChR2laserFrDuration);
    
    Mean_zDiffPosi(1) = mean(DiffPosi(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(2) = mean(DiffPosi(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zDiffPosi(3) = mean(DiffPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(4) = mean(DiffPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zDiffPosi(5) = mean(DiffPosi(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(6) = mean(DiffPosi(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(1) = mean(FlimbMove(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(2) = mean(FlimbMove(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(3) = mean(FlimbMove(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(4) = mean(FlimbMove(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(5) = mean(FlimbMove(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(6) = mean(FlimbMove(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(1) = mean(EBlinkCount(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(2) = mean(EBlinkCount(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(3) = mean(EBlinkCount(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(4) = mean(EBlinkCount(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(5) = mean(EBlinkCount(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(6) = mean(EBlinkCount(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(1) = mean(MaxSpeed(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(2) = mean(MaxSpeed(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(3) = mean(MaxSpeed(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(4) = mean(MaxSpeed(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(5) = mean(MaxSpeed(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(6) = mean(MaxSpeed(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEarPosi(1) = mean(EarPosi(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEarPosi(2) = mean(EarPosi(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEarPosi(3) = mean(EarPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEarPosi(4) = mean(EarPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEarPosi(5) = mean(EarPosi(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEarPosi(6) = mean(EarPosi(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(1) = mean(EyeTightening(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(2) = mean(EyeTightening(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(3) = mean(EyeTightening(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(4) = mean(EyeTightening(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(5) = mean(EyeTightening(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(6) = mean(EyeTightening(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    
    Mean_zDistance(1) = mean(Distance(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zDistance(2) = mean(Distance(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zDistance(3) = mean(Distance(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zDistance(4) = mean(Distance(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zDistance(5) = mean(Distance(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zDistance(6) = mean(Distance(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    R149Mean.zDistance = Mean_zDistance;
    R149Mean.zDiffPosi = Mean_zDiffPosi;
    R149Mean.zFlimbMove = Mean_zFlimbMove;
    R149Mean.zEBlinkCount = Mean_zEBlinkCount;
    R149Mean.zMaxSpeed = Mean_zMaxSpeed;
    R149Mean.zEarPosi = Mean_zEarPosi;
    R149Mean.zEyeTightening = Mean_zEyeTightening;
for i = 1:length(R150fn)
    A = load(R150fn{i});
    Zscored(i).DiffPosi = zscore(vertcat(A.Params.DiffPosi));
    Zscored(i).FlimbMove = zscore(vertcat(A.Params.FlimbMove));
    Zscored(i).EBlinkCount = zscore(vertcat(A.Params.EBlinkCount));
    Zscored(i).Distance = zscore(vertcat(A.Params.Distance));
    Zscored(i).MaxSpeed = zscore(vertcat(A.Params.MaxSpeed));
    Zscored(i).EarPosi = zscore(vertcat(A.Params.EarPosi));
    Zscored(i).EyeTightening = zscore(vertcat(A.Params.EyeTightening));
    Zscored(i).IRlaserFrDuration = vertcat(A.Params.IRlaserFrDuration);
    Zscored(i).ChR2laserFrDuration = vertcat(A.Params.ChR2laserFrDuration);
end
    DiffPosi = vertcat(Zscored.DiffPosi);
    FlimbMove = vertcat(Zscored.FlimbMove);
    EBlinkCount = vertcat(Zscored.EBlinkCount);
    MaxSpeed = vertcat(Zscored.MaxSpeed);
    Distance = vertcat(Zscored.Distance);
    EarPosi = vertcat(Zscored.EarPosi);
    EyeTightening = vertcat(Zscored.EyeTightening);
    IRlaserFrDuration = vertcat(Zscored.IRlaserFrDuration);
    ChR2laserFrDuration = vertcat(Zscored.ChR2laserFrDuration);
    
    Mean_zDiffPosi(1) = mean(DiffPosi(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(2) = mean(DiffPosi(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zDiffPosi(3) = mean(DiffPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(4) = mean(DiffPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zDiffPosi(5) = mean(DiffPosi(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zDiffPosi(6) = mean(DiffPosi(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(1) = mean(FlimbMove(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(2) = mean(FlimbMove(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(3) = mean(FlimbMove(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(4) = mean(FlimbMove(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zFlimbMove(5) = mean(FlimbMove(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zFlimbMove(6) = mean(FlimbMove(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(1) = mean(EBlinkCount(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(2) = mean(EBlinkCount(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(3) = mean(EBlinkCount(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(4) = mean(EBlinkCount(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEBlinkCount(5) = mean(EBlinkCount(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEBlinkCount(6) = mean(EBlinkCount(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(1) = mean(MaxSpeed(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(2) = mean(MaxSpeed(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(3) = mean(MaxSpeed(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(4) = mean(MaxSpeed(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zMaxSpeed(5) = mean(MaxSpeed(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zMaxSpeed(6) = mean(MaxSpeed(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEarPosi(1) = mean(EarPosi(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEarPosi(2) = mean(EarPosi(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEarPosi(3) = mean(EarPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEarPosi(4) = mean(EarPosi(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEarPosi(5) = mean(EarPosi(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEarPosi(6) = mean(EarPosi(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(1) = mean(EyeTightening(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(2) = mean(EyeTightening(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(3) = mean(EyeTightening(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(4) = mean(EyeTightening(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zEyeTightening(5) = mean(EyeTightening(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zEyeTightening(6) = mean(EyeTightening(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    
    Mean_zDistance(1) = mean(Distance(IRlaserFrDuration==0 & ChR2laserFrDuration==0));
    Mean_zDistance(2) = mean(Distance(IRlaserFrDuration==0 & ChR2laserFrDuration>0));
    Mean_zDistance(3) = mean(Distance(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration==0));
    Mean_zDistance(4) = mean(Distance(IRlaserFrDuration>0 & IRlaserFrDuration<20 & ChR2laserFrDuration>0));
    Mean_zDistance(5) = mean(Distance(IRlaserFrDuration>20 & ChR2laserFrDuration==0));
    Mean_zDistance(6) = mean(Distance(IRlaserFrDuration>20 & ChR2laserFrDuration>0));
    
%     R150Mean.zDistance = mean([Mean_zDistance;Mean_zMaxSpeed]);
    R150Mean.zDiffPosi = Mean_zDiffPosi;
    R150Mean.zFlimbMove = Mean_zFlimbMove;
    R150Mean.zEBlinkCount = Mean_zEBlinkCount;
    R150Mean.zMaxSpeed = Mean_zMaxSpeed;
    R150Mean.zEarPosi = Mean_zEarPosi;
    R150Mean.zEyeTightening = Mean_zEyeTightening;

figure,
% subplot(3,2,1)
% plot(R148Mean.zDistance)
% hold on
% plot(R149Mean.zDistance)
% plot(R150Mean.zDistance)
% ylabel('mean z-score')
% title('DiffPosi')
% legend('R148 (90)','R149 (60)','R150 (90)')
% xlim([0.5 6.5])

subplot(3,2,1)
X2 = [1,2,3,4,5,6];
Y2 = mean([R148Mean.zDiffPosi;R149Mean.zDiffPosi;R150Mean.zDiffPosi]);
bar(X2,Y2,'w')
hold on
plot(R148Mean.zDiffPosi,'ko-')
plot(R149Mean.zDiffPosi,'k+-')
plot(R150Mean.zDiffPosi,'k*-')
ylabel('mean z-score')
title('DiffPosi')
legend('', 'R148 (90)','R149 (60)','R150 (90)')
xlim([0.5 6.5])
box off




subplot(3,2,4)
Y2 = mean([R148Mean.zFlimbMove;R149Mean.zFlimbMove;R150Mean.zFlimbMove]);
bar(X2,Y2,'w')
hold on
plot(R148Mean.zFlimbMove,'ko-')
plot(R149Mean.zFlimbMove,'k+-')
plot(R150Mean.zFlimbMove,'k*-')
ylabel('mean z-score')
title('FlimbMove')
xlim([0.5 6.5])
box off

subplot(3,2,5)
Y2 = mean([R148Mean.zEBlinkCount;R149Mean.zEBlinkCount;R150Mean.zEBlinkCount]);
bar(X2,Y2,'w')
hold on
plot(R148Mean.zEBlinkCount,'ko-')
plot(R149Mean.zEBlinkCount,'k+-')
plot(R150Mean.zEBlinkCount,'k*-')
ylabel('mean z-score')
title('EBlinkCount')
xlim([0.5 6.5])
box off

subplot(3,2,2)
Y2 = mean([R148Mean.zMaxSpeed;R149Mean.zMaxSpeed;R150Mean.zMaxSpeed]);
bar(X2,Y2,'w')
hold on
plot(R148Mean.zMaxSpeed,'ko-')
plot(R149Mean.zMaxSpeed,'k+-')
plot(R150Mean.zMaxSpeed,'k*-')
ylabel('mean z-score')
title('MaxSpeed')
xlim([0.5 6.5])
box off

subplot(3,2,3)
Y2 = mean([R148Mean.zEarPosi;R149Mean.zEarPosi;R150Mean.zEarPosi]);
bar(X2,Y2,'w')
hold on
plot(R148Mean.zEarPosi,'ko-')
plot(R149Mean.zEarPosi,'k+-')
plot(R150Mean.zEarPosi,'k*-')
ylabel('mean z-score')
title('EarPosi')
xlim([0.5 6.5])
box off

subplot(3,2,6)
Y2 = mean([R148Mean.zEyeTightening;R149Mean.zEyeTightening;R150Mean.zEyeTightening]);
bar(X2,Y2,'w')
hold on
plot(R148Mean.zEyeTightening,'ko-')
plot(R149Mean.zEyeTightening,'k+-')
plot(R150Mean.zEyeTightening,'k*-')
ylabel('mean z-score')
xlim([0.5 6.5])
title('EyeTightening')
box off