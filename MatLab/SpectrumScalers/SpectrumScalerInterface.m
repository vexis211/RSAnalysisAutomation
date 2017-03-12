classdef SpectrumScalerInterface < handle
    %SpectrumScalerInterface Interface for spectrum scalers
        
    methods (Abstract)
        scaledSpectrum = Scale(obj, spectrum)
    end
    
end

