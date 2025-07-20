% MicroCodes-samples
% This script generates GDS files for microCodes with multiple encoding schemes
% 
% Copyright (c) 2025 Aref Valiopur
% GitHub: github.com/Arefvp/MicroCodes
% 
% ---> Please refer to the GitHub repository above for information <---
% ---> on how to cite this work. <---
% 
% ---> This code needs the following library: https://sites.google.com/site/ulfgri/numerical/gdsii-toolbox.
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.



% Clear Matlab workspace
clear;
close all;
clc;

% Header text for the generated design
headerText = 'MicroCodes-samples 2025';
githubText = 'github.com/Arefvp/MicroCodes';

% GDS Layer definitions
primaryLayer = 11;      % layer for first mask
alignmentLayer = 31;    % layer for alignment marks

% Design parameters
largePeriod = 58;       % distance parameter for structures
sizeInMm = 15;          % design size in millimeters
gridSizeX = floor((sizeInMm*1000)/largePeriod); % filter size; has to be square
gridSizeY = gridSizeX;  % max is 1024 (10bit)

% Display grid size
disp(['Grid size: ' num2str(gridSizeX) 'x' num2str(gridSizeY)]);

% Binary code parameters
numBits = 6;            % number of bits in code
codeBitSize = 5;        % code structure size indicator
originShiftX = ((gridSizeX+1) * largePeriod)/2;
originShiftY = ((gridSizeY+1) * largePeriod)/2;
codeInterval = 5;       % interval between codes

% Create GDS structures
topStructure = gds_structure('BOX_TOP');

% Code positioning offsets
codeShiftX = +25;
codeShiftY = -28;

%% Binary codes section (Most-left)
quadrantOriginX = originShiftX - 30000;
quadrantOriginY = originShiftY ;

for i = 1:gridSizeX 
    for j = 1:gridSizeY
        % Check if point is within circular boundary
        if(((i-gridSizeX/2)^2 + (j-gridSizeY/2)^2) < (((gridSizeX-1)/2)^2))
            % Calculate position shifts
            positionShiftMatrix = [i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY]; 
            
            xShift = i*largePeriod - (codeBitSize*numBits)  - quadrantOriginX + codeShiftX;
            yShift = j*largePeriod + (largePeriod/2) - quadrantOriginY + codeShiftY;

            % Generate binary codes at specific intervals
            if ((mod(i,codeInterval)==1 && mod(j,codeInterval)==0))
                % Skip this case
            elseif ((mod(i,codeInterval)==0 && mod(j,codeInterval)==0))
                % Create binary code boundary
                codeVertices = [(2*codeBitSize)+xShift, -codeBitSize+yShift; 
                    (2*codeBitSize)+xShift, -(3*codeBitSize)+yShift; 
                    0+xShift, -(3*codeBitSize)+yShift;
                    0+xShift, (5*codeBitSize)+yShift; 
                    (2*codeBitSize)+xShift, (5*codeBitSize)+yShift; 
                    (2*codeBitSize)+xShift, codeBitSize+yShift];   
                
                % Process X-coordinate bits
                for bitIndex = numBits+1:-1:1
                    iBitValue = i/codeInterval*2;
                    if (bitget(iBitValue,bitIndex+1)==0 && bitget(iBitValue,bitIndex)==0)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, codeBitSize+yShift];
                    elseif (bitget(iBitValue,bitIndex+1)==0 && bitget(iBitValue,bitIndex)==1)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, codeBitSize+yShift; 
                            (numBits+2-bitIndex)*(2*codeBitSize)+xShift, (3*codeBitSize)+yShift];
                    elseif (bitget(iBitValue,bitIndex+1)==1 && bitget(iBitValue,bitIndex)==0)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, (3*codeBitSize)+yShift; 
                            (numBits+2-bitIndex)*(2*codeBitSize)+xShift, codeBitSize+yShift];
                    elseif (bitget(iBitValue,bitIndex+1)==1 && bitget(iBitValue,bitIndex)==1)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, (3*codeBitSize)+yShift];
                    end
                end
                
                % Process Y-coordinate bits
                for bitIndex = 1:numBits+1
                    jBitValue = j/codeInterval*2;
                    if (bitget(jBitValue,bitIndex+1)==0 && bitget(jBitValue,bitIndex)==0)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, -codeBitSize+yShift];
                    elseif (bitget(jBitValue,bitIndex+1)==1 && bitget(jBitValue,bitIndex)==0)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, -codeBitSize+yShift; 
                            (numBits+2-bitIndex)*(2*codeBitSize)+xShift, -(3*codeBitSize)+yShift];
                    elseif (bitget(jBitValue,bitIndex+1)==0 && bitget(jBitValue,bitIndex)==1)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, -(3*codeBitSize)+yShift; 
                            (numBits+2-bitIndex)*(2*codeBitSize)+xShift, -codeBitSize+yShift];
                    elseif (bitget(jBitValue,bitIndex+1)==1 && bitget(jBitValue,bitIndex)==1)
                        codeVertices = [codeVertices; (numBits+2-bitIndex)*(2*codeBitSize)+xShift, -(3*codeBitSize)+yShift];
                    end
                end
                
                boundaryElement = gds_element('boundary', 'xy', codeVertices, 'layer', primaryLayer); 
                topStructure = add_element(topStructure, boundaryElement);
            end
        end
    end
    disp(['Binary codes progress: ' num2str(i) '/' num2str(gridSizeX)]);
