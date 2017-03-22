classdef DefaultMaskPlotter < MaskPlotterInterface
    %DefaultMaskPlotter Class for plotting masks
    
    methods
        function Plot(obj, mask, sizeX, sizeY, title)
            X = 1:sizeX;
            Y = 1:sizeY;
            
            Z=flipud(rot90(reshape(mask,sizeX,sizeY))); % TODO is this ok?
            figure('Name', title);
            contourf(X, Y, Z);
            figureColorMap = [0.6, 0.6, 0.6
                0, 1, 0];
            colormap(figureColorMap);
        end            
    end    
end

