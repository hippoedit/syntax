/*
Don't edit this include file!
(Tested with xHarbour 2009 and Clipper 5.2)

If you want edit your Clipper, Harbour or xHarbour sources with HippoEDIT,
just include this file into your project
(#Include 'Cli_Hippo.ch')
*/

****************************************************************

/*
You can use regions as CSharp following this:
Region Reg1
  FUNCTION SomeFunc1()
  RETURN Nil
EndRegion

Region Reg2
  #Define CoolThing 'Cool! I like regions'
  FUNCTION SomeFunc2()
  RETURN Nil
  FUNCTION SomeFunc3()
    ? CoolThing
  RETURN Nil
EndRegion

Now, you can see, that SomeFunc1 is in the Reg1,
and SomeFunc2 and SomeFunc3 are in the Reg2 region.
*/
#Command Region <RegExpression> =>
#Command EndRegion =>

/*
And, If you want, make labels with one or two words
*/
#Command Label <LabelExpression1> [<LabelExpression2>] =>
****************************************************************

/*
If you want to collapse your functions exactly,
you can use the word RETURNO instead of RETURN.
Though HippoEdit can handle this problem perfectly, other editors perhaps can't.

FUNCTION NotNice()
	IF 1 = 1
		RETURN Nil // Editor is thinking, that it is the end of the Function
	ENDIF
RETURN Nil // Editor is thinking, it is a bad syntax

FUNCTION PerdectSyntax()
	IF 1 = 1
	RETURNO Nil // Equivalent with RETURN
	// Editor knows, that it isn't the end of the Function,
	// and Clipper is thinking, it is a RETURN
  ENDIF
  WHILE .T.
    ? 'I am a perpetum mobile'
  ENDDO
RETURN Nil // The end of the function. Editor knows.
*/

#Define RETURNO RETURN
#Define Returno RETURN
#Define returno RETURN

/*
If you want, you can use Forr instead of FOR, and Whilee instead of WHILE,
when you are not writing a loop.

Index on SomeFile ..... FOR MyCondition() // Editor is waiting for a NEXT.
Index on OtherFile .... Forr MyCondition() // Nice (Equivalent with FOR)
*/

#Define FORR FOR
#Define Forr FOR
#Define forr FOR

#Define WHILEE WHILE
#Define Whilee WHILE
#Define whilee WHILE

#Define Iff IF
#Define IFF IF
#Define IFf IF
/*
With xHarbour, you can use Switch inspirated by the C.
Switch
Case
Default
End

"End" word can be used by xHarbour in a lot of place.
For example, "End" is a tBrowse function.
If you want, you can use ENDSWITCH instead of END,
and DEFAULTSWITCH instead of DEFAULT, too.
*/
#Define ENDSWITCH End
#Define EndSwitch End
#Define endswitch End

#Define DEFAULTSWITCH Default
#Define DefaultSwitch Default
#Define defaultswitch Default

/*
In xHarbour, you can use Try-Catch blocks.
Try
Catch
Finally
End
If you want to use ENDTRY instead of END in a TRY block, just use
*/
#Define ENDTRY End
#Define EndTry End
#Define endtry End

/*
If you have an important think to do, you can use
TODO
and
Warning!
words in your comment, and they will highlight.
Use them just in comments!
*/
