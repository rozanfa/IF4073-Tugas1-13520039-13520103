function res = brightening(r, args)
    a = args{1};
    b = args{2};
    res = uint8(a*r+b);
end