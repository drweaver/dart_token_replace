
import 'dart:io';
import 'dart:convert';

import 'package:token_replace/token_replace.dart';

const String REPLACE = 'replace';
const String OUTPUT = 'output';
const String OUTPUT_FILE = 'output_file';
const String TYPE = 'type';
const String STRING = 'string';
const String FILE = 'file';

void main(List<String> args) {
  
  if( args.isEmpty || args.length < 2 ) {
    print('Usage: dart token_replace.dart input_file_with_tokens replace.json');
    exit(1);
  }
  
  String inputFile = args[0];
  String jsonFile = args[1];
  
  List json = JSON.decode(new File(jsonFile).readAsStringSync());

  if( json is! List ) {
    print('$jsonFile: Expecting List at top level');
    exit(1);
  }
  
  json.forEach( (Map o) {
    print('Running replacement for ${o[OUTPUT_FILE]} using template $inputFile');
    final Map replace = o[REPLACE];
    new TokenReplace(new File(inputFile), new File(o[OUTPUT_FILE])).replaceAll((token) {
      
      if( !replace.containsKey(token) ) {
        print('$inputFile: No replacement defined for "$token"');
        exit(1);
      }
      if( replace[token] is Map ) {
        if( replace[token][TYPE] == STRING ) return replace[token][STRING];
        if( replace[token][TYPE] == FILE ) return new File(replace[token][FILE]).readAsStringSync();
      }
      return replace[token];
    });
  });
}
