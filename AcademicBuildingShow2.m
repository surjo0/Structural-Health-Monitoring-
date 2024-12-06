% Load the .mat file
data = load('ab2_LQ.mat');

% Extract the matrix from the data
pointCloudData = data.matrix;

% Extract X, Y, Z coordinates
X = pointCloudData(:, 1);
Y = pointCloudData(:, 2);
Z = pointCloudData(:, 3);

% Create a point cloud object
ptCloud = pointCloud([X, Y, Z]);

% Visualize the point cloud
figure;
pcshow(ptCloud);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Point Cloud Visualization');
grid on;

% Adjust view angle
view([-15, 30]); % Change the angles here to control the view direction
