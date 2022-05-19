# AnimalDetection
Animal behavior monitoring &amp; analysis using 3 web cameras
"MouseDetectionTrackBall_VariableIRlength.m"

This code is for analysis of animal behavior in response to the infrared (IR) laser on the left whisker pad.

System requirements:
Matlab (version 2018a) with Signal Processing toolbox, Image Processing toolbox, Statistics and Machine learning toolbox.
This code is running on Windows 10 PC.

Installation guide:
Put "MouseDetectionTrackBall_VariableIRlength.m" into your Matlab path.
If you have already installed Matlab, typical installation time is a few seconds.

Demo and Instruction for use:
(1) This code was written in Matlab (version 2018a).
    You may also need Signal Processing toolbox, Image Processing toolbox, Statistics and Machine learning toolbox with Matlab.
(2) Video image preparation.
This code uses the frames combined from three cameras at different positions (see "SampleFrame.png").
Note that the regions of interest (ROI) for analysis are fixed, so if you use this code, you may need to provide the video data acquired from the same positions.
Otherwise, you may change the ROI positions depending on the acquired image.
(3) This code automatically detects the experimental condition such as the length of IR laser on whisker pad and 473nm light stimulation on brain surface.
(4) Every parameter of animal behavior were collected and analysed based on the change of image inside each ROI. 
(5) When Matlab finishes analysis, Matlab will output the data and figures (samples: "Samples_Alltrialdata.png", "BarGraph.png", and "Eye.png").
(6) The data were gathered and used for population analysis.
(7) Total expected runtime is 5 min.
