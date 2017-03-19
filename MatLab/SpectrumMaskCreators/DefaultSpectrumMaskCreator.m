classdef DefaultSpectrumMaskCreator < SpectrumMaskCreatorInterface
    %DefaultSpectrumMaskCreator Creates mask for spectrum according provided parameters
    
    properties (Access = private)
        CHRange Range
        OHRange Range
        CellThreshold double
        PureWaterThreshold double
        NumberOfBorderPoints double
        InterpolationMethod InterpolationMethod
    end
    
    methods
        function obj = DefaultSpectrumMaskCreator(chRange, ohRange, ...
                cellThreshold, pureWaterThreshold, numberOfBorderPoints, interpolationMethod)
            assert(isa(chRange, 'Range'), 'chRange must be of type "Range"');
            assert(chRange.From > 0, 'chRange.From must be more then 0');
            assert(isa(ohRange, 'Range'), 'ohRange must be of type "Range"');
            assert(ohRange.From > 0, 'ohRange.From must be more then 0');
            assert(cellThreshold > 0, 'cellThreshold must be more then 0');
            assert(pureWaterThreshold > 0, 'cellThreshold must be more then 0');
            assert(numberOfBorderPoints > 0, 'numberOfBorderPoints must be more then 0');
            
            obj.CHRange = chRange;
            obj.OHRange = ohRange;
            obj.CellThreshold = cellThreshold;
            obj.PureWaterThreshold = pureWaterThreshold;
            obj.NumberOfBorderPoints = numberOfBorderPoints;
            obj.InterpolationMethod = interpolationMethod;
        end
        
        function [cellMask, pureWaterMask] = CreateMask(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"');

            spectrumCount = size(spectrum.Data, 1);
            cellMask = zeros(spectrumCount);
            pureWaterMask = zeros(spectrumCount);
            
            chRange = obj.CHRange;
            cellThreshold = obj.CellThreshold;
            ohRange = obj.OHRange;
            pureWaterThreshold = obj.PureWaterThreshold;
            numberOfBorderPoints = obj.NumberOfBorderPoints;
            interpolationMethodChar = lower(char(obj.InterpolationMethod));
            
            waveNumbers = spectrum.WaveNumbers;
            data = spectrum.Data;
                
            parfor i=1:spectrumCount
                values = data(i);
                % If spectrum has significant C-H range we mark it as part of cell
                isCell = HasSignificantRange(waveNumbers, values, chRange, ...
                    cellThreshold, numberOfBorderPoints, interpolationMethodChar);
                if (isCell)
                    cellMask(i) = 1;
                else
                    % If spectrum is not from cell and there is significant 0-H range,
                    % we mark it as pure water
                    isPureWater = HasSignificantRange(waveNumbers, values, ohRange, ...
                        pureWaterThreshold, numberOfBorderPoints, interpolationMethodChar);
                    if (isPureWater)
                        pureWaterMask(i) = 1;
                    end
                end
            end
        end
    end
    
    methods (Static)        
        function hasRange = HasSignificantRange(waveNumbers, values, range, ...
                threshold, numberOfBorderPoints, interpolationMethod)
            % Take couple of first and last points in range and create 'function' based on these points
            rangeStartIndex = find(waveNumbers >= range.From, 1);
            rangeEndIndex = find(waveNumbers <= range.To, 1, 'last');
			rangeWaveNumbers = waveNumbers(rangeStartIndex:rangeEndIndex);
            bordersWaveNumbers = [waveNumbers(rangeStartIndex:rangeStartIndex+numberOfBorderPoints-1) ...
                waveNumbers(rangeEndIndex-numberOfBorderPoints+1:rangeEndIndex)];
            
			bordersValues = [values(rangeStartIndex:rangeStartIndex+numberOfBorderPoints-1) ...
                values(rangeEndIndex-numberOfBorderPoints+1:rangeEndIndex)];
            interpolatedValues = interp1(bordersWaveNumbers, bordersValues, ...
                rangeWaveNumbers, interpolationMethod);

            % Substract found values from spectrum values in range
			rangeValues = values(rangeStartIndex:rangeEndIndex);
            differenceValues = rangeValues - interpolatedValues;
            
            % Get area under result 'function' - 'integral'
            % Spectrum is equidistant -> we can get average and multiply by range
            % TODO is it ok? - what about border values?
            % TODO is it ok? - what range values to use?
            area = mean(differenceValues) * (range.To - range.From);
                        
            % If area is bigger then threshold, we mark it is significant
            hasRange = area > threshold;
        end
    end    
end



