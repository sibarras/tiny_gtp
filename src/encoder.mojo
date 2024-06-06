
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