end

%% Numeric labels section (Middle-left)
quadrantOriginX = originShiftX - 10000;
quadrantOriginY = originShiftY ;

for i = 1:gridSizeX 
    for j = 1:gridSizeY
        % Check if point is within circular boundary
        if(((i-gridSizeX/2)^2 + (j-gridSizeY/2)^2) < (((gridSizeX-1)/2)^2))
            positionShiftMatrix = [i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY]; 
            
            xShift = i*largePeriod - (codeBitSize*numBits)  - quadrantOriginX + codeShiftX;
            yShift = j*largePeriod + (largePeriod/2)  - quadrantOriginY + codeShiftY;

            % Generate numeric labels at specific intervals
            if ((mod(i,codeInterval)==1 && mod(j,codeInterval)==0))
                % Skip this case
            elseif ((mod(i,codeInterval)==0 && mod(j,codeInterval)==0))
                % Create numeric text label
                numericLabel = [num2str(i/5), '-', num2str(j/5)];
                textElement = gdsii_pathtext(numericLabel, [xShift,yShift], 40, [], 0.15*60);
                textElement.layer = primaryLayer;
                topStructure = add_element(topStructure, textElement);           
            end
        end
    end
    disp(['Numeric labels progress: ' num2str(i) '/' num2str(gridSizeX)]);
end

%% PLANET barcode section (Middle-right)
quadrantOriginX = originShiftX + 10000;
quadrantOriginY = originShiftY ;

for i = 1:gridSizeX 
    for j = 1:gridSizeY
        % Check if point is within circular boundary
        if(((i-gridSizeX/2)^2 + (j-gridSizeY/2)^2) < (((gridSizeX-1)/2)^2))
            positionShiftMatrix = [i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY]; 
            
            xShift = i*largePeriod - (codeBitSize*numBits)  - quadrantOriginX + codeShiftX;
            yShift = j*largePeriod + (largePeriod/2) - quadrantOriginY + codeShiftY;

            % Generate PLANET barcodes at specific intervals
            if ((mod(i,codeInterval)==1 && mod(j,codeInterval)==0))
                % Skip this case
            elseif ((mod(i,codeInterval)==0 && mod(j,codeInterval)==0))
                % Create PLANET barcode
                iCoordinate = i/5;
                jCoordinate = j/5;
                planetBarcode = ['|' PLANET((uint8(iCoordinate)-mod(iCoordinate,10))/10) ...
                    PLANET(mod(iCoordinate,10)) PLANET((uint8(jCoordinate)-mod(jCoordinate,10))/10) ...
                    PLANET(mod(jCoordinate,10)) '|'];
                
                barcodeElement = gdsii_pathtext(planetBarcode, [xShift,yShift], 20, [], 0.15*25);
                barcodeElement.layer = primaryLayer;
                topStructure = add_element(topStructure, barcodeElement);           
            end
        end
    end
    disp(['PLANET barcode progress: ' num2str(i) '/' num2str(gridSizeX)]);
end

%% Ternary thickness barcode section (Most-right)
quadrantOriginX = originShiftX + 30000;
quadrantOriginY = originShiftY;

