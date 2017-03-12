loader = MatFileSpectrumLoader;
matFilePath = 'C:\Data\Repositories\RSAnalysisAutomation\Data\Bunky bez polyP\Cell001.mat';
spectrum = loader.Load(matFilePath);

scaleRange = Range(217,3849);
spectrumScaler = EquidistantSpectrumScaler(EquidistantScaleMethod.Spline, ...
    scaleRange, 2);
scaledSpectrum = spectrumScaler.Scale(spectrum);

trimRange = Range(250, 3840);
spectrumTrimmer = DefaultSpectrumTrimmer(trimRange);
trimmedSpectrum = spectrumTrimmer.Trim(scaledSpectrum);

display(trimmedSpectrum);