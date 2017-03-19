classdef EquidistantSpectrumScaler < SpectrumScalerInterface
    %EquidistantSpectrumScaler Scales spectrum equidistantly according provided parameters
    
    properties (Access = private)
        InterpolationMethod InterpolationMethod
        NewWaveNumbers double            
    end
    
    methods
        function obj = EquidistantSpectrumScaler(interpolationMethod, spectrumRange, step)
            assert(isa(interpolationMethod, 'InterpolationMethod'), 'interpolationMethod must be of type "InterpolationMethod"');
            assert(isa(spectrumRange, 'Range'), 'spectrumRange must be of type "Range"');
            assert(spectrumRange.From > 0, 'spectrumRange.From must be more then 0');
            assert(step > 0, 'step must be more then 0');
            
            obj.InterpolationMethod = interpolationMethod;
            obj.NewWaveNumbers = (spectrumRange.From:step:spectrumRange.To);
        end
        
        function scaledSpectrum = Scale(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"')

            spectrumCount=size(spectrum.Data, 1);
            newData=zeros(spectrumCount, length(obj.NewWaveNumbers));
            interpolationMethodChar = lower(char(obj.InterpolationMethod));
            
            oldWaveNumbers = spectrum.WaveNumbers;
            newWaveNumbers = obj.NewWaveNumbers;
            oldData = spectrum.Data;
            parfor i=1:spectrumCount
                newData(i,:) = interp1(oldWaveNumbers, oldData(i,:), newWaveNumbers, interpolationMethodChar);
            end            
            newName = [spectrum.Name '_scaled'];
            
            scaledSpectrum = Spectrum(newName, spectrum.TimeStamp, ...
                spectrum.SizeX, spectrum.SizeY, obj.NewWaveNumbers, newData);
        end
    end    
end



