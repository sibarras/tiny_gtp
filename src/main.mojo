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


fn main():
    var possible_content = read_content[input="input.txt"]()
    if not possible_content:
        print("Failed to read content. Stopping...")
        return

    var content = possible_content.value()

    var unique_chars = Dict[String, Int]()
    for idx in range(len(content)):
        unique_chars[content[idx]] = 0

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

    for char in stoi:
        print(char[], end=",")
    print()

    fn encoder(inp: Optional[String], stoi: Dict[String, Int]) -> Optional[List[Int]]:
        if not inp:
            return None

        var inp_value = inp.value()
        var result = List[Int]()
        for i in range(len(inp_value)):
            var num = stoi.find(inp_value[i])
            if not num:
                print("Failed to encode character: `", inp_value[i], "`", sep="")
                return None

            result.append(num.value())

        return Optional(result)

    fn decoder(inp: Optional[List[Int]], itos: Dict[Int, String]) -> Optional[String]:
        if not inp:
            return None

        var inp_value = inp.value()
        var result = String()
        for i in inp_value:
            var char = itos.find(i[])
            if not char:
                print("Failed to decode number: `", i[], "`", sep="")
                return None
            result += char.value()
        return Optional(result)

    var to_encode = Optional(String("Hello my Friend!"))
    var encoded = encoder(to_encode, stoi)
    var decoded = decoder(encoded, itos)
    if decoded:
        print(decoded.value())
    else:
        print("Failed to decode")
