 % Function for reading the data from dataset
 
function I = readFcnMatFile(filename)

% Load data and get matrices from the structure
I = load(filename);
I = I.dat;

