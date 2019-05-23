% function s = MouseDetectionTrackBall

[Fname, Pname] = uigetfile('D:\TrackBallMovie\*Combined.avi','MultiSelect','on');
% [Fname, Pname] = uigetfile('/Users/moeko/Desktop/R139R140/*Combined.avi','MultiSelect','on');

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
    
    if jj==1
        Ex=[75,96];
        Ey=[52,62];
        figure,
        EyeDetectionOK=1;
        while EyeDetectionOK
            
            
            FirstImage = s(1).Data;
            imagesc(FirstImage(1:150,1:200))
            colormap(gray)
            hold on
            %Eyeblink detection area
            plot([Ex(1) Ex(1)],[Ey(1) Ey(2)],'r-')
            plot([Ex(2) Ex(2)],[Ey(1) Ey(2)],'r-')
            plot([Ex(1) Ex(2)],[Ey(1) Ey(1)],'r-')
            plot([Ex(1) Ex(2)],[Ey(2) Ey(2)],'r-')
            
            prompt = 'Input the X value to shift the Eye detection area ...';
            x = input(prompt);
            prompt = 'Input the Y value to shift the Eye detection area ...';
            y = input(prompt);
            Ex = Ex +x;
            Ey = Ey +y;
            
            
            hold off,imagesc(FirstImage(1:150,1:200))
            colormap(gray)
            hold on
            %Eyeblink detection area
            plot([Ex(1) Ex(1)],[Ey(1) Ey(2)],'r-')
            plot([Ex(2) Ex(2)],[Ey(1) Ey(2)],'r-')
            plot([Ex(1) Ex(2)],[Ey(1) Ey(1)],'r-')
            plot([Ex(1) Ex(2)],[Ey(2) Ey(2)],'r-')
            
            prompt = 'Good? Press 0, Bad? Press 1...';
            EyeDetectionOK = input(prompt);
        end
    end
    % BaseImage = gpuArray(s(1).Data(72:126,95:173));
    BaseImage = s(1).Data(70:95,75:180);%72:92,95:173)
    BaseImageBall = s(1).Data(450:end,457:928);
%     BaseImageEye = s(1).Data(57:91,21:54);
    for i = 1:steps
        
        EyeLumi = s(i).Data(Ey(1):Ey(2),Ex(1):Ex(2));
        LaserLumi = s(i).Data(329:355,398:425);
        ChR2LaserLumi = s(i).Data(129:139,700:719);
%         s(i).EyeBlink = mean(mean(EyeLumi<150));
        s(i).EyeBlink = length(find(EyeLumi<100));
        
        s(i).Laser = mean(mean(LaserLumi));
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
    disp();
    Laser(Laser<180)=0;
    Laser(Laser>180)=200;
    if Laser(1)==200
        Laser(1)=0;
    end
    LaserOnset = diff(Laser);
    LaserOnsetFrame = find(LaserOnset==200)+1;
%     LaserOnsetFrame(2:end+1)=LaserOnsetFrame;
%     LaserOnsetFrame(1)=1;
    LaserOffsetFrame = find(LaserOnset==-200)+1;
    LaserDurationFrame = LaserOffsetFrame-LaserOnsetFrame;
    
    ChR2Laser = vertcat(s.ChR2Laser);
    ChR2Laser(ChR2Laser<239)=0;
    ChR2Laser(ChR2Laser>239)=200;
    if ChR2Laser(1)==200
        ChR2Laser(1)=0;
    end
    ChR2LaserOnset = diff(ChR2Laser);
    ChR2LaserOnsetFrame = find(ChR2LaserOnset==200)+1;
    %     LaserOnsetFrame(2:end+1)=LaserOnsetFrame;
%     LaserOnsetFrame(1)=1;
    ChR2LaserOffsetFrame = find(ChR2LaserOnset==-200)+1;
    ChR2LaserDurationFrame = ChR2LaserOffsetFrame-ChR2LaserOnsetFrame;
    
    % ChR2LaserdurationÇ∆IRlaserdurationÇëŒâûÇ√ÇØ
    IDX = knnsearch(LaserOnsetFrame,ChR2LaserOnsetFrame);%IRLaserOnsetÇ…ç≈Ç‡ãﬂÇ¢ChR2LaserOnsetÇå©Ç¬ÇØÇÈ
    IDX2 = LaserOnsetFrame(IDX) - ChR2LaserOnsetFrame;
    IDX_ChR2 = IDX(abs(IDX2)<10);
    LaserDurationFrame(:,2) = zeros(length(LaserDurationFrame),1);
    LaserDurationFrame(IDX_ChR2,2) = 1;
    [~,index] = sortrows(LaserDurationFrame, [2 1]);
    
    
    
    Positions =vertcat(s.Position);
    
    
    
    EyeBlink = vertcat(s.EyeBlink);
    EyeBlink(2:end) = diff(EyeBlink);
    EyeBlink(EyeBlink > -2*std(EyeBlink)) = 0;
    EyeBlink(EyeBlink < -2*std(EyeBlink)) = 1;
    EyeBlink(Laser>0)=0;
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
    h1.Position = [0 40 Scr(3)/2 Scr(4)-120];
    subplot(7,4,1:4)
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
    A = 1:length(LaserOnsetFrame);
    B = A(index);
    for i=1:length(LaserOnsetFrame)
        subplot(7,4,i+4)
        
        if LaserOnsetFrame(B(i))-20>0
            plot(Xaxis,Positions(LaserOnsetFrame(B(i))-20:LaserOnsetFrame(B(i))+300),'b-')
            hold on
            plot(Xaxis,2*Laser(LaserOnsetFrame(B(i))-20:LaserOnsetFrame(B(i))+300)+250,'r-')
            plot(Xaxis,200*ForelimbMove(LaserOnsetFrame(B(i))-20:LaserOnsetFrame(B(i))+300),'g-')
            plot([-20*30/1000 300*30/1000],[236 236],'k:')
            plot(Xaxis,200*EyeBlink(LaserOnsetFrame(B(i))-20:LaserOnsetFrame(B(i))+300)+300,'k-')
            plot(Xaxis,Speed(LaserOnsetFrame(B(i))-20:LaserOnsetFrame(B(i))+300),'c-')
            plot(Xaxis,ChR2Laser(LaserOnsetFrame(B(i))-20:LaserOnsetFrame(B(i))+300),'b-')
        else
            plot(Xaxis(20:end),Positions(LaserOnsetFrame(B(i))-1:LaserOnsetFrame(B(i))+300),'b-')
            hold on
            plot(Xaxis(20:end),2*Laser(LaserOnsetFrame(B(i))-1:LaserOnsetFrame(B(i))+300)+250,'r-')
            plot(Xaxis(20:end),200*ForelimbMove(LaserOnsetFrame(B(i))-1:LaserOnsetFrame(B(i))+300),'g-')
            plot([-20 300],[236 236],'k:')
            plot(Xaxis(20:end),200*EyeBlink(LaserOnsetFrame(B(i))-1:LaserOnsetFrame(B(i))+300)+300,'k-')
            plot(Xaxis(20:end),Speed(LaserOnsetFrame(B(i))-1:LaserOnsetFrame(B(i))+300),'c-')
            plot(Xaxis(20:end),ChR2Laser(LaserOnsetFrame(B(i))-1:LaserOnsetFrame(B(i))+300),'b-')
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
end

% figure,imagesc(s(155).Data),colormap(gray)
% SaveFname = [Fname(1:end-12) 'AnalyzedMovie.mat'];
% SaveFname2 = fullfile(Pname,SaveFname);
% save(SaveFname2, 's')