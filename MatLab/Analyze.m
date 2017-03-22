function Analyze(matFilePath)
    % Loading
    loader = MatFileSpectrumLoader;
    spectrum = loader.Load(matFilePath);

    % Scaling
    scaleRange = Range(217,3849);
    spectrumScaler = EquidistantSpectrumScaler(InterpolationMethod.Spline, ...
        scaleRange, 2);
    scaledSpectrum = spectrumScaler.Scale(spectrum);

    % Trimming
    trimRange = Range(250, 3840);
    spectrumTrimmer = DefaultSpectrumTrimmer(trimRange);
    trimmedSpectrum = spectrumTrimmer.Trim(scaledSpectrum);

    % Cell and water identification
    chRange = Range(2782, 3060);
    cellRangeSignificancyIdentifier = DefaultRangeSignificancyIdentifier(...
        chRange, 750, 4, InterpolationMethod.Linear); % TODO threshold

    ohRange = Range(2710, 3840);
    waterRangeSignificancyIdentifier = DefaultRangeSignificancyIdentifier(...
        ohRange, 12000, 6, InterpolationMethod.Linear); % TODO threshold

    spectrumMaskCreator = DefaultSpectrumMaskCreator(cellRangeSignificancyIdentifier, waterRangeSignificancyIdentifier);
    [cellMask, pureWaterMask] = spectrumMaskCreator.CreateMask(trimmedSpectrum);

    mainCellMaskIdentifier = DefaultMainCellMaskIdentifier;
    [hasValidCell, mainCellMask] = mainCellMaskIdentifier.IdentifyMainCell(cellMask);
    
%     maskPlotter = DefaultMaskPlotter;
%     maskPlotter.Plot(cellMask, spectrum.SizeX, spectrum.SizeY, 'Cells');
    % maskPlotter.Plot(pureWaterMask, spectrum.SizeX, spectrum.SizeY, 'Pure water');

    CreateCenteredFigure(spectrum.Name, 2, 1);
    subplot(1,2,1);

    figureColorMap = [0.6, 0.6, 0.6
        0, 1, 0];
    colormap(figureColorMap);
    
    X = 1:spectrum.SizeX;
    Y = 1:spectrum.SizeY;
    
    Z = flipud(rot90(reshape(cellMask,spectrum.SizeX, spectrum.SizeY)));
    contourf(X, Y, Z);
    
    if (hasValidCell)
        subplot(1,2,2);
        Z = flipud(rot90(reshape(mainCellMask,spectrum.SizeX, spectrum.SizeY)));
        contourf(X, Y, Z);
    end
    
    % display(trimmedSpectrum);
end


function fig = CreateCenteredFigure(name, plotWidth, plotHeight)
%CreateCenteredFigure Create figure
    screenSize = get(0,'ScreenSize');
    screenWidth = screenSize(3);
    screenHeight = screenSize(4);
    figureWidth = 460 * plotWidth + 40;
    figureHeight = 380 * plotHeight + 40;
    figureX = (screenWidth / 2) - (figureWidth / 2);
    figureY = (screenHeight / 2) - (figureHeight / 2);
    
    fig = figure('Name', ['Cell: ' name], 'NumberTitle', 'off',...
        'Position', [figureX figureY figureWidth figureHeight]);
end