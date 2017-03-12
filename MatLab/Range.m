classdef Range
    %Range range
    
    properties (SetAccess = private)
        From double
        To double
    end
    
    methods
        function obj = Range(from, to)
            assert(to > from, 'to must be more then from.');
                        
            obj.From = from;
            obj.To = to;
        end
    end
end

