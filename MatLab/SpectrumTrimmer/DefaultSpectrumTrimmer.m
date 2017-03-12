classdef DefaultSpectrumTrimmer < SpectrumTrimmerInterface
    %DefaultSpectrumTrimmer Trims spectrum according provided parameters
    
    properties (Access = private)
        SpectrumRange Range           
    end
    
    methods
        function obj = DefaultSpectrumTrimmer(spectrumRange)
            assert(isa(spectrumRange, 'Range'), 'spectrumRange must be of type "Range"');
            assert(spectrumRange.From > 0, 'spectrumRange.From must be more then 0');
            
            obj.SpectrumRange = spectrumRange;
        end
        
        function trimmedSpectrum = Trim(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"');

            oldWaveNumbers = spectrum.WaveNumbers;
            startIndex = find(oldWaveNumbers >= obj.SpectrumRange.From, 1);
            endIndex = find(oldWaveNumbers <= obj.SpectrumRange.To, 1, 'last');
            
            newWaveNumbers = oldWaveNumbers(startIndex:endIndex);
            newData = spectrum.Data(:, startIndex:endIndex);
            newName = [spectrum.Name '_trimmed'];
            
            trimmedSpectrum = Spectrum(newName, spectrum.TimeStamp, ...
                spectrum.SizeX, spectrum.SizeY, newWaveNumbers, newData);
        end
    end    
end



