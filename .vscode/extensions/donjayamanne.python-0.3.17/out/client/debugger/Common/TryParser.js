"use strict";
var LineByLineReader = require("line-by-line");
function ExtractTryStatements(pythonFile) {
    return new Promise(function (resolve) {
        var lr = new LineByLineReader(pythonFile);
        var lineNumber = 0;
        var tryStatements = [];
        var tryColumnBlocks = new Map();
        lr.on("error", function (err) {
            resolve(tryStatements);
        });
        lr.on("line", function (line) {
            lineNumber++;
            // Valid parts of a try block include
            // try:, except <error>:, except: else: finally:
            // Anything other than this in the same column indicates a termination of the try block
            var trimmedLine = line.trim();
            var matches = line.match(/^\s*try(\s*):/);
            if (matches !== null && matches.length > 0) {
                var column = line.indexOf("try");
                if (column === -1) {
                    return;
                }
                // If the new try starts at the same column
                // Then the previous try block has ended
                if (tryColumnBlocks.has(column)) {
                    var tryBlockClosed = tryColumnBlocks.get(column);
                    tryColumnBlocks.delete(column);
                    tryStatements.push(tryBlockClosed);
                }
                var tryStatement = {
                    Column: column,
                    EndLineNumber: 0,
                    Exceptions: [],
                    StartLineNumber: lineNumber
                };
                tryColumnBlocks.set(column, tryStatement);
                return;
            }
            // look for excepts
            matches = line.match(/^\s*except/);
            if (matches !== null && matches.length > 0 &&
                (trimmedLine.startsWith("except ") || trimmedLine.startsWith("except:"))) {
                // Oops something has gone wrong
                if (tryColumnBlocks.size === 0) {
                    resolve(tryStatements);
                    lr.close();
                    return;
                }
                var column = line.indexOf("except");
                // Do we have a try block for this same column                
                if (!tryColumnBlocks.has(column)) {
                    return;
                }
                var currentTryBlock = tryColumnBlocks.get(column);
                var exceptions = extractExceptions(line);
                currentTryBlock.Exceptions = currentTryBlock.Exceptions.concat(exceptions);
                if (currentTryBlock.EndLineNumber === 0) {
                    currentTryBlock.EndLineNumber = lineNumber;
                }
                return;
            }
            // look for else
            matches = line.match(/^\s*else(\s*):/);
            if (matches !== null && matches.length > 0 &&
                (trimmedLine.startsWith("else ") || trimmedLine.startsWith("else:"))) {
                // This is possibly an if else... 
                if (tryColumnBlocks.size === 0) {
                    return;
                }
                var column = line.indexOf("else");
                // Check if we have a try associated with this column
                // If not found, this is probably an if else block or something else
                if (!tryColumnBlocks.has(column)) {
                    return;
                }
                // Else marks the end of the try block (of course there could be a finally too)
                var currentTryBlock = tryColumnBlocks.get(column);
                if (currentTryBlock.EndLineNumber === 0) {
                    currentTryBlock.EndLineNumber = lineNumber;
                }
                tryColumnBlocks.delete(column);
                tryStatements.push(currentTryBlock);
                return;
            }
            // look for finally
            matches = line.match(/^\s*finally(\s*):/);
            if (matches !== null && matches.length > 0 &&
                (trimmedLine.startsWith("finally ") || trimmedLine.startsWith("finally:"))) {
                var column = line.indexOf("finally");
                // Oops something has gone wrong, or we cleared the previous
                // Try block because we encountered an else
                if (tryColumnBlocks.size === 0) {
                    return;
                }
                // If this column doesn't match the current exception block, then it is likely we encountered an else for the try block..
                // & we closed it off
                // So don't treat it as an exception, but proceed
                if (!tryColumnBlocks.has(column)) {
                    return;
                }
                // Finally marks the end of the try block
                var currentTryBlock = tryColumnBlocks.get(column);
                if (currentTryBlock.EndLineNumber === 0) {
                    currentTryBlock.EndLineNumber = lineNumber;
                }
                tryColumnBlocks.delete(column);
                tryStatements.push(currentTryBlock);
            }
        });
        lr.on("end", function () {
            // All try blocks that haven't been popped can be popped now
            // Only if their line numbers have valid end lines
            tryColumnBlocks.forEach(function (tryBlock) {
                if (tryBlock.EndLineNumber > 0) {
                    tryStatements.push(tryBlock);
                }
            });
            resolve(tryStatements);
        });
    });
}
exports.ExtractTryStatements = ExtractTryStatements;
var EXCEPT_LENGTH = "except".length;
function extractExceptions(line) {
    var matches = line.match(/^\s*except(\s*):/);
    if (matches !== null && matches.length > 0) {
        return [];
    }
    // Remove brackets and : from this
    line = line.trim().substring(EXCEPT_LENGTH);
    line = line.substring(0, line.indexOf(":"));
    line = line.replace(/[\(\)]/g, "");
    var exceptions = [];
    line.split(",").forEach(function (ex) {
        ex = ex.trim();
        if (ex.length === 0) {
            return;
        }
        if (ex.indexOf(" as ") > 0) {
            exceptions.push(ex.substring(0, ex.indexOf(" as ")).trim());
        }
        else {
            exceptions.push(ex);
        }
    });
    return exceptions;
}
//# sourceMappingURL=TryParser.js.map