% Loading
loader = MatFileSpectrumLoader;
matFilePath = 'C:\Data\Repositories\RSAnalysisAutomation\Data\Bunky bez polyP\Cell001.mat';
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
    chRange, 1000, 4, InterpolationMethod.Linear); % TODO threshold

ohRange = Range(2710, 3840);
waterRangeSignificancyIdentifier = DefaultRangeSignificancyIdentifier(...
    ohRange, 12000, 6, InterpolationMethod.Linear); % TODO threshold

spectrumMaskCreator = DefaultSpectrumMaskCreator(cellRangeSignificancyIdentifier, waterRangeSignificancyIdentifier);
[cellMask, pureWaterMask] = spectrumMaskCreator.CreateMask(trimmedSpectrum);


maskPlotter = DefaultMaskPlotter;
maskPlotter.Plot(cellMask, spectrum.SizeX, spectrum.SizeY, 'Cells');
maskPlotter.Plot(pureWaterMask, spectrum.SizeX, spectrum.SizeY, 'Pure water');

display(trimmedSpectrum);