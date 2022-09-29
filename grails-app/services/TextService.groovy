class TextService {

private final aMap = [
    0:"",
    1:"un",
    2:"deux",
    3:"trois",
    4:"quatre",
    5:"cinq",
    6:"six",
    7:"sept",
    8:"huit",
    9:"neuf",
    10:"dix",
    11:"onze",
    12:"douze",
    13:"treize",
    14:"quatorze",
    15:"quinze",
    16:"seize",
    17:"dix sept",
    18:"dix huit",
    19:"dix neuf",
    20:"vingt",
    21:"vingt et un",
    30:"trente",
    31:"trente et un",
    40:"quarante",
    41:"quarante et un",
    50:"cinquante",
    51:"cinquante et un",
    60:"soixante",
    61:"soixante et un",
    70:"soixante dix",
    71:"soixante onze",
    72:"soixante douze",
    73:"soixante treize",
    74:"soixante quatorze",
    75:"soixante quinze",
    76:"soixante seize",
    77:"soixante dix sept",
    78:"soixante dix huit",
    79:"soixante dix neuf",
    80:"quatre vingt",
    81:"quatre vingt et un",
    90:"quatre vingt dix",
    91:"quatre vingt onze",
    92:"quatre vingt douze",
    93:"quatre vingt treize",
    94:"quatre vingt quatorze",
    95:"quatre vingt quinze",
    96:"quatre vingt seize",
    97:"quatre vingt dix sept",
    98:"quatre vingt dix huit",
    99:"quatre vingt dix neuf"
]
private Integer quotient(amount,howMany){(amount / howMany) as Integer}
private String alpha(amount,currency=false){
    def readyNum = (amount ? aMap[amount.intValue()] : "")
    if (readyNum) {
        return readyNum
    } else {
        def result = ""
        def letterify = {qty,word,plural=true->
            if (qty) {
                result += " ${aMap[qty] ?: alpha(qty)}${word}${(plural && qty > 1) ? 's ' : ' '}"
            }
        }
        def billions = quotient(amount,1000000000)
        letterify(billions,' milliard')
        def millions = Math.max(quotient(amount,1000000) - 1000 * billions,0)
        letterify(millions,' million')
        def thousands = Math.max(quotient(amount,1000) - 1000 * millions - 1000000 * billions,0)
        if (thousands == 1) {
            result += ' mille'
        } else {
            letterify(thousands,' mille',false)
        }
        def hundreds = quotient(quotient(amount - 1000 * thousands - 1000000 * millions - 1000000000 * billions,1),100)
        if (hundreds == 1) {
            result += ' cent'
        } else {
            letterify(hundreds,' cent', false)
        }
        def twoTens = quotient(amount - 100 * hundreds - 1000 * thousands - 1000000 * millions - 1000000000 * billions,1)
        def twoTensLetter = aMap[twoTens]
        if (twoTensLetter){
             letterify(twoTens,(currency ? ' dirham' : ''),currency)
        } else {
            def tens = quotient(amount - 100 * hundreds - 1000 * thousands - 1000000 * millions - 1000000000 * billions,10)
            letterify(tens * 10,'',false)
            def units = quotient(amount - 10 * tens - 100 * hundreds - 1000 * thousands - 1000000 * millions - 1000000000 * billions,1)
            letterify(units,(currency ? ' dirham' : ''),currency)
        }
        def decimals = quotient(amount * 100 - 100 * quotient(amount,1), 1)
        letterify(decimals,' centime')
        return result
    } 
}
def toLetters(amount){
    def rawAmount = alpha(amount,true)
    rawAmount.split(' ').findAll{it}.join(' ')
}

}