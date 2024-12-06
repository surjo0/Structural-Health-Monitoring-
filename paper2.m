% Load the .mat file
data = load('ab2_LQ.mat');

% Assuming the loaded data contains a matrix for vertices
side_wall_vertices = data.matrix; % Use the loaded matrix directly

% Filter vertices based on wall height and base range
wall_height_range = [85, 120];
base_range = [-125, -105];

% Filter vertices based on wall height and base range
filtered_indices = find(side_wall_vertices(:, 3) >= wall_height_range(1) & ...
                        side_wall_vertices(:, 3) <= wall_height_range(2) & ...
                        side_wall_vertices(:, 2) >= base_range(1) & ...
                        side_wall_vertices(:, 2) <= base_range(2));

% Extract vertices and faces within the specified range
filtered_vertices = side_wall_vertices(filtered_indices, :);

% Assuming the faces are defined as quadrilaterals
% You need to adjust this according to your actual data structure
% Here's a simple assumption for illustration purposes:
num_vertices = size(filtered_vertices, 1);
side_wall_faces = [1:num_vertices; 2:num_vertices, 1]; % Assuming each consecutive pair of vertices forms an edge, with the last edge connecting back to the first vertex

% Visualize the side wall
figure;
patch('Vertices', filtered_vertices, 'Faces', side_wall_faces, 'FaceColor', 'blue', 'EdgeColor', 'none');
view(3); % Set the view to 3D
axis equal; % Ensure equal scaling in all directions
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Side Wall (Height: 85-120, Base: -125 to -105)');
