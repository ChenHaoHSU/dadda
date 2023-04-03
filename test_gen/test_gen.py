import random

bit = 8
data_num = 100
data_file = 'mul{}x{}.dat'.format(bit, bit)
golden_file = 'mul{}x{}_golden.dat'.format(bit, bit)

data_max = 2 ** bit - 1
data_min = 0

random.seed(0)

data_f = open(data_file, "w")
golden_f = open(golden_file, "w")

for i in range(data_num):
    a = random.randint(data_min, data_max); 
    b = random.randint(data_min, data_max); 
    p = a * b

    data_f.write('{}{}\n'.format(hex(a)[2:].zfill(2), hex(b)[2:].zfill(2)))
    golden_f.write('{}\n'.format(hex(p)[2:].zfill(4)))

data_f.close()
golden_f.close()











