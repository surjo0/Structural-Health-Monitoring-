load("wall7.mat");

num_slices = 15;
z_min = 0;
z_max = 105;
z_step = (z_max - z_min) / num_slices;

slope_values = zeros(num_slices, 1);
intercept_values = zeros(num_slices, 1);
squared_diffs = zeros(num_slices, 1);

[x_all, y_all] = deal(filtered_pc.Location(:, 1), filtered_pc.Location(:, 2));
coeffs_all = polyfit(x_all, y_all, 1);
sum_y_all_sq = sum(y_all.^2);

for i = 1:num_slices
    z_lower = z_min + (i - 1) * z_step;
    z_upper = z_min + i * z_step;
    
    slice_indices = find(filtered_pc.Location(:, 3) >= z_lower & filtered_pc.Location(:, 3) < z_upper);
    sliced_point_cloud = select(filtered_pc, slice_indices);
    
    [x, y] = deal(sliced_point_cloud.Location(:, 1), sliced_point_cloud.Location(:, 2));
    coeffs = polyfit(x, y, 1);
    slope_values(i) = coeffs(1);
    intercept_values(i) = coeffs(2);
    
    sum_slice_sq = sum(y.^2);
    squared_diffs(i) = (sum_y_all_sq - sum_slice_sq)^2;
end

figure;


subplot(2, 1, 1);
plot(z_min + z_step*(0:num_slices-1), squared_diffs, 'o-', 'LineWidth', 2);
xlabel('Height (feet)');
ylabel('(Sum(Y_{all}^2) - Sum(Y_{slice}^2))^2');
title('wall Deformation with Hight');
grid on;
set(gca, 'YTickLabel', []);