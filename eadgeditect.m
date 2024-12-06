% Step 1: Read the Image
image = imread('top view 1.jpg');

% Step 2: Convert to Grayscale (if necessary)
if size(image, 3) == 3
    image_gray = rgb2gray(image);
else
    image_gray = image;
end

% Step 3: Enhance Image Contrast using Histogram Equalization
image_enhanced = histeq(image_gray);

% Step 4: Apply Edge Detection using the Canny method
edges = edge(image_enhanced, 'Canny');

% Step 5: Post-process the edges using morphological operations
se = strel('line', 3, 90); % Create a linear structuring element
edges_dilated = imdilate(edges, se); % Dilate the edges
edges_cleaned = imerode(edges_dilated, se); % Erode the edges back
edges_filled = imfill(edges_cleaned, 'holes'); % Fill holes in the edges

% Step 6: Display the Original Image and the Edge Detected Image
figure;
subplot(1, 3, 1);
imshow(image);
title('Original Image');

subplot(1, 3, 2);
imshow(image_enhanced);
title('Enhanced Image');

subplot(1, 3, 3);
imshow(edges_filled);
title('Edge Detected Image');
