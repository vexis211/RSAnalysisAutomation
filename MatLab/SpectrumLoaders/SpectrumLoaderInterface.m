classdef SpectrumLoaderInterface < handle
    %SpectrumLoaderInterface Interface for spectrum loaders
        
    methods (Abstract)
        spectrum = Load(obj, filePath)
    end
    
end

