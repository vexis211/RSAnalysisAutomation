% Loading
loader = MatFileSpectrumLoader;
matFilePath = 'C:\Data\Repositories\RSAnalysisAutomation\Data\Bunky bez polyP\Cell001.mat';
spectrum = loader.Load(matFilePath);

% Scaling
scaleRange = Range(217,3849);
spectrumScaler = EquidistantSpectrumScaler(EquidistantScaleMethod.Spline, ...
    scaleRange, 2);
scaledSpectrum = spectrumScaler.Scale(spectrum);

% Trimming
trimRange = Range(250, 3840);
spectrumTrimmer = DefaultSpectrumTrimmer(trimRange);
trimmedSpectrum = spectrumTrimmer.Trim(scaledSpectrum);

% Cell and water identification
chRange = Range(2782, 3060);
cellRangeSignificancyIdentifier = DefaultRangeSignificancyIdentifier(...
    chRange, TODO, 4, InterpolationMethod.Spline);

ohRange = Range(2710, 3840);
waterRangeSignificancyIdentifier = DefaultRangeSignificancyIdentifier(...
    ohRange, TODO, 6, InterpolationMethod.Linear);

spectrumMaskCreator = DefaultSpectrumMaskCreator(cellRangeSignificancyIdentifier, waterRangeSignificancyIdentifier);
[cellMask, pureWaterMask] = spectrumMaskCreator.CreateMask(trimmedSpectrum);


display(trimmedSpectrum);