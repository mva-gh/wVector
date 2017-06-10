
if( typeof module !== 'undefined' )
{
  require( 'wvector' );
  // require( '../staging/amath/arithmetic/xAnArray.s' );
}

var _ = wTools;
var a1 = [ 1,2,5,9 ];
var a2 = [ 1,2,3,4 ];

_.anarray.addVectors( a1,a2 );
console.log( 'a1',a1 );
console.log( 'a2',a2 );
