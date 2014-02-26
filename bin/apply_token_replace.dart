
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:token_replace/token_replace.dart';

const String REPLACE = 'replace';
const String OUTPUT = 'output';
const String OUTPUT_FILE = 'output_file';
const String TYPE = 'type';
const String STRING = 'string';
const String FILE = 'file';
const String RANDOM = 'random';
const String MAX = 'max';
const String MIN = 'min';

void error(String msg) {
  print(msg);
  exit(1);
}

void main(List<String> args) {
  
  if( args.isEmpty || args.length < 2 ) error('Usage: dart token_replace.dart input_file_with_tokens replace.json');
  
  String inputFile = args[0];
  String jsonFile = args[1];
  
  Map json = JSON.decode(new File(jsonFile).readAsStringSync());

  if( json is! Map ) error('$jsonFile: Expecting Map at top level');
  
  [REPLACE,OUTPUT].forEach((key){
    if( !json.containsKey(key) ) error('$jsonFile: Expecting $key at top level');
  });
  
  if( json[OUTPUT] is! List ) error('$jsonFile: Expecting List under $OUTPUT node');
  
  if( json[REPLACE] is! Map ) error('$jsonFile: Expecting Map under $REPLACE node');
  
  Map defaultReplace = json[REPLACE];
  
  json[OUTPUT].forEach( (Map o) {
    print('Running replacement for ${o[OUTPUT_FILE]} using template $inputFile');
    final Map replace = o[REPLACE];
    String outputFile = o[OUTPUT_FILE];
    if( outputFile == null ) error('$jsonFile: No $OUTPUT_FILE defined');
    new TokenReplace(new File(inputFile), new File(outputFile)).replaceAll((token) {
      var replacement;
      if( replace == null || !replace.containsKey(token) ) {
        if( !defaultReplace.containsKey(token)) error('$outputFile: No replacement defined for "$token"');
        replacement = defaultReplace[token];
      } else {
        replacement = replace[token];
      }
      if( replacement is Map ) {
        switch( replacement[TYPE] ) {
          case STRING: return replacement[STRING];
          case FILE: return new File(replacement[FILE]).readAsStringSync();
          case RANDOM: 
            int max = replacement[MAX];
            int min = replacement[MIN];
            return new Random().nextInt(max-min) + min;
          default:error('$jsonFile: Unsupported replace type: ${replacement[TYPE]}');
        }
      }
      return replacement;
    });
  });
}
