% function s = MouseDetectionTrackBall
clear;

if ispc
    [Fname, Pname] = uigetfile('D:\TrackBallMovie\*Combined.avi','MultiSelect','on');
elseif ismac
    [Fname, Pname] = uigetfile('/Users/moeko/Desktop/R139R140/*Combined.avi','MultiSelect','on');
end

Fparts = length(Fname);
if Fparts>10
    Fparts=1;
end
for jj = 1:Fparts
    if Fparts==1
        fn = Fname;
    else
        fn = Fname{jj};
    end
    
    
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
    
%     if jj==1
        Ex=[75,100];
        Ey=[45,70];
%         figure,
%         EyeDetectionOK=1;
%         while EyeDetectionOK
%             
%             
%             FirstImage = s(1).Data;
%             imagesc(FirstImage(1:150,1:200))
%             colormap(gray)
%             hold on
%             %Eyeblink detection area
%             plot([Ex(1) Ex(1)],[Ey(1) Ey(2)],'r-')
%             plot([Ex(2) Ex(2)],[Ey(1) Ey(2)],'r-')
%             plot([Ex(1) Ex(2)],[Ey(1) Ey(1)],'r-')
%             plot([Ex(1) Ex(2)],[Ey(2) Ey(2)],'r-')
%             
%             prompt = 'Input the X value to shift the Eye detection area ...';
%             x = input(prompt);
%             prompt = 'Input the Y value to shift the Eye detection area ...';
%             y = input(prompt);
%             Ex = Ex +x;
%             Ey = Ey +y;
%             
%             
%             hold off,imagesc(FirstImage(1:150,1:200))
%             colormap(gray)
%             hold on
%             %Eyeblink detection area
%             plot([Ex(1) Ex(1)],[Ey(1) Ey(2)],'r-')
%             plot([Ex(2) Ex(2)],[Ey(1) Ey(2)],'r-')
%             plot([Ex(1) Ex(2)],[Ey(1) Ey(1)],'r-')
%             plot([Ex(1) Ex(2)],[Ey(2) Ey(2)],'r-')
%             
%             prompt = 'Good? Press 0, Bad? Press 1...';
%             EyeDetectionOK = input(prompt);
%         end
%     end
    % BaseImage = gpuArray(s(1).Data(72:126,95:173));
    BaseImage = s(1).Data(70:95,75:180);%72:92,95:173)
    BaseImageBall = s(1).Data(450:end,457:928);
    %     BaseImageEye = s(1).Data(57:91,21:54);
    for i = 1:steps
        
        EyeLumi = s(i).Data(Ey(1):Ey(2),Ex(1):Ex(2));
        EyeLumi = reshape(EyeLumi,[],1);
        s(i).EyeBlink = mean(topkrows(EyeLumi,50,'ascend'));
        LaserLumiL = s(i).Data(61:78,33:62);
        LaserLumiR = s(i).Data(310:355,370:425);
        LaserLumiC = s(i).Data(25:60,600:680);
        LaserLumiL = reshape(LaserLumiL,[],1);
        LaserLumiR = reshape(LaserLumiR,[],1);
        LaserLumiC = reshape(LaserLumiC,[],1);
        LaserLumiL = mean(topkrows(LaserLumiL,50));
        LaserLumiR = mean(topkrows(LaserLumiR,550));
        LaserLumiC = mean(topkrows(LaserLumiC,550));
        LaserLumi = mean([LaserLumiL, LaserLumiR, LaserLumiC]);
        
        
        ChR2LaserLumi = s(i).Data(119:139,700:730);
        ChR2LaserLumi = reshape(ChR2LaserLumi,[],1);
        
        ChR2LaserLumi = mean(topkrows(ChR2LaserLumi,150));
        %         s(i).EyeBlink = mean(mean(EyeLumi<150));
        %         s(i).EyeBlink = length(find(EyeLumi<100));
        
        s(i).Laser = LaserLumi;
        s(i).ChR2Laser = mean(mean(ChR2LaserLumi));
        s(i).BaseLumi = mean(mean(s(i).Data(18:54,192:289)));
        
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
        %         Eye = s(i).Data(57:91,21:54);
        %         s(i).R_Eye = corr2(BaseImageEye, Eye);
        s(i).R = corr2(BaseImage, s(i).Data(70:95,75:180));
        
    end
    
    Laser = vertcat(s.Laser);
    ChR2Laser = vertcat(s.ChR2Laser);
    figure, plot(Laser, 'r-')
    hold on
    plot(ChR2Laser, 'b-')
    LaserTh = 230+10;
    ChR2Th = 230;
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
%     DiffLaserOnset = diff(LaserOnsetFrame);
    
    %     LaserOnsetFrame(2:end+1)=LaserOnsetFrame;
    %     LaserOnsetFrame(1)=1;
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
    [~,ChR2LaserOnsetFrame] = findpeaks(ChR2LaserOnset,'MinPeakHeight',150,'MinPeakDistance',300);
    ChR2LaserOnsetFrame = ChR2LaserOnsetFrame+1;
    %     LaserOnsetFrame(2:end+1)=LaserOnsetFrame;
    %     LaserOnsetFrame(1)=1;
    [~,ChR2LaserOffsetFrame] = findpeaks(-ChR2LaserOnset,'MinPeakHeight',150,'MinPeakDistance',300);
    ChR2LaserOffsetFrame = ChR2LaserOffsetFrame+1;
    ChR2LaserDurationFrame = ChR2LaserOffsetFrame-ChR2LaserOnsetFrame;
    ChR2LaserOnsetFrame(ChR2LaserDurationFrame > 60) = [];
    ChR2LaserOffsetFrame(ChR2LaserDurationFrame > 60) = [];
    ChR2LaserDurationFrame(ChR2LaserDurationFrame > 60) = [];
    ChR2LaserOnsetFrame(ChR2LaserDurationFrame < 5) = [];
    ChR2LaserOffsetFrame(ChR2LaserDurationFrame < 5) = [];
    ChR2LaserDurationFrame(ChR2LaserDurationFrame < 5) = [];
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
    % ChR2Laserduration‚ÆIRlaserduration‚ð‘Î‰ž‚Ã‚¯
    ID_ChR2 = knnsearch(ChR2orIR_LaserOnsetFrame,ChR2LaserOnsetFrame);%ChR2orIR_LaserOnset‚ÉÅ‚à‹ß‚¢ChR2LaserOnset‚ðŒ©‚Â‚¯‚é
    ID_IR = knnsearch(ChR2orIR_LaserOnsetFrame,LaserOnsetFrame);%ChR2orIR_LaserOnset‚ÉÅ‚à‹ß‚¢IRLaserOnset‚ðŒ©‚Â‚¯‚é


    ChR2orIR_LaserDurationFrame = zeros(length(ChR2orIR_LaserOnsetFrame),2);
    ChR2orIR_LaserDurationFrame(ID_IR,1) = LaserDurationFrame;
    ChR2orIR_LaserDurationFrame(ID_ChR2,2) = 1;
    [~,index] = sortrows(ChR2orIR_LaserDurationFrame, [2 1]);

    
    
    Positions =vertcat(s.Position);
    
    
    
    d1 = designfilt('bandpassiir','FilterOrder',12, ...
        'HalfPowerFrequency1',0.05,'HalfPowerFrequency2',0.6,'DesignMethod','butter');
    RawEyeBlink = filtfilt(d1,vertcat(s.EyeBlink));
    
    %     EyeBlink(2:end) = diff(EyeBlink);
    %     EyeBlink(EyeBlink > -2*std(EyeBlink)) = 0;
    %     EyeBlink(EyeBlink < -2*std(EyeBlink)) = 1;
    %     EyeBlink(Laser>0)=0;
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
    
    r = groot;
    Scr = r.ScreenSize;
    h1 =figure;
    h1.Name = [fn ' ' Pname(19:22)];
    h1.Position = [0 40 2*Scr(3)/3 Scr(4)-120];
    subplot(6,6,1:6)
    plot(Positions,'b-')
    hold on
    plot(2*Laser+250,'r-')
    
    plot(200*ForelimbMove,'g-')
    plot([0 length(ForelimbMove)],[236 236],'k:')
    
    plot(200*EyeBlink+250,'k-')
    plot(Speed,'c-')
    plot(ChR2Laser,'b-')
    ylabel('Left<- ->Right')
    ylim([0 500])
    xlabel('(frame)')
    legend('Positions','Laser','Forelimb','','Eyeblink','Speed','ChR2')
    title([fn(1:4) ' ' fn(5:6) ' / ' fn(7:8) ' ' fn(9:10) ':' fn(11:12) ' -  ' Pname(19:22)])
    xlim([0 length(ForelimbMove)])
    box off
    %     subplot(3,1,2),plot(vertcat(s.Position))
    
    
    %     figure,imagesc(s(1).Data)
    %     colormap(gray)
    %     hold on
    %     %Eyeblink detection area
    %     plot([Ex(1) Ex(1)],[Ey(1) Ey(2)],'k-')
    %     plot([Ex(2) Ex(2)],[Ey(1) Ey(2)],'k-')
    %     plot([Ex(1) Ex(2)],[Ey(1) Ey(1)],'k-')
    %     plot([Ex(1) Ex(2)],[Ey(2) Ey(2)],'k-')
    %
    %     %Forelimb movement detection area
    %     plot([75 75],[70 95],'r-')
    %     plot([180 180],[70 95],'r-')
    %     plot([75 180],[70 70],'r-')
    %     plot([75 180],[95 95],'r-')
    %     %Position detection area
    %     plot([457 457],[259 288],'r-')
    %     plot([928 928],[259 288],'r-')
    %     plot([457 928],[259 259],'r-')
    %     plot([457 928],[288 288],'r-')
    
    
    
    %     h2 =figure;
    %     h2.Name = [fn ' ' Pname(19:22)];
    %     Xaxis = -20:300;
    Xaxis = -20*30/1000:1*30/1000:300*30/1000;
    A = 1:length(ChR2orIR_LaserOnsetFrame);
    B = A(index);
    for i=1:length(ChR2orIR_LaserOnsetFrame)
        subplot(6,5,i+5)
        
        if ChR2orIR_LaserOnsetFrame(B(i))-20>0 && ChR2orIR_LaserOnsetFrame(B(i))+300<length(Positions)
            plot(Xaxis,Positions(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
            hold on
            plot(Xaxis,2*Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300)+250,'r-')
            plot(Xaxis,200*ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'g-')
            plot([-20*30/1000 300*30/1000],[236 236],'k:')
            plot(Xaxis,200*EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300)+300,'k-')
            plot(Xaxis,Speed(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'c-')
            plot(Xaxis,ChR2Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
        elseif ChR2orIR_LaserOnsetFrame(B(i))+300<length(Positions)
            plot(Xaxis(20:end),Positions(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
            hold on
            plot(Xaxis(20:end),2*Laser(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300)+250,'r-')
            plot(Xaxis(20:end),200*ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'g-')
            plot([-20*30/1000 300*30/1000],[236 236],'k:')
            plot(Xaxis(20:end),200*EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300)+300,'k-')
            plot(Xaxis(20:end),Speed(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'c-')
            plot(Xaxis(20:end),ChR2Laser(ChR2orIR_LaserOnsetFrame(B(i))-1:ChR2orIR_LaserOnsetFrame(B(i))+300),'b-')
        else
            Xend = length(Positions(ChR2orIR_LaserOnsetFrame(B(i))-20:end));
            plot(Xaxis(1:Xend),Positions(ChR2orIR_LaserOnsetFrame(B(i))-20:end),'b-')
            hold on
            plot(Xaxis(1:Xend),2*Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:end),'r-')
            plot(Xaxis(1:Xend),200*ForelimbMove(ChR2orIR_LaserOnsetFrame(B(i))-20:end),'g-')
            plot([-20*30/1000 300*30/1000],[236 236],'k:')
            plot(Xaxis(1:Xend),200*EyeBlink(ChR2orIR_LaserOnsetFrame(B(i))-20:end),'k-')
            plot(Xaxis(1:Xend),Speed(ChR2orIR_LaserOnsetFrame(B(i))-20:end),'c-')
            plot(Xaxis(1:Xend),ChR2Laser(ChR2orIR_LaserOnsetFrame(B(i))-20:end),'b-')
        end
        title(['L' num2str(B(i))])
        
        
        ylabel('Left<- ->Right')
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
    h2.Name = [fn ' ' Pname(19:22)];
    h2.Position = [2*Scr(3)/3 40 Scr(3)/3 Scr(4)/2];
    subplot(3,2,1)
    
    Eye = vertcat(s.EyeBlink);
    Eye(Eye==0)=[];
    
    
    imagesc(s((Frames(Eye == min(Eye)))).Data(30:120,30:150)),colormap(gray)
    title(['Eye open F=' num2str(Frames(Eye == min(Eye)))])
    subplot(3,2,2)
    imagesc(s(min(Frames(EyeBlink==1))+1).Data(30:120,30:150)),colormap(gray)
    title(['Eye close F=' num2str(min(Frames(EyeBlink==1)+1))])
    subplot(3,2,3:4)
    plot(vertcat(s.EyeBlink))
    ylabel('close <- -> open')
    
    axis tight
    subplot(3,2,5:6)
    plot(RawEyeBlink)
    hold on
    plot([0 length(RawEyeBlink)],[EyeThr EyeThr],'k-')
    axis tight
    xlabel('(frame)')
end


% SaveFname = [Fname(1:end-12) 'AnalyzedMovie.mat'];
% SaveFname2 = fullfile(Pname,SaveFname);
% save(SaveFname2, 's')