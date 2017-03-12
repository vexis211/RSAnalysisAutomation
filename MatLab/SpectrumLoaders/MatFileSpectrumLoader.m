classdef MatFileSpectrumLoader < SpectrumLoaderInterface
    %MatFileSpectrumLoader Loads spectrum from mat file
    
    methods        
        function spectrum = Load(~, filePath)
            assert(exists(filePath, 'file'), ['"' filePath '" does not exists.'])

            loaded = load(filePath, '-mat');
            
            name = 'TODO';
            timeStamp = 'TODO';
            sizeX = 'TODO';
            sizeY = 'TODO';
            waveNumbers = 'TODO';
            data = 'TODO';
            
            spectrum = Spectrum(name, timeStamp, sizeX, sizeY, waveNumbers, data);
        end
    end    
end



