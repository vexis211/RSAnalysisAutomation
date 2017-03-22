classdef DefaultSpectrumMaskCreator < SpectrumMaskCreatorInterface
    %DefaultSpectrumMaskCreator Creates mask for spectrum according provided parameters
    
    properties (Access = private)
        CellRangeSignificancyIdentifier
        WaterRangeSignificancyIdentifier
    end
    
    methods
        function obj = DefaultSpectrumMaskCreator(cellRangeSignificancyIdentifier, ...
                waterRangeSignificancyIdentifier)            
            assert(isa(cellRangeSignificancyIdentifier, 'RangeSignificancyIdentifierInterface'), 'spectrum must be of type "RangeSignificancyIdentifierInterface"');
            assert(isa(waterRangeSignificancyIdentifier, 'RangeSignificancyIdentifierInterface'), 'spectrum must be of type "RangeSignificancyIdentifierInterface"');

            obj.CellRangeSignificancyIdentifier = cellRangeSignificancyIdentifier;
            obj.WaterRangeSignificancyIdentifier = waterRangeSignificancyIdentifier;
        end
        
        function [cellMask, pureWaterMask] = CreateMask(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"');

            spectrumCount = size(spectrum.Data, 1);
            cellMask = zeros(spectrumCount, 1);
            pureWaterMask = zeros(spectrumCount, 1);
                        
            waveNumbers = spectrum.WaveNumbers;
            data = spectrum.Data;
            
            isCellRangeSignificant = @(values) obj.CellRangeSignificancyIdentifier.IsRangeSignificant(...
                waveNumbers, values);
            isWaterRangeSignificant = @(values) obj.WaterRangeSignificancyIdentifier.IsRangeSignificant(...
                waveNumbers, values);
            
            for i=1:spectrumCount % TODO parfor
                values = data(i,:);
                % If spectrum has significant C-H range we mark it as part of cell
                isCell = isCellRangeSignificant(values);
                if (isCell)
                    cellMask(i) = 1;
                else
                    % If spectrum is not from cell and there is significant 0-H range,
                    % we mark it as pure water
                    isPureWater = isWaterRangeSignificant(values);
                    if (isPureWater)
                        pureWaterMask(i) = 1;
                    end
                end
            end
        end
    end
end



