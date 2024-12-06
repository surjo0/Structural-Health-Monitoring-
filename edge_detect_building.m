% Load the .mat file
data = load('ab2_ab1_LQ.mat');

% Extract the matrix from the loaded data
dataMatrix = data.matrix;

% Assuming the data matrix has columns for x, y, z
x = dataMatrix(:, 1);
y = dataMatrix(:, 2);
z = dataMatrix(:, 3);

% Find the maximum z value
maxZ = max(z);

% Filter points corresponding to the building with the highest z value
tolerance = 0.5; % Adjust as necessary to include the top portion of the building
buildingPoints = (z >= maxZ - tolerance);

% Extract the filtered points
x_building = x(buildingPoints);
y_building = y(buildingPoints);
z_building = z(buildingPoints);

% Find the min and max for each axis
x_min = min(x_building);
x_max = max(x_building);
y_min = min(y_building);
y_max = max(y_building);
z_min = min(z_building);
z_max = max(z_building);

% Bounding box corners for the building
bbox_corners = [
    x_min, y_min, z_min;
    x_min, y_min, z_max;
    x_min, y_max, z_min;
    x_min, y_max, z_max;
    x_max, y_min, z_min;
    x_max, y_min, z_max;
    x_max, y_max, z_min;
    x_max, y_max, z_max
];

% Plot the point cloud of the building
figure;
scatter3(x_building, y_building, z_building, 10, 'b', 'filled'); % Point cloud with blue dots
hold on;

% Plot the bounding box
edges = [
    1, 2; 1, 3; 1, 5;
    2, 4; 2, 6;
    3, 4; 3, 7;
    4, 8;
    5, 6; 5, 7;
    6, 8;
    7, 8
];

for i = 1:size(edges, 1)
    plot3([bbox_corners(edges(i, 1), 1), bbox_corners(edges(i, 2), 1)], ...
          [bbox_corners(edges(i, 1), 2), bbox_corners(edges(i, 2), 2)], ...
          [bbox_corners(edges(i, 1), 3), bbox_corners(edges(i, 2), 3)], 'r', 'LineWidth', 2);
end

title('Edges of the Building with Highest Z Value');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
axis equal;
hold off;
