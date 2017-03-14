classdef DefaultSpectrumMaskCreator < SpectrumMaskCreatorInterface
    %DefaultSpectrumMaskCreator Creates mask for spectrum according provided parameters
    
    properties (Access = private)
        CHRange Range
        OHRange Range
        CellThreshold double
        PureWaterThreshold double
    end
    
    methods
        function obj = DefaultSpectrumMaskCreator(chRange, ohRange, ...
                cellThreshold, pureWaterThreshold)
            assert(isa(chRange, 'Range'), 'chRange must be of type "Range"');
            assert(chRange.From > 0, 'chRange.From must be more then 0');
            assert(isa(ohRange, 'Range'), 'ohRange must be of type "Range"');
            assert(ohRange.From > 0, 'ohRange.From must be more then 0');
            assert(cellThreshold > 0, 'cellThreshold must be more then 0');
            assert(pureWaterThreshold > 0, 'cellThreshold must be more then 0');
            
            obj.CHRange = chRange;
            obj.OHRange = ohRange;
            obj.CellThreshold = cellThreshold;
            obj.PureWaterThreshold = pureWaterThreshold;
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
            
            waveNumbers = spectrum.WaveNumbers;
            data = spectrum.Data;
                
            parfor i=1:spectrumCount
                values = data(i);
                isCell = HasSignificantRange(waveNumbers, values, chRange, cellThreshold);
                if (isCell)
                    cellMask(i) = 1;
                else
                    isPureWater = HasSignificantRange(waveNumbers, values, ohRange, pureWaterThreshold);
                    if (isPureWater)
                        pureWaterMask(i) = 1;
                    end
                end
            end
        end
    end
    
    methods (Static)        
        function hasRange = HasSignificantRange(waveNumbers, values, range, threshold)
            % TODO
            hasRange = true;
        end
    end    
end