for i = 1:gridSizeX 
    for j = 1:gridSizeY
        % Check if point is within circular boundary
        if(((i-gridSizeX/2)^2 + (j-gridSizeY/2)^2) < (((gridSizeX-1)/2)^2))
            positionShiftMatrix = [i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY;...
                i*largePeriod-quadrantOriginX, j*largePeriod-quadrantOriginY]; 
            
            xShift = i*largePeriod - (codeBitSize*numBits)  - quadrantOriginX + codeShiftX;
            yShift = j*largePeriod + (largePeriod/2)  - quadrantOriginY + codeShiftY;

            % Generate ternary thickness barcodes at specific intervals
            if ((mod(i,codeInterval)==1 && mod(j,codeInterval)==0))
                % Skip this case
            elseif ((mod(i,codeInterval)==0 && mod(j,codeInterval)==0))
                % Base barcode structure
                shiftPositions = [xShift,yShift; xShift,yShift; xShift,yShift; xShift,yShift; xShift,yShift];
                thicknessBarcodeShift = [1,0; 1,0; 1,0; 1,0; 1,0]*15;
                
                % Basic barcode elements
                basicVertices = [0,0; 10,0; 10,10; 0,10; 0,0] + shiftPositions;
                barLength = 50;
                
                % Create basic barcode elements
                basicElement = gds_element('boundary', 'xy', basicVertices, 'layer', primaryLayer);
                topStructure = add_element(topStructure, basicElement);   

                secondVertices = [0,0; 10,0; 10,10; 0,10; 0,0] + shiftPositions + 5*thicknessBarcodeShift;
                secondElement = gds_element('boundary', 'xy', secondVertices, 'layer', primaryLayer);
                topStructure = add_element(topStructure, secondElement);  

                endVertices = [0,barLength-10; 10,barLength-10; 10,barLength; 0,barLength; 0,barLength-10] + shiftPositions + 10*thicknessBarcodeShift;
                endElement = gds_element('boundary', 'xy', endVertices, 'layer', primaryLayer);
                topStructure = add_element(topStructure, endElement);  
                
                % Ternary encoding parameters
                normalWidth = 5;
                wideWidthAdd = 2.5; 
                
                % Process X-coordinate ternary encoding (4 digits)
                for digitPosition = 1:4
                    iValue = i/codeInterval;
                    digitValue = mod(floor(iValue/power(3,digitPosition-1)), 3);
                    
                    if digitValue == 0
                        % No additional element for 0
                    elseif digitValue == 1
                        % Normal width bar
                        normalVertices = [0,0; normalWidth,0; normalWidth,barLength; 0,barLength; 0,0] + ...
                            shiftPositions + (5-digitPosition)*thicknessBarcodeShift;
                        normalElement = gds_element('boundary', 'xy', normalVertices, 'layer', primaryLayer);
                        topStructure = add_element(topStructure, normalElement); 
                    elseif digitValue == 2
                        % Wide bar
                        wideVertices = [-wideWidthAdd,0; normalWidth+wideWidthAdd,0; normalWidth+wideWidthAdd,barLength; 
                            -wideWidthAdd,barLength; -wideWidthAdd,0] + shiftPositions + (5-digitPosition)*thicknessBarcodeShift;
                        wideElement = gds_element('boundary', 'xy', wideVertices, 'layer', primaryLayer);
                        topStructure = add_element(topStructure, wideElement);
                    end
                end

                % Process Y-coordinate ternary encoding (4 digits)
                for digitPosition = 1:4
                    jValue = j/codeInterval;
                    digitValue = mod(floor(jValue/power(3,digitPosition-1)), 3);
                    
                    if digitValue == 0
                        % No additional element for 0
                    elseif digitValue == 1
                        % Normal width bar
                        normalVertices = [0,0; normalWidth,0; normalWidth,barLength; 0,barLength; 0,0] + ...
                            shiftPositions + (9-digitPosition)*thicknessBarcodeShift;
                        normalElement = gds_element('boundary', 'xy', normalVertices, 'layer', primaryLayer);
                        topStructure = add_element(topStructure, normalElement); 
                    elseif digitValue == 2
                        % Wide bar
                        wideVertices = [-wideWidthAdd,0; normalWidth+wideWidthAdd,0; normalWidth+wideWidthAdd,barLength; 
                            -wideWidthAdd,barLength; -wideWidthAdd,0] + shiftPositions + (9-digitPosition)*thicknessBarcodeShift;
                        wideElement = gds_element('boundary', 'xy', wideVertices, 'layer', primaryLayer);
                        topStructure = add_element(topStructure, wideElement);
                    end
                end
            end
        end
    end
    disp(['Ternary barcode progress: ' num2str(i) '/' num2str(gridSizeX)]);
end

%% Complementary structures
% Add text elements
headerTextElement = gdsii_pathtext(headerText, [-8000, -20000], 800, [], 0.15*800);
githubTextElement = gdsii_pathtext(githubText, [-8000, -22000], 800, [], 0.15*800);
headerTextElement.layer = alignmentLayer;
githubTextElement.layer = alignmentLayer;

% Add all elements to the structure
topStructure = add_element(topStructure, headerTextElement, githubTextElement);

%% Create and write GDS library
gdsLibrary = gds_library('uCodes.DB', 'uunit', 1e-6, 'dbunit', 1e-9, topStructure);
write_gds_library(gdsLibrary, '!microCodes_Sample.gds');

disp('GDS file generation complete: !codedFilter_all.gds');

%% Helper Functions

function outputString = PLANET(inputDigit)
    % PLANET barcode encoding function
    % Converts single digit (0-9) to PLANET barcode representation
    % Uses combination of tall (|) and short (I) bars
    
    switch inputDigit
        case 0
            outputString = 'II|||';
        case 1
            outputString = '|||II';
        case 2
            outputString = '||I|I';
        case 3
            outputString = '||II|';
        case 4
            outputString = '|I||I';
        case 5
            outputString = '|I|I|';
        case 6
            outputString = '|II||';
        case 7
            outputString = 'I|||I';
        case 8
            outputString = 'I||I|';
        case 9
            outputString = 'I|I||';
        otherwise
            error('Invalid input digit. Must be 0-9.');
    end
end
