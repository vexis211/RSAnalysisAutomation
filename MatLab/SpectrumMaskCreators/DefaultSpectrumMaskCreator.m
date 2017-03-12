classdef DefaultSpectrumMaskCreator < SpectrumMaskCreatorInterface
    %DefaultSpectrumMaskCreator Creates mask for spectrum according provided parameters
    
    properties (Access = private)
        CHRange Range
        OHRange Range
        CellThreshold double
    end
    
    methods
        function obj = DefaultSpectrumMaskCreator(chRange, ohRange, cellThreshold)
            assert(isa(chRange, 'Range'), 'chRange must be of type "Range"');
            assert(chRange.From > 0, 'chRange.From must be more then 0');
            assert(isa(ohRange, 'Range'), 'ohRange must be of type "Range"');
            assert(ohRange.From > 0, 'ohRange.From must be more then 0');
            assert(cellThreshold > 0, 'cellThreshold must be more then 0');
            
            obj.CHRange = chRange;
            obj.OHRange = ohRange;
            obj.CellThreshold = cellThreshold;
        end
        
        function [cellMask, pureWaterMask] = CreateMask(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"');

            
            % TODO
        end
    end    
end



