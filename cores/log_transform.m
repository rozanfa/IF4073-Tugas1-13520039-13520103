function res = log_transform(r, args)
    c = args{1};
    res = uint8(c * log(1+double(r)));
end