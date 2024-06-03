from builtin.string import chr
from python import Python
from collections.optional import Optional
from pathlib import Path


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


# fn encode[mapper: fn (Int8) escaping -> UInt8](inp: String) -> List[UInt8]:
#     var buffer = inp._buffer
#     var new_buffer = List[UInt8](buffer.size)
#     for i in range(buffer.size):
#         new_buffer[i] = mapper(buffer[i])

#     return new_buffer


# fn get_encoder(data: String) -> fn (Int8) escaping -> UInt8:
#     var uniques: String = ""
#     for i in range(len(data)):
#         if uniques.find(data[i]) == -1:
#             uniques += data[i]

#     fn encoder(input: Int8) -> UInt8:
#         for i in range(len(uniques)):
#             if ord(uniques[i]) == input.to_int():
#                 return UInt8(ord(uniques[i]))
#         else:
#             return -1

#     return encoder


#     for i in range(len(data)):
#         for k in range(len(uniques)):
#             if data[i] == uniques[i]:
#                 break
#         else:
#             uniques._strref_from_start
