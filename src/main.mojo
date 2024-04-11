from collections.optional import Optional
from collections.set import Set
from algorithm.sort import sort
from builtin.string import chr, ord


fn read_content[input: StringLiteral]() -> Optional[String]:
    try:
        with open(input, "r") as f:
            return Optional(f.read())
    except:
        return None


fn generate_encoder(
    inout mapper: Dict[String, Int]
) -> fn (String) escaping -> List[Int]:
    fn encoder(inp: String) -> List[Int]:
        var result = List[Int]()
        for i in range(len(inp)):
            var num = mapper.find(inp[i]).value()
            result.append(num)
        return result

    return encoder


fn generate_decoder(mapper: Dict[Int, String]) -> fn (List[Int]) escaping -> String:
    fn decoder(inp: List[Int]) -> String:
        var result = String()
        for i in inp:
            var char = mapper.find(i[]).value()
            result += char
        return result

    return decoder


fn main():
    var possible_content = read_content[input="input.txt"]()
    if not possible_content:
        print("Failed to read content. Stopping...")
        return

    var content = possible_content.value()

    var unique_chars = Set[String]()
    for idx in range(len(content)):
        unique_chars.add(content[idx])

    print("size:", len(unique_chars))

    var chrs_indexes = List[Int]()
    for char in unique_chars:
        chrs_indexes.append(ord(char[]))

    sort(chrs_indexes)

    var chars = String()
    for i in chrs_indexes:
        chars += chr(i[])

    print(chars)

    var stoi = Dict[String, Int]()
    var itos = Dict[Int, String]()
    for i in range(len(chars)):
        stoi[chars[i]] = i
        itos[i] = chars[i]

    var encoder = generate_encoder(stoi)
    var decoder = generate_decoder(itos)

    print(decoder(encoder("Hello!")))
