data = importdata('ab2_LQ.mat');

if isstruct(data)
    coordinates = data.data;
    x = coordinates(:, 1);
    y = coordinates(:, 2);
    z = coordinates(:, 3);
else
    coordinates = data;
    x = coordinates(:, 1);
    y = coordinates(:, 2);
    z = coordinates(:, 3);
end

figure;
scatter3(x, y, z, 'filled', 'MarkerFaceColor', [0.8, 0.5, 0.2]); % Ocher color
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Scatter Plot of AB2 Building');

resultData = [x, y, z];
save('result.xyz', 'resultData', '-ascii');
