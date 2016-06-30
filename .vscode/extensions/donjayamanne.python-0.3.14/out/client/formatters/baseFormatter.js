"use strict";
var fs = require("fs");
var utils_1 = require("./../common/utils");
var editor_1 = require("./../common/editor");
var BaseFormatter = (function () {
    function BaseFormatter(Id, outputChannel, pythonSettings, workspaceRootPath) {
        this.Id = Id;
        this.outputChannel = outputChannel;
        this.pythonSettings = pythonSettings;
        this.workspaceRootPath = workspaceRootPath;
    }
    BaseFormatter.prototype.provideDocumentFormattingEdits = function (document, options, token, command, args) {
        var _this = this;
        this.outputChannel.clear();
        // autopep8 and yapf have the ability to read from the process input stream and return the formatted code out of the output stream
        // However they don't support returning the diff of the formatted text when reading data from the input stream
        // Yes getting text formatted that way avoids having to create a temporary file, however the diffing will have
        // to be done here in node (extension), i.e. extension cpu, i.e. les responsive solution
        var tmpFileCreated = document.isDirty;
        var filePromise = tmpFileCreated ? editor_1.getTempFileWithDocumentContents(document) : Promise.resolve(document.fileName);
        return filePromise.then(function (filePath) {
            if (token && token.isCancellationRequested) {
                return [filePath, ""];
            }
            return Promise.all([Promise.resolve(filePath), utils_1.execPythonFile(command, args.concat([filePath]), _this.workspaceRootPath)]);
        }).then(function (data) {
            // Delete the temporary file created
            if (tmpFileCreated) {
                fs.unlink(data[0]);
            }
            if (token && token.isCancellationRequested) {
                return [];
            }
            return editor_1.getTextEditsFromPatch(document.getText(), data[1]);
        }).catch(function (error) {
            _this.handleError(_this.Id, command, error);
        });
    };
    BaseFormatter.prototype.handleError = function (expectedFileName, fileName, error) {
        var customError = "Formatting with " + this.Id + " failed. Please install the formatter or turn it off.\n";
        if (typeof (error) === "object" && error !== null && (error.code === "ENOENT" || error.code === 127)) {
            // Check if we have some custom arguments such as "pylint --load-plugins pylint_django"
            // Such settings are no longer supported
            var stuffAfterFileName = fileName.substring(fileName.toUpperCase().lastIndexOf(expectedFileName) + expectedFileName.length);
            // Ok if we have a space after the file name, this means we have some arguments defined and this isn't supported
            if (stuffAfterFileName.trim().indexOf(" ") > 0) {
                customError = ("Formatting failed, custom arguments in the 'python.formatting." + this.Id + "Path' is not supported.\n") +
                    ("Custom arguments to the formatter can be defined in 'python.formatter." + this.Id + "Args' setting of settings.json.\n") +
                    "For further details, please see https://github.com/DonJayamanne/pythonVSCode/wiki/Troubleshooting-Linting#2-linting-with-xxx-failed-";
            }
        }
        this.outputChannel.appendLine(customError + "\n" + error);
        throw new Error("There was an error in formatting the document. View the Python output window for details.");
    };
    return BaseFormatter;
}());
exports.BaseFormatter = BaseFormatter;
//# sourceMappingURL=baseFormatter.js.map