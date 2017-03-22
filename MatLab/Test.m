folder = 'C:\Data\Repositories\RSAnalysisAutomation\Data\Bunky bez polyP';

fileIndexes = 1:2; %[1:2 9:12 13 16 20];

for i = fileIndexes
    matFilePath = [folder '\Cell' sprintf('%03d',i)  '.mat'];
    Analyze(matFilePath);
end
