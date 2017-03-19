classdef RangeSignificancyIdentifierInterface
    %RangeSignificancyIdentifierInterface Identifies if range values are significant
    
    methods (Abstract)
        isSignificant = IsRangeSignificant(obj, waveNumbers, values)
    end    
end
