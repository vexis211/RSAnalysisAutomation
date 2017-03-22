classdef MaskPlotterInterface < handle
    %MaskPlotterInterface Interface for mask plotters
    
    methods (Abstract)
        Plot(obj, mask, sizeX, sizeY, title)
    end
    
end

