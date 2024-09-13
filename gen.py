import math
from pathlib import Path


LEVELS_DIR = Path('./levels')
TEXTURES_DIR = Path('./textures')
MEMORY_DIR = Path('./memory')


PI = math.pi
TRIG_SAMPLES = 256


def generate_sin_table():
    sin_table = [0] * TRIG_SAMPLES
    for i in range(TRIG_SAMPLES):
        sin_table[i] = math.sin(PI/2*i/TRIG_SAMPLES)
    print(*sin_table, sep='\n')


def generate_sec_table():
    sec_table = [0] * TRIG_SAMPLES
    for i in range(TRIG_SAMPLES):
        sec_table[i] = 1/math.cos(PI/2*i/TRIG_SAMPLES)
    print(*sec_table, sep='\n')

    
def generate_tables():
    generate_sin_table()
    generate_sec_table()


def generate_textures():
    pass


def main():
    generate_tables()


if __name__ == '__main__':
    main()
