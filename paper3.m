% Load the data from the ab2_LQ.mat file
load("ab2_LQ.mat");
pc = pointCloud(matrix);

% Define the X, Y, and Z axis ranges
xRange = [172, 173];
yRange = [-100, -96];
zRange = [90, 115];

% Filter the points based on the specified ranges
indices = find(pc.Location(:, 1) >= xRange(1) & pc.Location(:, 1) <= xRange(2) & ...
               pc.Location(:, 2) >= yRange(1) & pc.Location(:, 2) <= yRange(2) & ...
               pc.Location(:, 3) >= zRange(1) & pc.Location(:, 3) <= zRange(2));
filtered_pc = select(pc, indices);

% Visualize the filtered point cloud
figure;
pcshow(filtered_pc);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Sample wall');


