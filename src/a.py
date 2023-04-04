
for i in range(0, 8):
    print('full_adder FA{}(c[{}], c[{}], c[{}], s[{}], c[{}]);'.format(i*3+74, 4*i+18, 4*i+18+1, 4*i+18+2, i*3+74, i*3+74))
    print('full_adder FA{}(c[{}], s[{}], s[{}], s[{}], c[{}]);'.format(i*3+74+1, 4*i+21, 4*i+22, 4*i+23, i*3+74+1, i*3+74+1))
    print('full_adder FA{}(s[{}], s[{}], p[{}], s[{}], c[{}]);'.format(i*3+74+2, 4*i+24, 4*i+25, 16*i+238, i*3+74+2, i*3+74+2))


