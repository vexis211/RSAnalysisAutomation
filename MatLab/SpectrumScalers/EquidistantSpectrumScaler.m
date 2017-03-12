classdef EquidistantSpectrumScaler < SpectrumScalerInterface
    %EquidistantSpectrumScaler Scales spectrum equidistantly according provided parameters
    
    properties (Access = private)
        ScaleMethod EquidistantScaleMethod
        NewWaveNumbers double            
    end
    
    methods
        function obj = EquidistantSpectrumScaler(scaleMethod, spectrumStart,spectrumEnd,step)
            assert(isa(scaleMethod, 'EquidistantScaleMethod'), 'scaleMethod must be of type "EquidistantScaleMethod"')
            assert(spectrumStart > 0, 'spectrumStart must be more then 0')
            assert(spectrumEnd > spectrumStart, 'spectrumEnd must be more then spectrumStart')
            assert(step > 0, 'step must be more then 0')
            
            obj.ScaleMethod = scaleMethod;
            obj.NewWaveNumbers = (spectrumStart:step:spectrumEnd);
        end
        
        function scaledSpectrum = Scale(obj, spectrum)
            assert(isa(spectrum, 'Spectrum'), 'spectrum must be of type "Spectrum"')

            spectrumCount=size(spectrum.Data, 1);
            newData=zeros(spectrumCount, length(obj.NewWaveNumbers));
            scaleMethodChar = lower(char(obj.ScaleMethod));
            
            oldWaveNumbers = spectrum.WaveNumbers;
            newWaveNumbers = obj.NewWaveNumbers;
            oldData = spectrum.Data;
            parfor i=1:spectrumCount
                newData(i,:) = interp1(oldWaveNumbers, oldData(i,:), newWaveNumbers, scaleMethodChar);
            end            
            newName = [spectrum.Name '_scaled'];
            
            scaledSpectrum = Spectrum(newName, spectrum.TimeStamp, ...
                spectrum.SizeX, spectrum.SizeY, obj.NewWaveNumbers, newData);
        end
    end    
end



