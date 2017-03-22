classdef DefaultMaskPlotter < MaskPlotterInterface
    %DefaultMaskPlotter Class for plotting masks
    
    methods
        function Plot(obj, mask, sizeX, sizeY, title)
            X = 1:sizeX;
            Y = 1:sizeY;
            
            Z=flipud(rot90(reshape(mask,sizeX,sizeY))); % TODO is this ok?
            figure('Name', title);
            contourf(X, Y, Z);
            colormap(flag);
        end            
    end    
end

