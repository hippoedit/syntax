/*
Hello Example for HippoEDIT
TODO - remove this
*/

FUNCTION Example()
 Local nValue := 1, cValue := 'This is a string'
 IF nValue <> 1
  @ 0,0 Say 'Never running'
  RETURN -1
 ELSE
  @ 0,0 Say 'Hello Clipper and Harbour!'
 ENDIF
RETURN /*end*/ Nil
