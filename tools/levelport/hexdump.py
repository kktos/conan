#!/usr/bin/env python3
"""Dump a slice of a binary as a tsasm .hex block (16 bytes per line).

  hexdump.py FILE START LENGTH      (hex, without $: hexdump.py L3_c4_A000.bin 800 100)
"""
import sys

def hexblock(data, indent="\t"):
    out = [indent + ".hex"]
    for i in range(0, len(data), 16):
        out.append(indent + " ".join(f"{b:02X}" for b in data[i:i + 16]))
    out.append(indent + ".end")
    return "\n".join(out)

if __name__ == "__main__":
    f, start, length = sys.argv[1], int(sys.argv[2], 16), int(sys.argv[3], 16)
    print(hexblock(open(f, "rb").read()[start:start + length]))
