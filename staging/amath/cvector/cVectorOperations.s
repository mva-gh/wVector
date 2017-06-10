(function _fVectorOperations_s_() {

'use strict';

var _ = wTools;
var _hasLength = _.hasLength;
var _arraySlice = _.arraySlice;
var _sqr = _.sqr;
var _assert = _.assert;
var _assertMapHasOnly = _.assertMapHasOnly;
var _routineIs = _.routineIs;

var _min = Math.min;
var _max = Math.max;
var _sqrt = Math.sqrt;
var _abs = Math.abs;

var _floor = Math.floor;
var _ceil = Math.ceil;
var _round = Math.round;

var EPS = _.EPS;
var EPS2 = _.EPS2;

var Parent = null;
var vector = wTools.vector;
var Self = vector.operations = vector.operations || Object.create( null );

// --
// atomWiseSingle
// --

var inv = Object.create( null );

inv.onAtom = function inv( o )
{
  o.dstElement = 1 / o.srcElement;
}

//

var invOrOne = Object.create( null );

invOrOne.onAtom = function invOrOne( o )
{
  if( o.srcElement === 0 )
  o.dstElement = 1;
  else
  o.dstElement = 1 / o.srcElement;
}

//

var floor = Object.create( null );

floor.onAtom = function floor( o )
{
  o.dstElement = _floor( o.srcElement );
}

//

var ceil = Object.create( null );

ceil.onAtom = function ceil( o )
{
  o.dstElement = _ceil( o.srcElement );
}

//

var round = Object.create( null );

round.onAtom = function round( o )
{
  o.dstElement = _round( o.srcElement );
}

//

var routines =
{

  inv : inv,
  invOrOne : invOrOne,

  floor : floor,
  ceil : ceil,
  round : round,

}

//

function singleOperationsAdjust()
{
  for( var op in routines )
  {
    var operation = routines[ op ];

    if( operation.takingArguments === undefined )
    operation.takingArguments = [ 1,1 ];
    else if( _.numberIs( operation.takingArguments ) )
    operation.takingArguments = [ operation.takingArguments,operation.takingArguments ];
    operation.commutative = true;
    operation.atomWise = true;
    if( !operation.name )
    operation.name = operation.onAtom.name;

    _.assert( _.mapIs( operation ) );
    _.assert( _.routineIs( operation.onAtom ) );
    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( operation.onAtom.length === 1 );
    _.assert( !Self.atomWiseSingle[ op ] );

    Self.atomWiseSingle[ op ] = operation;

  }
}

var atomWiseSingle = Self.atomWiseSingle = Self.atomWiseSingle || Object.create( null );
singleOperationsAdjust();

// --
// atomWiseCommutative
// --

var add = Object.create( null );

add.onAtom = function add( o )
{
  o.dstElement = o.dstElement + o.srcElement;
}

add.onAtomBegin = function addBegin( o )
{
  o.dstElement = 0;
}

//

var sub = Object.create( null );

sub.onAtom = function sub( o )
{
  o.dstElement = o.dstElement - o.srcElement;
}

sub.onAtomBegin = function subBegin( o )
{
  o.dstElement = 0;
}

//

var mul = Object.create( null );

mul.onAtom = function mul( o )
{
  o.dstElement = o.dstElement * o.srcElement;
}

mul.onAtomBegin = function mulBegin( o )
{
  o.dstElement = 1;
}

//

var div = Object.create( null );

div.onAtom = function div( o )
{
  o.dstElement = o.dstElement / o.srcElement;
}

div.onAtomBegin = function divBegin( o )
{
  o.dstElement = 1;
}

//

var assign = Object.create( null );

assign.onAtom = function assign( o )
{
  o.dstElement = o.srcElement;
}

//

var min = Object.create( null );

min.onAtom = function min( o )
{
  o.dstElement = _min( o.dstElement , o.srcElement );
}

min.onAtomBegin = function minBegin( o )
{
  o.dstElement = +Infinity;
}

//

var max = Object.create( null );

max.onAtom = function max( o )
{
  o.dstElement = _max( o.dstElement , o.srcElement );
}

max.onAtomBegin = function maxBegin( o )
{
  o.dstElement = +Infinity;
}

//

var routines =
{

  add : add,
  sub : sub,
  mul : mul,
  div : div,

  assign : assign,
  min : min,
  max : max,

}

//

function parallelOperationsAdjust()
{
  for( var op in routines )
  {
    var operation = routines[ op ];
    if( operation.takingArguments === undefined )
    operation.takingArguments = [ 2,2 ];
    else if( _.numberIs( operation.takingArguments ) )
    operation.takingArguments = [ operation.takingArguments,operation.takingArguments ];
    operation.commutative = true;
    operation.atomWise = true;

    operation.onAtom.operation = operation;
    if( !operation.name )
    operation.name = operation.onAtom.name;

    _.assert( _.mapIs( operation ) );
    _.assert( _.routineIs( operation.onAtom ) );
    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( operation.onAtom.length === 1 );
    _.assert( !Self.atomWiseCommutative[ op ] );

    Self.atomWiseCommutative[ op ] = operation;

  }
}

var atomWiseCommutative = Self.atomWiseCommutative = Self.atomWiseCommutative || Object.create( null );
parallelOperationsAdjust();

// --
// atomWiseNotCommutative
// --

var addScaled = Object.create( null );

addScaled.onAtom = function addScaled( o )
{
  o.dstElement = o.dstElement + ( o.srcElements[ 0 ]*o.srcElements[ 1 ] );
}

addScaled.takingArguments = 3;
addScaled.input = [ 'vw','vr|s*2' ];

//

var subScaled = Object.create( null );

subScaled.onAtom = function subScaled( o )
{
  o.dstElement = o.dstElement - ( o.srcElements[ 0 ]*o.srcElements[ 1 ] );
}

subScaled.takingArguments = 3;
subScaled.input = [ 'vw','vr|s*2' ];

//

var mulScaled = Object.create( null );

mulScaled.onAtom = function mulScaled( o )
{
  o.dstElement = o.dstElement * ( o.srcElements[ 0 ]*o.srcElements[ 1 ] );
}

mulScaled.takingArguments = 3;
mulScaled.input = [ 'vw','vr|s*2' ];

//

var divScaled = Object.create( null );

divScaled.onAtom = function divScaled( o )
{
  o.dstElement = o.dstElement / ( o.srcElements[ 0 ]*o.srcElements[ 1 ] );
}

divScaled.takingArguments = 3;
divScaled.input = [ 'vw','vr|s*2' ];

//

var clamp = Object.create( null );

clamp.onAtom = function clamp( o )
{
  o.dstElement = _min( _max( o.srcElements[ 0 ] , o.srcElements[ 1 ] ),o.srcElements[ 2 ] );
}

clamp.takingArguments = 4;
clamp.input = [ 'vw','vr|s*3' ];

//

var mix = Object.create( null );

mix.onAtom = function mix( o )
{
  debugger;
  o.dstElement = ( o.srcElements[ 0 ] )*o.srcElements[ 1 ] + ( 1-o.srcElements[ 0 ] )*o.srcElements[ 1 ];
}

mix.takingArguments = 4;
mix.input = [ 'vw','vr|s*3' ];

//

var routines =
{

  addScaled : addScaled,
  subScaled : subScaled,
  mulScaled : mulScaled,
  divScaled : divScaled,

  clamp : clamp,
  mix : mix,

}

//

function notParallelOperationsAdjust()
{
  for( var op in routines )
  {
    var operation = routines[ op ];

    if( _.numberIs( operation.takingArguments ) )
    operation.takingArguments = [ operation.takingArguments,operation.takingArguments ];
    operation.commutative = false;
    operation.atomWise = true;

    operation.onAtom.operation = operation;
    if( !operation.name )
    operation.name = operation.onAtom.name;

    _.assert( _.mapIs( operation ) );
    _.assert( _.routineIs( operation.onAtom ) );
    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( operation.onAtom.length === 1 );
    _.assert( !Self.atomWiseNotCommutative[ op ] );

    Self.atomWiseNotCommutative[ op ] = operation;

  }
}

var atomWiseNotCommutative = Self.atomWiseNotCommutative = Self.atomWiseNotCommutative || Object.create( null );
notParallelOperationsAdjust();

})();
