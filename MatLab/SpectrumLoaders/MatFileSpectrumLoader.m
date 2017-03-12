classdef MatFileSpectrumLoader < SpectrumLoaderInterface
    %MatFileSpectrumLoader Loads spectrum from mat file
    
    methods        
        function spectrum = Load(~, filePath)
            assert(exist(filePath, 'file') == 2, ['"' filePath '" does not exists.'])

            loaded = load(filePath, '-mat');
            
            fieldNameCell = fieldnames(loaded);
            fieldName = fieldNameCell{1:1};
            loadedSpectrumData = loaded.(fieldName);
            
            name = loadedSpectrumData.name;
            timeStamp = datetime(loadedSpectrumData.date);
            sizeX = loadedSpectrumData.imagesize(1);
            sizeY = loadedSpectrumData.imagesize(2);
            waveNumbers = loadedSpectrumData.axisscale{2,1};
            data = loadedSpectrumData.data;
            
            clearvars('loaded');
            
            spectrum = Spectrum(name, timeStamp, sizeX, sizeY, waveNumbers, data);
        end
    end    
end



