classdef SpectrumMaskCreatorInterface < handle
    %SpectrumMaskCreatorInterface Interface for spectrum mask creatrs
        
    methods (Abstract)
        [cellMask, pureWaterMask] = CreateMask(obj, spectrum)
    end
    
end

