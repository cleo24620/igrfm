currentDir = pwd;
subfolderName = 'lines_data';

subfolderPath = fullfile(currentDir, subfolderName);

if ~exist(subfolderPath, 'dir')
    mkdir(subfolderPath);
end
