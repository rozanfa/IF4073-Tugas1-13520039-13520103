

a = imread('Lena.bmp');
b = negative(a);


imshow(a);
figure; imshow(b);

c = brightening(a, 2, 10);
figure; imshow(c);


d = log_transform(a, 20);
figure; imshow(d);

e = power_transform(a, 0.00003, 2);
figure; imshow(e);

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
    res = uint8(c * (double(r) ^ g));
end



