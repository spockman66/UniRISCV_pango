# import struct
# from elftools.elf.elffile import ELFFile


def num_to_hex_8bit(_num):
    _dict = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
    # n * 16 + m = num
    _m = _num % 16
    _n = int(_num / 16)
    _hex = _dict[_n] + _dict[_m]
    return _hex


def conv_endian_8bit(_hex):
    _dict = {'0': '0', '1': '8', '2': '4', '3': 'c', '4': '2', '5': 'a', '6': '6', '7': 'e', '8': '1', '9': '9',
             'a': '5', 'b': 'd', 'c': '3', 'd': 'b', 'e': '7', 'f': 'f'}
    _hexConv = _dict[_hex[1]] + _dict[_hex[0]]
    return _hexConv


def main():
    # Params
    ramWidth = 32
    ramDepth = 16384 # 8192
    reverseByte = False
    binPath = 'D:/Innovation/220900FPGAContest/myriscv/0final_riscv/coremark/coremark_test/build/coremark_test.bin'
    # Params end

    ramWidthBytes = round(ramWidth / 8)
    res = open(binPath, "rb")
    data = res.read()
    print('Data length (bytes):', len(data))
    for i in range(len(data)):
        print(num_to_hex_8bit(data[i]), end=' ')

    txtFile = open(binPath + '.txt', mode='w')
    for ramPtr in range(ramDepth):  # 遍历每个ram单元
        line = ''
        for i in range(ramWidthBytes):  # 遍历ram单元内的每个字节
            dataPtr = ramPtr * ramWidthBytes + i
            if dataPtr < len(data):  # 如果数据还够
                if not reverseByte:  # 如果字节内不倒序
                    line = num_to_hex_8bit(data[dataPtr]) + line
                else:  # 如果字节内倒序
                    line = conv_endian_8bit(num_to_hex_8bit(data[dataPtr])) + line
            else:  # 如果数据全写完了
                line = '00' + line
        txtFile.write(line + '\n')
    txtFile.close()


if __name__ == '__main__':
    main()
