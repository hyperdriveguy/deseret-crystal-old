#!/usr/bin/env python3

from sys import argv, exit, stderr
from struct import unpack, calcsize

def unpack_file(fmt, file):
    size = calcsize(fmt)
    return unpack(fmt, file.read(size))

def skip_unpack_file(fmt, file):
    size = calcsize(fmt)
    file.seek(size, 1)

def read_string(file):
    buf = bytearray()
    while True:
        b = file.read(1)
        if b is None or b == b'\0':
            return buf.decode()
        else:
            buf += b

def skip_string(file):
    while True:
        b = file.read(1)
        if b is None or b == b'\0':
            return

def parse_object(file):
    object = {
        "symbols": [],
        "sections": []
    }

    num_symbols, num_sections = unpack_file("<II", file)

    for x in range(num_symbols):
        symbol = {}

        symbol["name"] = read_string(file)
        symbol["type"] = unpack_file("<B", file)[0]
        if symbol["type"] != 1:
            # symbol["filename"] = read_string(file)
            skip_string(file)
            # symbol["line_num"], symbol["section_id"], symbol["value"] = unpack_file("<III", file)
            skip_unpack_file("<III", file)

        object["symbols"].append(symbol)

    for x in range(num_sections):
        section = {}

        # section["name"] = read_string(file)
        skip_string(file)
        # size, section["type"], section["org"], section["bank"], section["align"] = unpack_file("<IBIII", file)
        size, section["type"] = unpack_file("<IB", file)
        skip_unpack_file("<III", file)
        if section["type"] == 2 or section["type"] == 3:
            # section["data"] = file.read(size)
            file.seek(size, 1)

            section["patches"] = []
            num_patches = unpack_file("<I", file)[0]
            for x in range(num_patches):
                patch = {}

                patch["filename"] = read_string(file)
                # patch["line"], patch["offset"], patch["type"], rpn_size = unpack_file("<IIBI", file)
                patch["line"] = unpack_file("<I", file)[0]
                skip_unpack_file("<IB", file)
                rpn_size = unpack_file("<I", file)[0]
                patch["rpn"] = file.read(rpn_size)

                section["patches"].append(patch)

        object["sections"].append(section)

    return object


if len(argv) <= 1:
    print("Usage: %s [-D] <objects.o...>" % argv[0], file=stderr)
    exit(1)

argi = 1

just_dump = False
if argv[argi] == "-D":
    just_dump = True
    argi += 1
elif argv[argi] == "--":
    argi += 1

# globals = []
referenced = {}

for filename in argv[argi:]:
    print(filename, file=stderr)

    file = open(filename, "rb")

    id = unpack_file("4s", file)[0]
    if id != b'RGB6':
        print("File %s is of an unknown format." % filename, file=stderr)
        exit(1)

    if just_dump:
        num_symbols = unpack_file("<I", file)[0]
        skip_unpack_file("<I", file)
        for x in range(num_symbols):
            print(read_string(file))

            type = unpack_file("<B", file)[0]
            if type != 1:
                skip_string(file)
                skip_unpack_file("<III", file)

        continue

    object = parse_object(file)

    # locals = {}

    imports = 0
    exports = 0
    for symbol in object["symbols"]:
        if symbol["type"] == 0:
            # if symbol["name"] in locals:
                # continue
                # # print("Redefinition of %s in locals." % symbol["name"], file=stderr)
                # # exit(1)
            # if not symbol["name"] in locals:
                # locals[symbol["name"]] = 0
            pass
        elif symbol["type"] == 1:
            if not symbol["name"] in referenced:
                referenced[symbol["name"]] = 0
            imports += 1
        elif symbol["type"] == 2:
            if symbol["name"] in referenced:
                continue
                # print("Redefinition of %s in globals." % symbol["name"], file=stderr)
                # exit(1)
            if not symbol["name"] in referenced:
                referenced[symbol["name"]] = 0
            exports += 1

    # print("Locals:", len(locals), file=stderr)
    print("Imports:", imports, file=stderr)
    print("Exports:", exports, file=stderr)

    for section in object["sections"]:
        if section["type"] == 2 or section["type"] == 3:
            for patch in section["patches"]:
                rpn = patch["rpn"]

                pos = 0
                while pos < len(rpn):
                    if rpn[pos] < 0x50 or rpn[pos] == 0x52 or rpn[pos] == 0x60:
                        pos += 1
                    elif rpn[pos] == 0x51:
                        pos += 1
                        while rpn[pos] != 0:
                            pos += 1
                    elif rpn[pos] == 0x80:
                        pos += 5
                    elif rpn[pos] == 0x50 or rpn[pos] == 0x81:
                        symbol_id = unpack("<I", rpn[pos + 1:pos + 5])[0]
                        symbol = object["symbols"][symbol_id]
                        if symbol["type"] == 0:
                            # locals[symbol["name"]] += 1
                            pass
                        elif symbol["type"] == 1 or symbol["type"] == 2:
                            referenced[symbol["name"]] += 1
                        pos += 5
                    else:
                        print("Unknown RPN expression for %s:%i in %s" % (patch["filename"], patch["line"], filename), file=stderr)
                        exit(1)

    # print("Unreferenced locals:", file=stderr)
    # for symbol in locals:
        # if locals[symbol] == 0:
            # print(symbol)

    print(file=stderr)

if just_dump:
    exit()

print("Unreferenced globals:", file=stderr)
for symbol in referenced:
    if referenced[symbol] == 0:
        print(symbol)
