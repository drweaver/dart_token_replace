library token_replace;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

typedef String exchangeToken(String token);



class TokenReplace {
  File inputFile;
  File outputFile;

  final RegExp pattern = new RegExp(r'(@@([^@\s]+)@@)');
  
  TokenReplace(this.inputFile, this.outputFile);
  
  void replaceAll( exchangeToken callback ) {
    
    var out = outputFile.openWrite();
    
    inputFile.readAsLines().then( (List<String> lines) {
      lines.forEach((String line) {
        out.writeln(line.replaceAllMapped(pattern, (Match m) => callback(m[2])));
      });
    });
    
    //TODO: Return future?
      
  }
  
}