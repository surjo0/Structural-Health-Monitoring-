% Load the point cloud data
data = load('pillar.xyz');

% Extract X, Y, Z coordinates
X = data(:, 1);
Y = data(:, 2);
Z = data(:, 3);

% Get unique Z values and sort them
z_values = unique(Z);
num_z = length(z_values);

% Plot the original point cloud
figure;
pcshow([X, Y, Z], 'MarkerSize', 10);
hold on;

% Loop through each unique Z value
for i = 1:num_z
    % Get the points corresponding to the current Z value
    z_slice = Z == z_values(i);
    
    % Measure x min, x max, y min, y max for the current slice
    x_min = min(X(z_slice));
    x_max = max(X(z_slice));
    y_min = min(Y(z_slice));
    y_max = max(Y(z_slice));
    
    % Plot a square border for this Z level
    plot3([x_min x_max x_max x_min x_min], [y_min y_min y_max y_max y_min], ...
        [z_values(i) z_values(i) z_values(i) z_values(i) z_values(i)], 'r-', 'LineWidth', 1);
end

% Set axis labels
xlabel('X');
ylabel('Y');
zlabel('Z');

% Set axis limits
xlim([min(X) max(X)]);
ylim([min(Y) max(Y)]);
zlim([min(Z) max(Z)]);

% Show the grid
grid on;
hold off;
