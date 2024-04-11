from builtin.string import chr
from python import Python
from collections.optional import Optional


fn read_content[input: StringLiteral]() -> Optional[List[String]]:
    try:
        with open(input, "r") as f:
            var lines = f.read().split("\n")
            return Optional(lines)
    except:
        return None


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
