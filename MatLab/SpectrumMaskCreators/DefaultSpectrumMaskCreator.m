classdef DefaultSpectrumMaskCreator < SpectrumMaskCreatorInterface
    %DefaultSpectrumMaskCreator Creates mask for spectrum according provided parameters
    
    properties (Access = private)
        CellRangeSignificancyIdentifier RangeSignificancyIdentifierInterface
        WaterRangeSignificancyIdentifier RangeSignificancyIdentifierInterface
    end
    
    methods
        function obj = DefaultSpectrumMaskCreator(cellRangeSignificancyIdentifier, ...
                waterRangeSignificancyIdentifier)            
            obj.CellRangeSignificancyIdentifier = cellRangeSignificancyIdentifier;
            obj.WaterRangeSignificancyIdentifier = waterRangeSignificancyIdentifier;
        end
        
        function [cellMask, pureWaterMask] = CreateMask(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"');

            spectrumCount = size(spectrum.Data, 1);
            cellMask = zeros(spectrumCount);
            pureWaterMask = zeros(spectrumCount);
                        
            waveNumbers = spectrum.WaveNumbers;
            data = spectrum.Data;
            
            isCellRangeSignificant = @(values) obj.CellRangeSignificancyIdentifier.IsRangeSignificant(...
                waveNumbers, values);
            isWaterRangeSignificant = @(values) obj.WaterRangeSignificancyIdentifier.IsRangeSignificant(...
                waveNumbers, values);
            
            parfor i=1:spectrumCount
                values = data(i);
                % If spectrum has significant C-H range we mark it as part of cell
                isCell = isCellRangeSignificant(waveNumbers, values);
                if (isCell)
                    cellMask(i) = 1;
                else
                    % If spectrum is not from cell and there is significant 0-H range,
                    % we mark it as pure water
                    isPureWater = isWaterRangeSignificant(waveNumbers, values);
                    if (isPureWater)
                        pureWaterMask(i) = 1;
                    end
                end
            end
        end
    end
end



