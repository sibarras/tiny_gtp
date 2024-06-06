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


fn encoder(inp: String, stoi: Dict[String, Int]) capturing raises -> List[Int]:
    var result = List[Int]()
    for i in range(len(inp)):
        var chr = inp[i]
        result.append(stoi[chr])

    return result

fn decoder(inp: List[Int], itos: Dict[Int, String]) capturing raises -> String:
    var result = String()
    for i in inp:
        result += itos[i[]]

    return result
