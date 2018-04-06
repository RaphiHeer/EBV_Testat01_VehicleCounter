%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function performs the algorithmic part of a change detection approach
% based on background modelling through a slinding average
%
% the difference between the current (ImageAct) and the background estimation
% (BackGround) and compared to the Threshold for a binarization
% in addition the background estimation is updated through a sliding average
% with rate Params.AvgFactor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ThreshImage, DiffImage, BackGround] = GleitendesMittelFunct(ImageAct, BackGround, Params)

%make everything double
BackGround = double(BackGround);
ImageAct = double(ImageAct);

%calcuate forground estimate
DiffImage = (255+(BackGround - ImageAct))/2;


%estimate new background as sliding average
BackGround = Params.AvgFactor*BackGround+...
                        (1-Params.AvgFactor)*ImageAct;  

    
%calculate the threshold image
ThreshImage = abs(DiffImage-128) > Params.Threshold; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% alternative version -> threshold must be twice as large!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% %calcuate forground estimate
% DiffImage = abs(BackGround-ImageAct);  
% %estimate new background as sliding average
% BackGround = Params.AvgFactor*BackGround+...
%                         (1-Params.AvgFactor)*ImageAct;  
% 
%     
% %calculate the threshold image
% ThreshImage = DiffImage > Params.Threshold; 