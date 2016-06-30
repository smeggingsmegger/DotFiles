"use strict";
var surround = require("./surround");
var vscode = require("vscode");
/**
 * Grabs all of the selections in the active text editor and tries to swap the
 * quotes.
 */
function swapQuotesOnCurrentSelections() {
    var editor = vscode.window.activeTextEditor;
    if (editor) {
        editor.edit(function (e) {
            editor.selections.forEach(function (selection, index) {
                var text = editor.document.getText(selection);
                e.replace(selection, surround.swapQuotes(text));
            });
        });
    }
}
exports.swapQuotesOnCurrentSelections = swapQuotesOnCurrentSelections;
/**
 * Called by vscode the first time this extension is activated.
 *
 * @context Data that private to this extension
 */
function activate(context) {
    context.subscriptions.push(vscode.commands.registerCommand("extension.swapQuotes", function () {
        swapQuotesOnCurrentSelections();
    }));
}
exports.activate = activate;
/**
 * Called by vscode when the extension is deactivated for the last time.
 */
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map