from builtin.string import chr
from python import Python
from collections.optional import Optional
from pathlib import Path
from tensor import Tensor
from random import randint


fn read_content[input: StringLiteral]() -> Optional[String]:
    try:
        with open(input, "r") as f:
            return Optional(f.read())
    finally:
        return None


fn read_bytes[input: StringLiteral]() raises -> List[UInt8]:
    var filepath = Path(input)

    if not filepath.exists():
        raise Error("File does not exist.")
    if not filepath.is_file():
        raise Error("Path is not a file.")

    var bytes: List[UInt8]
    with open(input, "r") as f:
        bytes = f.read_bytes()

    return bytes


# TODO: Needs to know how to: Reshape, and see the tutorial
fn create_chunks[
    chunk_size: Int
](data: Tensor[DType.uint8]) -> Tensor[DType.uint8]:
    return data
