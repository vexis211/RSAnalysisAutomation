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
        
        function [hasValidCell, mainCellMask] = IdentifyMainCell(obj, cellMask, maskSize)
            assert(ismatrix(cellMask), 'cellMask must matrix');
            
            % Get index of one cell point
            cellPoint = obj.GetCellPoint(cellMask, maskSize);
            % If it has no valid cell point, return
            if (cellPoint == -1)
                hasValidCell = false;
                mainCellMask = zeros(size(cellMask));
                return
            end
            
            % Get mask for component containing cell point
            mainCellMask = obj.GetOneComponent(cellMask, maskSize, cellPoint);
            %TODO
            
            
            % Check if cell does not touch border. If it touches border, cell is invalid, because we
            % cannot be sure whole cell was measured.
            
            hasValidCell = true; %TODO delete
        end
        
        function cellPoint = GetCellPoint(obj, cellMask, maskSize)
            % Check if middle point is part of cell
            columnIndexMultiplier = double(maskSize(1));
            middlePoint = ceil(maskSize / 2);
            middlePointIndex = middlePoint(1) + ((middlePoint(2) - 1) * columnIndexMultiplier);
            cellMaskSize = numel(cellMask);
            
            if (cellMask(middlePointIndex) > 0)
                cellPoint = middlePointIndex;
            else
                % Start from middle and try to reach some cell point
                maxMove = double(max(maskSize - middlePoint));
                
                % TODO does it need optimization?
                for move=1:maxMove
                    for j=-move:move
                        for i=-move:move
                            index = middlePointIndex + i + (j * columnIndexMultiplier); 

                            if (index > 0 && index <= cellMaskSize && cellMask(index) > 0)
                                cellPoint = index;
                                return;
                            end
                        end
                    end
                end
            
                cellPoint = -1;
            end
        end
        
        function componentCellMask = GetOneComponent(obj, cellMask, maskSize, cellPoint)
            
            % this is not correct algorithm
            componentCellMask = zeros(size(cellMask));
            
            firstDimSize = double(maskSize(1));
            secondDimSize = double(maskSize(2));
            cellMaskSize = numel(cellMask);
            
            for direction=[-1 -1 1 1;-1 1 -1 1]
                for j=0:secondDimSize
                    indexPart = cellPoint + (j * direction(2) * firstDimSize);
                    if (indexPart <= 0 || cellMaskSize < indexPart)
                        break;
                    end
                    for i=0:firstDimSize
                        index = indexPart + (i * direction(1)); 

                        if (0 < index && index <= cellMaskSize && cellMask(index) > 0)
                            componentCellMask(index) = cellMask(index);
                         else
                             break;
                        end                            
                    end
                end
            end
        end
    end    
end
