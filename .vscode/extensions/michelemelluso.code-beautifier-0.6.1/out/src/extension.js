"use strict";
var vscode = require('vscode');
var jsbeautify = require("js-beautify");
var standardFormat = require("standard-format");
var tabSize = vscode.workspace.getConfiguration('editor').get("tabSize", 4);
function activate(context) {
    context.subscriptions.push(vscode.commands.registerCommand('beautify.format', function () {
        var window = vscode.window;
        var range, options;
        var activeEditor = window.activeTextEditor;
        if (!activeEditor) {
            return;
        }
        var document = activeEditor.document;
        if (range === null) {
            var start = new vscode.Position(0, 0);
            var end = new vscode.Position(document.lineCount - 1, document.lineAt(document.lineCount - 1).text.length);
            range = new vscode.Range(start, end);
        }
        var result = [];
        var content = document.getText(range);
        var formatted = formatCode(content, document.languageId, options);
        if (formatted) {
            return activeEditor.edit(function (editor) {
                var start = new vscode.Position(0, 0);
                var end = new vscode.Position(document.lineCount - 1, document.lineAt(document.lineCount - 1).text.length);
                range = new vscode.Range(start, end);
                return editor.replace(range, formatted);
            });
        }
    }));
}
exports.activate = activate;
function formatCode(documentContent, languageId, options) {
    var formatFunc = null;
    switch (languageId) {
        case 'css':
        case 'sass':
            formatFunc = jsbeautify.css;
            break;
        case 'json':
        case 'typescript':
            formatFunc = jsbeautify.js;
            break;
        case 'javascript':
            formatFunc = standardFormat.transform;
            break;
        case 'html':
            formatFunc = jsbeautify.html;
            break;
        default:
            break;
    }
    if (!formatFunc)
        return;
    return formatFunc(documentContent, {
        indent_size: tabSize
    });
}
//# sourceMappingURL=extension.js.map