clear

[file,path] = uigetfile('D:\TrackBallMovie\Current\*info.mat','MultiSelect', 'on');
Savepath = uigetdir('D:\TrackBallMovie\');


Fparts = length(file);
if Fparts>15
    Fparts=1;
end
for i = 1:Fparts
    if Fparts==1
        fn = file;
    else
        fn = file{i};
    end
    disp(['Session ' num2str(i) '/' num2str(Fparts) '...'])
    SaveFileName = [Savepath  '\Combined\' fn(1:end-8) 'Combined.avi'];
    PathCombined =[Savepath  '\Combined'];
    if exist(PathCombined, 'dir')
    else
        mkdir([Savepath  '\Combined'])
    end
    
FileName = [path fn(1:end-8)];
% 'D:\TrackBallMovie\Current\201903151337';
load([FileName 'info.mat']);
% vid2vid3_framedelay = 38;
% vid2vid4_framedelay = 76;
v = VideoReader([FileName 'Vid2.avi']);
vid2Height = v.Height;
vid2Width = v.Width;
k = 1;

disp('Reading frames of movie 1/3...')
while hasFrame(v)
    s(k).Combined(1:vid2Height,1:vid2Width,1:3) = readFrame(v);
    k = k + 1;
end

v = VideoReader([FileName 'Vid3.avi']);
vid3Height = v.Height;
vid3Width = v.Width;
k = 1;

disp('Reading frames of movie 2/3...')
while hasFrame(v)
    s(k+vid2vid3_framedelay).Combined(1:vid3Height,vid2Width+1:vid2Width+vid3Width,1:3) = readFrame(v);
    k = k + 1;
end

v = VideoReader([FileName 'Vid4.avi']);
vid4Height = v.Height;
vid4Width = v.Width;

k = 1;
tic;
disp('Reading frames of movie 3/3...')
while hasFrame(v)
    s(k+vid2vid4_framedelay).Combined(vid2Height+1:vid2Height+vid4Height,1:vid4Width,1:3) = readFrame(v);
    k = k + 1;
end



for j=vid2vid4_framedelay+1:k-200
    F(j-vid2vid4_framedelay)=im2frame(s(j).Combined);
end
disp('Writing ...')

v = VideoWriter(SaveFileName);
open(v)
writeVideo(v,F)
close(v)

disp('Finished!')
Vid2Fname = [FileName 'Vid2.avi'];
movefile(Vid2Fname, Savepath)
Vid3Fname = [FileName 'Vid3.avi'];
movefile(Vid3Fname, Savepath)
Vid4Fname = [FileName 'Vid4.avi'];
movefile(Vid4Fname, Savepath)
MatFname = [FileName 'info.mat'];
movefile(MatFname, Savepath)

end