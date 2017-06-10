(function _xAnArray_s_() {

'use strict';

if( typeof module !== 'undefined' )
{
  try
  {
    require( './cArithmetic.s' );
  }
  catch( err )
  {
  }
  require( './fVector.s' );
}

var _ = wTools;
var _row = _.vector;
var _min = Math.min;
var _max = Math.max;
var _arraySlice = Array.prototype.slice;
var _sqrt = Math.sqrt;
var _sqr = _.sqr;

var Parent = null;
var Self = Object.create( null );

// --
// proto
// --

var Proto =
{
}

_.accessorForbid
({
  object : Self,
  names : _.vector.Forbidden,
});

// --
// row wrap
// --

var routines = _row._routineMathematical;
for( var r in routines )
{

  if( Self[ r ] )
  {
    debugger;
    continue;
  }

  function onReturn( result,theRoutine )
  {
    var op = theRoutine.operation;
    if( op.returningSelf )
    {
      return result.toArray();
    }
    else if( op.returningNew )
    {
      return result.toArray();
    }
    else if( op.returningArray )
    {
      if( !_.arrayIs( result ) && !_.bufferTypedIs( result ) )
      throw _.err( 'unexpected' );
      return result;
    }
    else
    return result;
  }

  Proto[ r ] = _.vector.withWrapper
  ({
    routine : routines[ r ],
    onReturn : onReturn,
    usingThisAsFirstArgument : 0,
  });

}

// --
// proto extension
// --

Object.setPrototypeOf( Self,wTools );

_.mapExtend( Self,Proto );
/*_.mapSupplement( Self,numeric );*/

wTools.anarray = Self;

_.assert( Object.getPrototypeOf( Self ) === wTools );
_.assert( _.objectIs( _row._routineMathematical ) );
_.assert( _.anarray.isValid );

})();
