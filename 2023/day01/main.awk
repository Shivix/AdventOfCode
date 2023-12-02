BEGIN { result = 0 }
{
    if (part == 2) {
        gsub(/one/, "one1one", $0)
        gsub(/two/, "two2two", $0)
        gsub(/three/, "three3three", $0)
        gsub(/four/, "four4four", $0)
        gsub(/five/, "five5five", $0)
        gsub(/six/, "six6six", $0)
        gsub(/seven/, "seven7seven", $0)
        gsub(/eight/, "eight8eight", $0)
        gsub(/nine/, "nine9nine", $0)
    }
}
match($0, /^[a-zA-Z]*([0-9]{1}?).*([0-9]{1})[a-zA-Z]*$/, arr){ if (arr[1] == "") arr[1] = arr[2]; result += arr[1] * 10 + arr[2] }
END { print result }
