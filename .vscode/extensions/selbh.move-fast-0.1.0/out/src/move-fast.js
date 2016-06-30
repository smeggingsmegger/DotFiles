var vscode = require('vscode');
function activate(context) {
    var NUM_LINES = 5;
    context.subscriptions.push(vscode.commands.registerCommand('moveFast.up', function () {
        for (var i = 0; i < NUM_LINES; i += 1) {
            vscode.commands.executeCommand('cursorUp');
        }
    }));
    context.subscriptions.push(vscode.commands.registerCommand('moveFast.down', function () {
        for (var i = 0; i < NUM_LINES; i += 1) {
            vscode.commands.executeCommand('cursorDown');
        }
    }));
    context.subscriptions.push(vscode.commands.registerCommand('moveFast.upSelect', function () {
        for (var i = 0; i < NUM_LINES; i += 1) {
            vscode.commands.executeCommand('cursorUpSelect');
        }
    }));
    context.subscriptions.push(vscode.commands.registerCommand('moveFast.downSelect', function () {
        for (var i = 0; i < NUM_LINES; i += 1) {
            vscode.commands.executeCommand('cursorDownSelect');
        }
    }));
}
exports.activate = activate;
//# sourceMappingURL=move-fast.js.map