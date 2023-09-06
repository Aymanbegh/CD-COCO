clc; clear all;

myFolder = 'C:\Users\beghd\OneDrive\Bureau\Distortions_evaluation\images\blur_motion\1.000000';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);

%Scene_type=cell(length(jpegFiles),2);

% for k = 1:length(jpegFiles)
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  %fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  imshow(imageArray);  % Display image.
  drawnow; % Force display to update immediately.
  ch = getkey(1,'non-ascii');
  if ismember('control', ch), fprintf('OK\n') ;
  else fprintf(' ... wrong keys ...\n') ; end 
  Scene_type(k).name=baseFileName;
  if(ch=='i')
      data=0;
  end
  if(ch=='o')
      data=1;
  end
  if(ch=='e')
      break;
  end
  Scene_type(k).type=data;
end

writetable(struct2table(Scene_type), 'someexcelfile.xlsx')


