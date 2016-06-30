/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var typeConvertion_1 = require('../typeConvertion');
var vscode = require('vscode');
var serverUtils = require("../omnisharpUtils");
var _testOutputChannel = undefined;
function getTestOutputChannel() {
    if (_testOutputChannel == undefined) {
        _testOutputChannel = vscode.window.createOutputChannel(".NET Test Log");
    }
    return _testOutputChannel;
}
function registerDotNetTestRunCommand(server) {
    return vscode.commands.registerCommand('dotnet.test.run', function (testMethod, fileName) { return runDotnetTest(testMethod, fileName, server); });
}
exports.registerDotNetTestRunCommand = registerDotNetTestRunCommand;
function registerDotNetTestDebugCommand(server) {
    return vscode.commands.registerCommand('dotnet.test.debug', function (testMethod, fileName) { return debugDotnetTest(testMethod, fileName, server); });
}
exports.registerDotNetTestDebugCommand = registerDotNetTestDebugCommand;
// Run test through dotnet-test command. This function can be moved to a separate structure
function runDotnetTest(testMethod, fileName, server) {
    getTestOutputChannel().show();
    getTestOutputChannel().appendLine('Running test ' + testMethod + '...');
    serverUtils
        .runDotNetTest(server, { FileName: fileName, MethodName: testMethod })
        .then(function (response) {
        if (response.Pass) {
            getTestOutputChannel().appendLine('Test passed \n');
        }
        else {
            getTestOutputChannel().appendLine('Test failed \n');
        }
    }, function (reason) {
        vscode.window.showErrorMessage("Failed to run test because " + reason + ".");
    });
}
exports.runDotnetTest = runDotnetTest;
// Run test through dotnet-test command with debugger attached
function debugDotnetTest(testMethod, fileName, server) {
    serverUtils.getTestStartInfo(server, { FileName: fileName, MethodName: testMethod }).then(function (response) {
        vscode.commands.executeCommand('vscode.startDebug', {
            "name": ".NET test launch",
            "type": "coreclr",
            "request": "launch",
            "program": response.Executable,
            "args": response.Argument.split(' '),
            "cwd": "${workspaceRoot}",
            "stopAtEntry": false
        }).then(function (response) { }, function (reason) { vscode.window.showErrorMessage("Failed to start debugger on test because " + reason + "."); });
    });
}
exports.debugDotnetTest = debugDotnetTest;
function updateCodeLensForTest(bucket, fileName, node, isDebugEnable) {
    // backward compatible check: Features property doesn't present on older version OmniSharp
    if (node.Features == undefined) {
        return;
    }
    var testFeature = node.Features.find(function (value) { return value.Name == 'XunitTestMethod'; });
    if (testFeature) {
        // this test method has a test feature
        bucket.push(new vscode.CodeLens(typeConvertion_1.toRange(node.Location), { title: "run test", command: 'dotnet.test.run', arguments: [testFeature.Data, fileName] }));
        if (isDebugEnable) {
            bucket.push(new vscode.CodeLens(typeConvertion_1.toRange(node.Location), { title: "debug test", command: 'dotnet.test.debug', arguments: [testFeature.Data, fileName] }));
        }
    }
}
exports.updateCodeLensForTest = updateCodeLensForTest;
//# sourceMappingURL=dotnetTest.js.map