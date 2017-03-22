classdef DefaultMainCellMaskIdentifier < MainCellMaskIdentifierInterface
    %DefaultMainCellMaskIdentifier Identifies main cell mask in cell mask
    
    properties (Access = private)
        Threshold double
    end
    
    methods
        function obj = DefaultMainCellMaskIdentifier(threshold)
            assert(threshold > 0, 'threshold must be more then 0');
            
            obj.Threshold = threshold;
        end
        
        function [hasValidCell, mainCellMask] = IdentifyMainCell(obj, cellMask)
            assert(ismatrix(cellMask), 'cellMask must matrix');
            
            % Start from middle and try to reach some cell point
            firstDimLength = size(cellMask, 1);
            secondDimLength = size(cellMask, 2);
            
            firstDimMiddle = fix(firstDimLength, 2);
            secondDimMiddle = fix(secondDimLength, 2);
            
            %TODO
            
            % Check if cell does not touch border. If it touches border, cell is invalid, because we
            % cannot be sure whole cell was measured.
            
            %TODO
            
            % Take couple of first and last points in range and create 'function' based on these points
            rangeStartIndex = find(waveNumbers >= obj.Range.From, 1);
            rangeEndIndex = find(waveNumbers <= obj.Range.To, 1, 'last');
			rangeWaveNumbers = waveNumbers(rangeStartIndex:rangeEndIndex);
            bordersWaveNumbers = [waveNumbers(rangeStartIndex:rangeStartIndex+obj.NumberOfBorderPoints-1) ...
                waveNumbers(rangeEndIndex-obj.NumberOfBorderPoints+1:rangeEndIndex)];
            
			bordersValues = [values(rangeStartIndex:rangeStartIndex+obj.NumberOfBorderPoints-1) ...
                values(rangeEndIndex-obj.NumberOfBorderPoints+1:rangeEndIndex)];
            interpolatedValues = interp1(bordersWaveNumbers, bordersValues, ...
                rangeWaveNumbers, obj.InterpolationMethod);

            % Substract found values from spectrum values in range
			rangeValues = values(rangeStartIndex:rangeEndIndex);
            differenceValues = rangeValues - interpolatedValues;
            
            % Get area under result 'function' - 'integral'
            % Spectrum is equidistant -> we can get average and multiply by range
            % TODO is it ok? - what about border values?
            % TODO is it ok? - what range values to use?
            area = mean(differenceValues) * (obj.Range.To - obj.Range.From);
                        
            % If area is bigger then threshold, we mark it is significant
            isSignificant = area > obj.Threshold;
        end
    end    
end
