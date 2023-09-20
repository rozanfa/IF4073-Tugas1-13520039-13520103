

a = imread('images/Lena512warna.bmp');
ref = imread('images/peppers512warna.bmp');
figure(Name="Original")
imshow(a);
show_hist(a, "Original");
show_hist(ref, "ref");

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

% f = contrast_stretch(a);
% figure(Name="Contrast Streched"); imshow(f);
% show_hist(f, "Contrast Streched");

g = histogram_equalization(a);
figure(Name="Histogram Equalized"); imshow(g);
show_hist(g, "Histogram Equalized");

h = histogram_spesification(a, ref);
figure(Name="Histogram 2"); imshow(h);
show_hist(h, "Histogram 2");

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
    for i = 1:image_size(3)
        max_val = get_max_pixel_values(image_histograms(i, :)) - 1;
        min_val = get_min_pixel_values(image_histograms(i, :)) - 1;
        res(:, :, i) = (r(:, :, i) - min_val) .* (255/(max_val - min_val));
    end
    res = uint8(res);
end

function res = histogram_equalization(r)
    r = double(r);
    image_size = get_image_size(r);
    value_count_map = zeros(image_size(3), 256, "uint32");
    pixel_count = image_size(1) * image_size(2);
    res = zeros(image_size);
    for k = 1:image_size(3)
        value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
        for n = 1:255
            value_count_map(k, n+1) = sum(sum(r(:,:,k) == n)) + value_count_map(k, n);
        end
    
        for i = 1:image_size(1)
            for j = 1:image_size(2)
                res(i,j,k) = value_count_map(k, r(i,j,k)+1) * 255 / pixel_count;
            end
        end
    end
    res = uint8(res);
end

function res = histogram_spesification(r, reference)

    % Convert images to double
    r = double(r);
    reference = double(reference);
    
    % Get image attributes
    image_size = get_image_size(r);
    value_count_map = zeros(image_size(3), 256, "uint32");
    pixel_count = image_size(1) * image_size(2);
    
    % Get reference image attributes
    reference_image_size = get_image_size(reference);
    reference_value_count_map = zeros(reference_image_size(3), 256, "uint32");
    reference_pixel_count = reference_image_size(1) * reference_image_size(2);
    
    % Initialize maps
    equalization_map = zeros(image_size(3), 256, "uint32");
    reference_equalization_map = zeros(image_size(3), 256, "uint32");
    specification_map = zeros(image_size(3), 256, "uint32");
    
    % Initialize result image
    res = zeros(image_size);
    
    % Loop through each channel
    for k = 1:image_size(3)
        
        % Count every value in the image
        value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
        for n = 1:255
            value_count_map(k, n+1) = sum(sum(r(:,:,k) == n)) + value_count_map(k, n);
        end
        
        % Count every value in the reference image
        reference_value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
        for n = 1:255
            reference_value_count_map(k, n+1) = sum(sum(reference(:,:,k) == n)) + reference_value_count_map(k, n);
        end
        
        % Create equalization map for the image
        for i = 1:256
            equalization_map(k, i) = value_count_map(k, i) * 255 / pixel_count;
        end
        
        % Create equalization map for the reference image
        for i = 1:256
            reference_equalization_map(k, i) = reference_value_count_map(k, i) * 255 / reference_pixel_count;
        end
        
        % Create specification map
        for i = 1:256
            disp(get_nearest_value(i, reference_equalization_map(k, :)));
            specification_map(k, i) = get_nearest_value(i-1, reference_equalization_map(k, :));
        end
        
        % Apply specification map to the image
        for i = 1:image_size(1)
            for j = 1:image_size(2)
                res(i,j,k) = specification_map(k, equalization_map(k, r(i,j,k) + 1) + 1);
            end
        end
    end
    
    % Convert result image to uint8
    res = uint8(res);
end


function nearest_value = get_nearest_value(target_value, array)
    % Function to get nearest value from an array using binary search
    
    array = int16(array);
    low = 1;
    high = 256;
    
    nearest_value = array(1);
    diff = abs(array(1) - target_value);
    
    % Binary search
    while low <= high
        mid = floor((low + high) / 2);
        current_element = array(mid);
        
        if current_element == target_value
            nearest_value = current_element;
            return;
        end
        
        if abs(current_element - target_value) < diff
            nearest_value = current_element;
            diff = abs(current_element - target_value);
        end
        
        if current_element < target_value
            low = mid + 1;
        else
            high = mid - 1;
        end
    end
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

function show_hist(image, name)
    hists = get_histogram_maps(image);
    for i = 1:size(hists)
        figure("Name", name); bar(hists(i, :))
    end
end

function histogram_map = get_histogram_maps(image)
    % Catatan: index digeser satu ke kanan
    image_size = get_image_size(image);
    histogram_map = zeros(image_size(3), 256, "uint32");
    for i = 1:image_size(1)
        for j = 1:image_size(2)
            for k = 1:image_size(3)
                index = uint16(image(i, j, k)) + 1;
                histogram_map(k, index) = histogram_map(k, index) + 1;
            end
        end
    end
end

