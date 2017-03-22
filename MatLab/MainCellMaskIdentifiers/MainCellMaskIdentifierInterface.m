classdef MainCellMaskIdentifierInterface < handle
    %MainCellMaskIdentifierInterface Identifies main cell mask in cell mask
    
    methods (Abstract)
        [hasValidCell, mainCellMask] = IdentifyMainCell(obj, cellMask)
    end    
end
