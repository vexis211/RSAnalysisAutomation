loader = MatFileSpectrumLoader;
matFilePath = 'C:\Data\Repositories\RSAnalysisAutomation\Data\Bunky bez polyP\Cell001.mat';
spectrum = loader.Load(matFilePath);

spectrumScaler = EquidistantSpectrumScaler(EquidistantScaleMethod.Spline, ...
    217,3849,2);
scaledSpectrum = spectrumScaler.Scale(spectrum);

spectrumTrimmer = DefaultSpectrumTrimmer(250, 3840);
trimmedSpectrum = spectrumTrimmer.Trim(scaledSpectrum);

display(trimmedSpectrum);