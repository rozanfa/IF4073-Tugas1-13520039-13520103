

a = imread('Lena512warna.bmp');
imshow(a);

b = negative(a);


% 
% figure; imshow(b);
% 
% c = brightening(a, 2, 10);
% figure; imshow(c);
% 
% 
% d = log_transform(a, 20);
% figure; imshow(d);
% 
% e = power_transform(a, 0.00003, 2);
% figure; imshow(e);

f = contrast_stretch(a);
figure; imshow(f);
show_hist(f);

function res = negative(im)
    res = 255 * ones(size(im), "uint8") - im;
end

function res = brightening(r, a, b)
    res = uint8(a*r) + b;
end

function res = log_transform(r, c)
    res = uint8(c * log(1+double(r)));
end

function res = power_transform(r, c, g)
    res = uint8(c * (double(r) .^ g));
end

function res = contrast_stretch(r)
    image_histograms = get_histogram_maps(r);
    image_size = get_image_size(r);
    res = zeros(image_size);
    disp(size(r));
    disp(image_size);
    for i = 1:image_size(3)
        disp("size(image_histograms(1))");
        disp(size(image_histograms(1)));
        max_val = get_max_pixel_values(image_histograms(i, :));
        min_val = get_min_pixel_values(image_histograms(i, :));
        res(:, :, i) = (r(:, :, i) - min_val) .* (255/(max_val - min_val));
    end
    res = uint8(res);
end

function image_size = get_image_size(image)
    image_size = size(image);
    if ismatrix(image)
        image_size = [image_size 1];
    end
end

function min_val = get_min_pixel_values(histogram_map)
    for i = 1:256
        if histogram_map(i) ~= 0
            min_val = i;
            break
        end
    end
end

function max_val = get_max_pixel_values(histogram_map)
    for i = 256:-1:1
        if histogram_map(i) ~= 0
            max_val = i;
            break
        end
    end
end

function show_hist(image)
    hists = get_histogram_maps(image);
    for i = 1:size(hists)
        figure; bar(hists(i, :))
    end
end

function histogram_map = get_histogram_maps(image)
    image_size = get_image_size(image);
    histogram_map = zeros(image_size(3), 256, "uint32");
    for i = 1:image_size(1)
        for j = 1:image_size(2)
            for k = 1:image_size(3)
                histogram_map(k, image(i, j, k) + 1) = histogram_map(k, image(i, j, k) + 1) + 1;
            end
        end
    end
end


