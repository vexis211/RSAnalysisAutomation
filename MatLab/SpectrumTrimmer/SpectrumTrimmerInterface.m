classdef SpectrumTrimmerInterface < handle
    %SpectrumTrimmerInterface Interface for spectrum trimmers
        
    methods (Abstract)
        trimmedSpectrum = Trim(obj, spectrum)
    end
    
end

