String translatePythonToCpp(String pythonCode) {
  List<String> lines = pythonCode.split('\n');
  String cppCode = "";
  int indentLevel = 0;

  for (String line in lines) {
    line = line.trim();

    if (line.isEmpty) {
      cppCode += '\n';
      continue;
    }

    if (line.startsWith('if') && line.contains(':')) {
      // Handle if statements
      String condition = line.substring(2, line.indexOf(':')).trim();
      cppCode += '  ' * indentLevel + 'if (' + condition + ') {\n';
      indentLevel++;
    } else if (line.startsWith('elif') && line.contains(':')) {
      // Handle elif statements
      indentLevel--; // Close previous block
      cppCode += '  ' * indentLevel + '}\n';
      String condition = line.substring(4, line.indexOf(':')).trim();
      cppCode += '  ' * indentLevel + 'else if (' + condition + ') {\n';
      indentLevel++;
    } else if (line.startsWith('else:')) {
      // Handle else statements
      indentLevel--; // Close previous block
      cppCode += '  ' * indentLevel + '}\n';
      cppCode += '  ' * indentLevel + 'else {\n';
      indentLevel++;
    } else if (line.startsWith('while ') && line.contains(':')) {
      //Handle while loops
      String condition = line.substring(5, line.indexOf(":")).trim();
      cppCode += ' ' * indentLevel + 'while (' + condition + ') {\n';
      indentLevel++;
    } else if (line.startsWith('for') && line.contains('range')) {
      // Handle for loops
      int startIndex = line.indexOf('range(') + 6;
      int endIndex = line.indexOf(')', startIndex);
      String loopRange = line.substring(startIndex, endIndex).trim();
      int start = line.indexOf('range (') + 7;
      int end = line.indexOf(')', start);
      String range = line.substring(start, end).trim();

      // Check if loopRange is a valid number
      if (int.tryParse(loopRange) != null) {
        cppCode += '  ' * indentLevel +
            'for (int i = 0; i < ' +
            loopRange +
            '; i++) {\n';
        indentLevel++;
      } else if (int.tryParse(range) != null) {
        cppCode +=
            '  ' * indentLevel + 'for (int i = 0; i < ' + range + '; i++) {\n';
        indentLevel++;
      } else {
        cppCode +=
            '  ' * indentLevel + '// Error: Invalid range value in for loop\n';
      }
    } else if (line.contains('**')) {
      // Use regular expressions to find `a ** b` and convert to `pow(a, b)`
      RegExp exp = RegExp(r'(\w+)\s*\*\*\s*(\w+)');
      String convertedLine = line.replaceAllMapped(
          exp, (match) => 'pow(${match[1]}, ${match[2]})');

      // Add the converted line to cppCode
      cppCode += '  ' * indentLevel + convertedLine + ';\n';
    } else if (line.startsWith('print')) {
      // Handle print statements
      String toPrint =
          line.substring(line.indexOf('(') + 1, line.indexOf(')')).trim();
      cppCode +=
          '  ' * indentLevel + 'std::cout << ' + toPrint + ' << std::endl;\n';
    } else if (line.startsWith('def ')) {
      // Extract the function signature and remove the trailing colon
      String functionSignature = line.substring(4, line.indexOf(':')).trim();

      // Extract function name and arguments
      int nameEndIndex = functionSignature.indexOf('(');
      String functionName = functionSignature.substring(0, nameEndIndex).trim();
      String arguments = functionSignature.substring(nameEndIndex).trim();

      // Translate to C++ syntax
      cppCode +=
          '  ' * indentLevel + 'void ' + functionName + arguments + ' {\n';
      indentLevel++;
    } else if (line.startsWith('return ')) {
      cppCode +=
          '  ' * indentLevel + 'return ' + line.substring(7).trim() + ';\n';
    } //operator pow()
    else if (line.contains('**')) {
    } else if ((line.contains(' = ') && !line.contains('def')) ||
        (line.contains('=') && !line.contains('def')) ||
        (line.contains(' =') && !line.contains('def')) ||
        (line.contains('= ') && !line.contains('def'))) {
      // Handle variable assignment
      String assignment = "";
      if (line.contains('"')) {
        // Handle string assignment
        String variableName = line.substring(0, line.indexOf('=')).trim();
        String value =
            line.substring(line.indexOf('=') + 1).trim().replaceAll('"', '');
        assignment = 'std::string ' + variableName + ' = "' + value + '";';
      } else if (line.contains('.')) {
        // Handle float assignment
        assignment = "float " + line + ";";
      } else if (line.contains('[') && line.contains(']')) {
        // Extract list elements and variable name
        // Extract the variable name and list elements
        String variableName = line.substring(0, line.indexOf('=')).trim();
        String listElements =
            line.substring(line.indexOf('[') + 1, line.indexOf(']')).trim();

        // Split elements by commas to count them
        List<String> elements =
            listElements.split(',').map((e) => e.trim()).toList();
        int arraySize = elements.length;

        // Generate C++ code for an integer array
        assignment += 'int ' + variableName + '[' + arraySize.toString() +'] = {' + listElements + '};\n';

      } else {
        // Handle integer assignment
        assignment = "int " + line + ";";
      }
      cppCode += '  ' * indentLevel + assignment + '\n';
    } else {
      cppCode += '  ' * indentLevel + line + '\n';
    }
  }

  // Close all remaining open blocks
  while (indentLevel > 0) {
    indentLevel--;
    cppCode += '  ' * indentLevel + '}\n';
  }

  return cppCode;
}
