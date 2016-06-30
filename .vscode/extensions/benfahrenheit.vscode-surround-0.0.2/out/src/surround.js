"use strict";
/**
 * Given a potentially quoted string, swap between single and double
 * quotes. For example:
 *
 * "cat" becomes 'cat'
 * 'cat' becomes "cat"
 *
 * @param currentQuote The string whose surrounding quotes should be replaced
 * @return The contents of currentQuote with the surrounding quotes swapped
 */
function swapQuotes(currentQuote) {
    var matches = /^(["'])((?:(?=(?:\\)*)\\.|.)*?)\1/.exec(currentQuote);
    if (matches) {
        var otherQuote = (matches[1] === "'" ? "\"" : "'");
        return "" + otherQuote + matches[2] + otherQuote;
    }
    else {
        return currentQuote;
    }
}
exports.swapQuotes = swapQuotes;
//# sourceMappingURL=surround.js.map