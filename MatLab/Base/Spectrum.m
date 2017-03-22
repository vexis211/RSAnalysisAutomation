classdef Spectrum < handle
    %SPECTRUM Raman spectrum
    
    properties (SetAccess = private)
        Name
        TimeStamp datetime
        SizeX uint16
        SizeY uint16
        WaveNumbers double
        Data double
    end
    
    methods
        function obj = Spectrum(name, timeStamp, sizeX, sizeY, waveNumbers, data)
            assert(ischar(name), 'name must be of type char array')
            assert(isdatetime(timeStamp), 'timeStamp must be of type date or time')
            assert(sizeX > 0, 'sizeX must be more then 0')
            assert(sizeY > 0, 'sizeY must be more then 0')
            assert(isreal(waveNumbers), 'waveNumbers must be of type double[m]')
            assert(isreal(data), 'data must be of type double[m,n]')
            assert(size(waveNumbers, 2) == size(data, 2), ...
                'size fo waveNumbers must equal size of second dimension of data')
            
            obj.Name = name;
            obj.TimeStamp = timeStamp;
            obj.SizeX = sizeX;
            obj.SizeY = sizeY;
            obj.WaveNumbers = waveNumbers;
            obj.Data = data;
        end
    end
end

