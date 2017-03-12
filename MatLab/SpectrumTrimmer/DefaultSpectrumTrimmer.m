classdef DefaultSpectrumTrimmer < SpectrumTrimmerInterface
    %DefaultSpectrumTrimmer Trims spectrum according provided parameters
    
    properties (Access = private)
        SpectrumStart double
        SpectrumEnd double            
    end
    
    methods
        function obj = DefaultSpectrumTrimmer(spectrumStart,spectrumEnd)
            assert(spectrumStart > 0, 'spectrumStart must be more then 0')
            assert(spectrumEnd > spectrumStart, 'spectrumEnd must be more then spectrumStart')
            
            obj.SpectrumStart = spectrumStart;
            obj.SpectrumEnd = spectrumEnd;
        end
        
        function trimmedSpectrum = Trim(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"')

            oldWaveNumbers = spectrum.WaveNumbers;
            startIndex = find(oldWaveNumbers >= obj.SpectrumStart, 1);
            endIndex = find(oldWaveNumbers <= obj.SpectrumEnd, 1, 'last');
            
            newWaveNumbers = oldWaveNumbers(startIndex:endIndex);
            newData = spectrum.Data(:, startIndex:endIndex);
            newName = [spectrum.Name '_trimmed'];
            
            trimmedSpectrum = Spectrum(newName, spectrum.TimeStamp, ...
                spectrum.SizeX, spectrum.SizeY, newWaveNumbers, newData);
        end
    end    
end



