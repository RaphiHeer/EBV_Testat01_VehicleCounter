%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this excercise illustrates the change detection principle based on
% a background estimation obtained through a sliding average
% 
% the algorithmic work is done the function GleitendesMittelFunct()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 'all';
close 'all';

% rectangle stuff
offsetFromTop = 320;
offsetLeft1 = 80;
offsetLeft2 = 250;
offsetLeft3 = 395;
offsetLeft4 = 570;

rectWidth = 90;
rectHeight = 80;

rect1 = [offsetLeft1 offsetFromTop, rectWidth, rectHeight];
rect2 = [offsetLeft2 offsetFromTop, rectWidth, rectHeight];
rect3 = [offsetLeft3 offsetFromTop, rectWidth, rectHeight];
rect4 = [offsetLeft4 offsetFromTop, rectWidth, rectHeight];

% counters
counterLane1 = 0;
counterLane2 = 0;
counterLane3 = 0;
counterLane4 = 0;

carDetectedLane1 = false;
carDetectedLane2 = false;
carDetectedLane3 = false;
carDetectedLane4 = false;

% image stuff
imgFolderPath = '../image_database/gram-rtm_bw/';
backgroundImg = imread(strcat(imgFolderPath, 'Background_GM.png'));

Params = struct();
Params.AvgFactor = 0.99;%the average factor determines the speed of adaptation 
Params.Threshold = 10;%this is the threshold value (chosen manually)

minPixelForCars = 15;

% structure elements
SE1 = strel('rectangle', [7 4]);
SE2 = strel('disk', 10, 4);

for Index = 1 : 400
    FileName = strcat(imgFolderPath, sprintf('image%06d', Index), '.jpg');
    ImageAct = imread(FileName);
    
    % calculate the different images:
    % image 2: Difference between actual image and background
    [ThreshImage, DiffImage, BackGround] = GleitendesMittelFunct(ImageAct, backgroundImg, Params);
    % image 3: Open function over image 2
    TreshImageOpen = imopen(ThreshImage, SE1);
    % image 4: Close function over image 3
    TreshImageClose = imclose(TreshImageOpen, SE2);
    
    % Get pixel sum of each 'object' in each rectangle
    laneMatrix1 = TreshImageClose(offsetFromTop:offsetFromTop+rectHeight, offsetLeft1:offsetLeft1+rectWidth);
    pixelSumLane1 = sum(sum(laneMatrix1) > 1);
    
    laneMatrix2 = TreshImageClose(offsetFromTop:offsetFromTop+rectHeight, offsetLeft2:offsetLeft2+rectWidth);
    pixelSumLane2 = sum(sum(laneMatrix2) > 1);
    
    laneMatrix3 = TreshImageClose(offsetFromTop:offsetFromTop+rectHeight, offsetLeft3:offsetLeft3+rectWidth);
    pixelSumLane3 = sum(sum(laneMatrix3) > 1);
    
    laneMatrix4 = TreshImageClose(offsetFromTop:offsetFromTop+rectHeight, offsetLeft4:offsetLeft4+rectWidth);
    pixelSumLane4 = sum(sum(laneMatrix4) > 1);
    
    % Determine if car is detected and increment counter
    if (carDetectedLane1 == false) && pixelSumLane1 > minPixelForCars
        counterLane1 = counterLane1 + 1;
        carDetectedLane1 = true;
    elseif (carDetectedLane1 == true) && pixelSumLane1 < minPixelForCars
        carDetectedLane1 = false;
    end
    
    if (carDetectedLane2 == false) && pixelSumLane2 > minPixelForCars
        counterLane2 = counterLane2 + 1;
        carDetectedLane2 = true;
    elseif (carDetectedLane2 == true) && pixelSumLane2 < minPixelForCars 
        carDetectedLane2 = false;
    end
    
    if (carDetectedLane3 == false) && pixelSumLane3 > minPixelForCars
        counterLane3 = counterLane3 + 1;
        carDetectedLane3 = true;
    elseif (carDetectedLane3 == true) && pixelSumLane3 < minPixelForCars
        carDetectedLane3 = false;
    end
    
    if (carDetectedLane4 == false) && pixelSumLane4 > minPixelForCars
        counterLane4 = counterLane4 + 1;
        carDetectedLane4 = true;
    elseif (carDetectedLane4 == true) && pixelSumLane4 < minPixelForCars
        carDetectedLane4 = false;
    end
    
    if(carDetectedLane1) colorRect1 = 'g'; else colorRect1 = 'r'; end
    if(carDetectedLane2) colorRect2 = 'g'; else colorRect2 = 'r'; end
    if(carDetectedLane3) colorRect3 = 'g'; else colorRect3 = 'r'; end
    if(carDetectedLane4) colorRect4 = 'g'; else colorRect4 = 'r'; end
    
    % Image 1: Actual image + lane counter
    figure(1);subplot(2,2,1);
    imshow(ImageAct);
    title(sprintf('Image Nr. %06d', Index));
    rectangle('Position', rect1, 'EdgeColor',colorRect1, 'LineWidth',2);
    rectangle('Position', rect2, 'EdgeColor',colorRect2, 'LineWidth',2);
    rectangle('Position', rect3, 'EdgeColor',colorRect3, 'LineWidth',2);
    rectangle('Position', rect4, 'EdgeColor',colorRect4, 'LineWidth',2);
    
    text(offsetLeft1, offsetFromTop - 50, num2str(counterLane1), 'color', 'b');
    text(offsetLeft2, offsetFromTop - 50, num2str(counterLane2), 'color', 'b');
    text(offsetLeft3, offsetFromTop - 50, num2str(counterLane3), 'color', 'b');
    text(offsetLeft4, offsetFromTop - 50, num2str(counterLane4), 'color', 'b');
    
    % Image 2: Difference between actual image and background
    subplot(2,2,2);
    imshow(ThreshImage, []);
    title('Image changes');
    
    % Image 3: Open image
    subplot(2,2,3);
    imshow(TreshImageOpen, []);
    title('Opening of foreground');
    
    % Image 4: Close image
    subplot(2, 2, 4);
    imshow(TreshImageClose, []);
    title('opening and closure of foreground');
    rectangle('Position', rect1, 'EdgeColor',colorRect1, 'LineWidth',2);
    rectangle('Position', rect2, 'EdgeColor',colorRect2, 'LineWidth',2);
    rectangle('Position', rect3, 'EdgeColor',colorRect3, 'LineWidth',2);
    rectangle('Position', rect4, 'EdgeColor',colorRect4, 'LineWidth',2);
    
    text(offsetLeft1, offsetFromTop - 50, num2str(pixelSumLane1), 'color', 'b');
    text(offsetLeft2, offsetFromTop - 50, num2str(pixelSumLane2), 'color', 'b');
    text(offsetLeft3, offsetFromTop - 50, num2str(pixelSumLane3), 'color', 'b');
    text(offsetLeft4, offsetFromTop - 50, num2str(pixelSumLane4), 'color', 'b');        
       
    %without pause images are not shown (may dep. on Matlab version)
    pause(0.05);
end
    
    
    
    
    
    
    
    
    
    