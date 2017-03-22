classdef DefaultRangeSignificancyIdentifier < RangeSignificancyIdentifierInterface
    %DefaultRangeSignificancyIdentifier Identifies if range values are significant
    
    properties (Access = private)
        Range Range
        Threshold double
        NumberOfBorderPoints double
        InterpolationMethod InterpolationMethod
    end
    
    methods
        function obj = DefaultRangeSignificancyIdentifier(range, threshold, ...
                numberOfBorderPoints, interpolationMethod)
            assert(isa(range, 'Range'), 'range must be of type "Range"');
            assert(range.From > 0, 'chRange.From must be more then 0');
            assert(numberOfBorderPoints > 0, 'numberOfBorderPoints must be more then 0');
            
            obj.Range = range;
            obj.Threshold = threshold;
            obj.NumberOfBorderPoints = numberOfBorderPoints;
            obj.InterpolationMethod = interpolationMethod;
        end
        
        function isSignificant = IsRangeSignificant(obj, waveNumbers, values)
            % Take couple of first and last points in range and create 'function' based on these points
            rangeStartIndex = find(waveNumbers >= obj.Range.From, 1);
            rangeEndIndex = find(waveNumbers <= obj.Range.To, 1, 'last');
			rangeWaveNumbers = waveNumbers(rangeStartIndex:rangeEndIndex);
            bordersWaveNumbers = [waveNumbers(rangeStartIndex:rangeStartIndex+obj.NumberOfBorderPoints-1) ...
                waveNumbers(rangeEndIndex-obj.NumberOfBorderPoints+1:rangeEndIndex)];
            
			bordersValues = [values(rangeStartIndex:rangeStartIndex+obj.NumberOfBorderPoints-1) ...
                values(rangeEndIndex-obj.NumberOfBorderPoints+1:rangeEndIndex)];
            interpolationMethodChar = lower(char(obj.InterpolationMethod));
            interpolatedValues = interp1(bordersWaveNumbers, bordersValues, ...
                rangeWaveNumbers, interpolationMethodChar);

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
