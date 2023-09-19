

image = imread('Lena.bmp');
image_size = size(image);

dimension = ndims(image);
if dimension == 2
    image_size = [1 image_size];
end

histogram_map = zeros(image_size(1), 255, "uint8");

for i = 1:image_size(1)
    for j = 1:image_size(2)
        for k = 1:image_size(3)
            histogram_map(i, image(k, j, i)) = histogram_map(i, image(k, j, i)) + 1;
        end
    end
end

disp(histogram_map)
bar(histogram_map);


