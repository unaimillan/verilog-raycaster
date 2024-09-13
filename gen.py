import logging
import math
from pathlib import Path

log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

LEVELS_DIR = Path("./levels")
TEXTURES_DIR = Path("./textures")
MEMORY_DIR = Path("./memory")


PI = math.pi
TRIG_SAMPLES = 256
TEX_X = 256
TEX_Y = 256


def to_fix(real_num: float):
    return int(real_num * 2**16)


def generate_sin_table():
    sin_table = [0] * TRIG_SAMPLES
    for i in range(TRIG_SAMPLES):
        sin_table[i] = math.sin(PI / 2 * i / TRIG_SAMPLES)
        # print(sin_table[i], to_fix(sin_table[i]))
    with open(MEMORY_DIR / "sin_table.mem", "w") as fl:
        for sin_entry in sin_table:
            fl.write(str(to_fix(sin_entry)) + "\n")


def generate_sec_table():
    sec_table = [0] * TRIG_SAMPLES
    for i in range(TRIG_SAMPLES):
        sec_table[i] = 1 / math.cos(PI / 2 * i / TRIG_SAMPLES)
    with open(MEMORY_DIR / "sec_table.mem", "w") as fl:
        for sec_entry in sec_table:
            fl.write(str(to_fix(sec_entry)) + "\n")
    # print(*sec_table, sep='\n')


def generate_tables():
    generate_sin_table()
    generate_sec_table()


def load_bmp(bmp_path: Path):
    content = None
    with open(bmp_path, "rb") as bmp:
        content = bmp.read()
    log.info(f"read {len(content)} bytes from {bmp_path}")

    signature = int.from_bytes(content[0:2], "big")
    if signature != 0x424D:
        print("image is not a bitmap")
        exit(-1)

    data_offset = int.from_bytes(content[10:14], "little")
    width = int.from_bytes(content[18:22], "little")
    height = int.from_bytes(content[22:26], "little")
    color_planes = int.from_bytes(content[26:28], "little")
    bpp = int.from_bytes(content[28:30], "little")
    texture = content[data_offset:]

    log.debug(signature, data_offset, width, height, color_planes, bpp, len(texture))

    if width != TEX_X or height != TEX_Y:
        log.error("image is must be %dx%d, found %dx%d.", TEX_X, TEX_Y, width, height)
        exit(-1)
        
    if (color_planes != 1):
        log.error("image must have 1 color plane, found %d.",color_planes)
        exit(-1)
        
    if (bpp != 24):
        log.error("image encoding must be 24-bit/pixel, found %d.", bpp)
        exit(-1)

    if len(texture) != width * height * 3:
        log.error(f"Texture {bmp_path} has a wrong content length")
        exit(-1)

    return texture


def generate_texture(name: str, content: bytes):
    with open(MEMORY_DIR / (name+'.mem'), 'w') as fl:
        for i in range(len(content) // 3):
            fl.write(f'{(content[i])*(content[i+1])*(content[i]+2):x}\n')

def generate_sv_texture(name: str, content: bytes):
    txt_arr = []
    for i in range(len(content) // 3):
        txt_arr.append(f"'h{(content[i])*(content[i+1])*(content[i]+2):x}")
    texture_str = '{' + ','.join(txt_arr) + '}'
    TEMPLATE = f"""`define TEX_X 256
`define TEX_Y 256

typedef logic[7:0] uint8_t;

typedef struct packed {{
    uint8_t b;
    uint8_t g;
    uint8_t r;
}} color_t;

typedef color_t texture_t [(TEX_X*TEX_Y)-1:0];

module {name}(input coord, output color_t color);
    texture_t texture = '{texture_str};
    assign color = texture[coord];
endmodule
"""
    with open(MEMORY_DIR / (name + '.sv'), 'w') as fl:
        fl.write(TEMPLATE)

def generate_textures():
    for texture_path in TEXTURES_DIR.glob("*.bmp"):
        texture = load_bmp(texture_path)
        generate_texture(texture_path.stem, texture)
        # generate_sv_texture(texture_path.stem, texture)
        log.info(f"Texture {texture_path} converted")


def main():
    MEMORY_DIR.mkdir(exist_ok=True)
    generate_tables()
    generate_textures()


if __name__ == "__main__":
    main()
