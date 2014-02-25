
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
        switch( replace[token][TYPE] ) {
          case STRING: return replace[token][STRING];
          case FILE: return new File(replace[token][FILE]).readAsStringSync();
          case RANDOM: 
            int max = replace[token][MAX];
            int min = replace[token][MIN];
            return new Random().nextInt(max-min) + min;
          default: 
            print('$jsonFile: Unsupported replace type: ${replace[token][TYPE]}');
            exit(1);
        }
      }
      return replace[token];
    });
  });
}
