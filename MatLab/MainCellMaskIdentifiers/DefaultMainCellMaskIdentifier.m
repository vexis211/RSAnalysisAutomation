classdef DefaultMainCellMaskIdentifier < MainCellMaskIdentifierInterface
    %DefaultMainCellMaskIdentifier Identifies main cell mask in cell mask
    
    properties (Access = private)
        %Threshold double
    end
    
    methods
%         function obj = DefaultMainCellMaskIdentifier(threshold)
%             assert(threshold > 0, 'threshold must be more then 0');
%             
%             obj.Threshold = threshold;
%         end
        function obj = DefaultMainCellMaskIdentifier()
        end
        
        function [hasValidCell, mainCellMask] = IdentifyMainCell(obj, cellMask)
            assert(ismatrix(cellMask), 'cellMask must matrix');
            
            % Start from middle and try to reach some cell point
            firstDimLength = size(cellMask, 1);
            secondDimLength = size(cellMask, 2);
            
            firstDimMiddle = idivide(int16(firstDimLength), 2, 'floor');
            secondDimMiddle = idivide(int16(secondDimLength), 2, 'floor'); % TODO fix
            
            %TODO
            
            % Check if cell does not touch border. If it touches border, cell is invalid, because we
            % cannot be sure whole cell was measured.
            
            hasValidCell = true; %TODO delete
            mainCellMask = cellMask; %TODO delete
        end
    end    
end
