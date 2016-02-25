.nil? can be used on any object and is true if the object is nil.

.empty? can be used on strings, arrays and hashes and returns true if:

String length == 0
Array length == 0
Hash length == 0
Running .empty? on something that is nil will throw a NoMethodError.

That is where .blank? comes in. It is implemented by Rails and will operate on any object as well as work like .empty? on strings, arrays and hashes.

nil.blank? == true
false.blank? == true
[].blank? == true
{}.blank? == true
"".blank? == true
5.blank? == false
0.blank? == false
.blank? also evaluates true on strings which are non-empty but contain only whitespace:

"  ".blank? == true
"  ".empty? == false
Rails also provides .present?, which returns the negation of .blank?.

Array gotcha: blank? will return false even if all elements of an array are blank. To determine blankness in this case, use all? with blank?, for example:

[ nil, '' ].blank? == false
[ nil, '' ].all? &:blank? == true 
