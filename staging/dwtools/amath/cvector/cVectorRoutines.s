(function _fVectorRoutines_s_() {

'use strict';

var _ = wTools;
var _hasLength = _.hasLength;
var _arraySlice = _.arraySlice;
var _sqr = _.sqr;
var _sqrt = _.sqrt;
var _assert = _.assert;
var _assertMapHasOnly = _.assertMapHasOnly;
var _routineIs = _.routineIs;

var _min = Math.min;
var _max = Math.max;
var _pow = Math.pow;
var sqrt = Math.sqrt;
var abs = Math.abs;

var EPS = _.EPS;
var EPS2 = _.EPS2;
var sqrt2 = sqrt( 2 );
var sqrt2Inv = 1 / sqrt2;

var vector = wTools.vector;
var operations = vector.operations;
var Parent = null;
var Self = vector;
var Routines = Object.create( null );

/*

- do _operationReturningSelfTakingVariantsComponentWiseAct_functor's callbacks need operation descriptor???

*/

_.assert( operations );

// --
// structure
// --

var OperationDescriptor = _.like()
.also
({

  takingArguments : null,
  takingVectors : null,
  takingVectorsOnly : null,

  returningOnly : null,
  returningSelf : null,
  returningNew : null,
  returningArray : null,
  returningNumber : null,

  modifying : null,
  reducing : null,
  interruptible : null,

  onAtom : null,
  onAtomsBegin : null,
  onAtomsEnd : null,
  commutative : null,
  atomWise : null,
  name : null,
  postfix : null,
  atomOperation : null,
  input : null,

})
.end

// --
// basic
// --

function assign( dst )
{
  var length = dst.length;
  var alength = arguments.length;

  if( alength === 2 )
  {
    if( _.numberIs( arguments[ 1 ] ) )
    this.assignScalar( dst,arguments[ 1 ] );
    else if( _hasLength( arguments[ 1 ] ) )
    this.assignVector( dst,_.vector.fromArray( arguments[ 1 ] ) );
    else _.assert( 0,'unknown arguments' );
  }
  else if( alength === 1 + length )
  {
    this.assign.call( this,dst,_.vector.fromArray( _arraySlice( arguments,1,alength ) ) );
  }
  else _.assert( 0,'assign :','unknown arguments' );

  return dst;
}

var op = assign.operation = Object.create( null );
op.atomWise = true;
op.commutative = false;
op.takingArguments = [ 1,Infinity ];
op.takingVectors = [ 1,2 ];
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function assignVector( dst,src )
{
  var length = dst.length;

  _assert( dst && src,'vector :','expects ( src ) and ( dst )' );
  _assert( dst.length === src.length,'vector :','src and dst should have same length' );
  _assert( _.vectorIs( dst ) );
  _assert( _.vectorIs( src ) );

  for( var s = 0 ; s < length ; s++ )
  {
    dst.eSet( s,src.eGet( s ) );
  }

  return dst;
}

var op = assignVector.operation = Object.create( null );
op.atomWise = true;
op.commutative = true;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;
op.special = true;

//

function clone( src )
{
  var length = src.length;
  var dst = this.makeSimilar( src );

  _.assert( arguments.length === 1 )

  for( var s = 0 ; s < length ; s++ )
  dst.eSet( s,src.eGet( s ) );

  return dst;
}

var op = clone.operation = Object.create( null );
op.atomWise = true;
op.commutative = true;
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = true;
op.modifying = false;
op.special = true;

//

function makeSimilar( src,length )
{
  if( length === undefined )
  length = src.length;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( length ) );

  var dst = _.vector.fromArray( new src._vectorBuffer.constructor( length ) );

  return dst;
}

var op = makeSimilar.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 1,2 ];
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = true;
op.modifying = false;
op.special = true;

//

function slice( src,first,last )
{
  var length = src.length;
  var first = first || 0;
  var last = _.numberIs( last ) ? last : length;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );
  _.assert( src._vectorBuffer,'expects vector as argument' );

  var result;

  var offset = src.offset || 0;
  if( src.stride || offset || src._vectorBuffer.length !== last )
  {
    result = new src._vectorBuffer.constructor( last-first );
    for( var i = first ; i < last ; i++ )
    result[ i-first ] = src.eGet( i );
  }
  else
  {
    debugger; xxx
    // if( src._vectorBuffer.set )
    if( src._vectorBuffer.assign )
    {
      result = new src._vectorBuffer.constructor( last-first );
      result.assign( src._vectorBuffer );
    }
    else if( src._vectorBuffer.slice )
    {
      debugger;
      result = src._vectorBuffer.slice( first,last );
    }
    else throw _.err( 'unexpected' );
  }

  return result;
}

var op = slice.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 1,3 ];
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.returningArray = true;
op.modifying = false;

//

function subarray( src,first,last )
{
  var result;
  var length = src.length;
  var first = first || 0;
  var last = _.numberIs( last ) ? last : length;

  if( last > length )
  last = length;
  if( first < 0 )
  first = 0;
  if( first > last )
  first = last;

  _assert( arguments.length === 2 || arguments.length === 3 );
  _assert( src._vectorBuffer,'expects vector as argument' );
  _assert( src.offset >= 0 );

  if( src.stride !== 1 )
  {
    result = _.vector.fromSubArrayWithStride( src._vectorBuffer , src.offset + first*src.stride , last-first , src.stride );
  }
  else
  {
    result = _.vector.fromSubArray( src._vectorBuffer , src.offset + first , last-first );
  }

  return result;
}

var op = subarray.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 3;
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = true;
op.modifying = false;

//

function toArray( src )
{
  var result;
  var length = src.length;

  _assert( _.vectorIs( src ) || _.arrayLike( src ), 'expects vector as a single argument' );
  _assert( arguments.length === 1 );

  if( _.arrayLike( src ) )
  return src;

  if( src.stride !== 1 || src.offset !== 0 || src.length !== src._vectorBuffer.length )
  {
    result = _.arrayMakeSimilar( src._vectorBuffer,src.length );
    for( var i = 0 ; i < src.length ; i++ )
    result[ i ] = src.eGet( i );
  }
  else
  {
    result = src._vectorBuffer;
  }

  return result;
}

var op = toArray.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 1;
op.takingVectors = [ 0,1 ];
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = false;
op.returningArray = true;
op.modifying = false;

//

function _toStr( src,o )
{
  var result = '';
  var length = src.length;

  if( !o ) o = Object.create( null );
  if( o.percision === undefined ) o.percision = 4;

  if( length )
  if( o.percision === 0 )
  {
    throw _.err( 'not tested' );
    for( var i = 0,l = length-1 ; i < l ; i++ )
    {
      result += String( src.eGet( i ) ) + ' ';
    }
    result += String( src.eGet( i ) );
  }
  else
  {
    for( var i = 0,l = length-1 ; i < l ; i++ )
    {
      result += src.eGet( i ).toPrecision( o.percision ) + ' ';
    }
    result += src.eGet( i ).toPrecision( o.percision );
  }

  return result;
}

var op = _toStr.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 1,2 ];
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function gather( dst,srcs )
{

  var atomsPerElement = srcs.length;
  var l = dst.length / srcs.length;

  _.assert( arguments.length === 2 );
  _.assert( _.vectorIs( dst ) );
  _.assert( _.arrayIs( srcs ) );
  _.assert( _.numberIsInt( l ) );

  debugger;

  /* */

  for( var s = 0 ; s < srcs.length ; s++ )
  {
    var src = srcs[ s ];
    _.assert( _.numberIs( src ) || _.vectorIs( src ) || _.arrayLike( src ) );
    if( _.numberIs( src ) )
    continue;
    if( _.arrayLike( src ) )
    src = srcs[ s ] = _.vector.fromArray( src );
    _.assert( src.length === l );
  }

  /* */

  for( var e = 0 ; e < l ; e++ )
  {
    for( var s = 0 ; s < srcs.length ; s++ )
    {
      var v = _.numberIs( srcs[ s ] ) ? srcs[ s ] : srcs[ s ].eGet( e );
      dst.eSet( e*atomsPerElement + s , v );
    }
  }

  return dst;
}

var op = gather.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

// --
// not atom-wise : self
// --

function sort( dst,comparator )
{
  var length = dst.length;

  if( !comparator ) comparator = function( a,b ){ return a-b }; // xxx

  function _sort( left,right )
  {

    if( left >= right ) return;

    //console.log( '_sort :',left,right );

    var m = Math.floor( ( left+right ) / 2 );
    var mValue = dst.eGet( m );
    var l = left;
    var r = right;

    do
    {

      while( comparator( dst.eGet( l ),mValue ) < 0 )
      l += 1;

      while( comparator( dst.eGet( r ),mValue ) > 0 )
      r -= 1;

      if( l <= r )
      {
        var v = dst.eGet( l );
        dst.eSet( l,dst.eGet( r ) );
        dst.eSet( r,v );
        r -= 1;
        l += 1;
      }

    }
    while( l <= r );

    _sort( left,r );
    _sort( l,right );

  }

  _sort( 0,length-1 );

  return dst;
}

var op = sort.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 1,2 ];
op.takingVectors = [ 1,1 ];
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function randomInRadius( dst,radius )
{
  var length = dst.length;
  var o = Object.create( null );

  if( _.objectIs( radius ) )
  {
    o = radius;
    radius = o.radius;
  }

  if( o.attempts === undefined )
  o.attempts = 32;

  _assert( _.numberIs( radius ) );

  var radiusSqrt = sqrt( radius );
  var radiusSqr = _sqr( radius );
  var attempts = o.attempts;
  for( var a = 0 ; a < attempts ; a++ )
  {

    this.randomInRangeAssigning( dst,-radiusSqrt,+radiusSqrt );
    var m = this.magSqr( dst );
    if( m < radiusSqr ) break;

  }

  return dst;
}

var op = randomInRadius.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 2,2 ];
op.takingVectors = [ 1,1 ];
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function crossWithPoints( a, b, c, result )
{
  throw _.err( 'not tested' );

  _assert( a.length === 3 && b.length === 3 && c.length === 3,'implemented only for 3D' );

  debugger;
  var result = result || this.array.makeArrayOfLength( 3 );

  var ax = a.eGet( 0 )-c.eGet( 0 ), ay = a.eGet( 1 )-c.eGet( 1 ), az = a.eGet( 2 )-c.eGet( 2 );
  var bx = b.eGet( 0 )-c.eGet( 0 ), by = b.eGet( 1 )-c.eGet( 1 ), bz = b.eGet( 2 )-c.eGet( 2 );

  result.eSet( 0, ay * bz - az * by );
  result.eSet( 1, az * bx - ax * bz );
  result.eSet( 2, ax * by - ay * bx );

  return result;
}

var op = crossWithPoints.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 3,4 ];
op.takingVectors = [ 3,4 ];
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function _cross3( dst, src1, src2 )
{

  var src1x = src1.eGet( 0 );
  var src1y = src1.eGet( 1 );
  var src1z = src1.eGet( 2 );

  var src2x = src2.eGet( 0 );
  var src2y = src2.eGet( 1 );
  var src2z = src2.eGet( 2 );

  dst.eSet( 0, src1y * src2z - src1z * src2y );
  dst.eSet( 1, src1z * src2x - src1x * src2z );
  dst.eSet( 2, src1x * src2y - src1y * src2x );

  return dst;
}

var op = _cross3.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 3;
op.takingVectors = 3;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function cross3( dst, src1, src2 )
{

  _.assert( arguments.length === 3 );
  _.assert( dst.length === 3,'implemented only for 3D' );
  _.assert( src1.length === 3,'implemented only for 3D' );
  _.assert( src2.length === 3,'implemented only for 3D' );

  dst = _.vector.from( dst );
  src1 = _.vector.from( src1 );
  src2 = _.vector.from( src2 );

  return this._cross3( dst, src1, src2 );
}

var op = cross3.operation = _.mapExtend( null,_cross3.operation );

//

function cross( dst )
{

  var firstSrc = 1;
  if( dst === null )
  {
    dst = _.vector.from( arguments[ 1 ].slice() );
    firstSrc = 2;
    _.assert( arguments.length >= 3 );
  }

  _.assert( arguments.length >= 2 );
  _.assert( dst.length === 3,'implemented only for 3D' );

  for( var a = firstSrc ; a < arguments.length ; a++ )
  {
    var src = arguments[ a ];
    _.assert( src.length === 3,'implemented only for 3D' );
    this._cross3( dst, dst, src );
  }

  return dst;
}

var op = cross.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = [ 2,Infinity ];
op.takingVectors = [ 2,Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = true;
op.modifying = true;

//

function quaternionApply( dst,q )
{

  _assert( dst.length === 3 && q.length === 4,'quaternionApply :','expects vector and quaternion as arguments' );

  var x = dst.eGet( 0 );
  var y = dst.eGet( 1 );
  var z = dst.eGet( 2 );

  var qx = q.eGet( 0 );
  var qy = q.eGet( 1 );
  var qz = q.eGet( 2 );
  var qw = q.eGet( 3 );

  //

  var ix = + qw * x + qy * z - qz * y;
  var iy = + qw * y + qz * x - qx * z;
  var iz = + qw * z + qx * y - qy * x;
  var iw = - qx * x - qy * y - qz * z;

  //

  dst.eSet( 0, ix * qw + iw * - qx + iy * - qz - iz * - qy );
  dst.eSet( 1, iy * qw + iw * - qy + iz * - qx - ix * - qz );
  dst.eSet( 2, iz * qw + iw * - qz + ix * - qy - iy * - qx );

  // xxx
/*
  clone.quaternionApply2( q );
  var err = clone.distanceSqr( this );
  if( Math.abs( err ) > 0.0001 )
  throw _.err( 'Vector :','Something wrong' );
*/
  // xxx

  return dst;
}

var op = quaternionApply.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

/*
v' = q * v * conjugate(q)
--
t = 2 * cross(q.xyz, v)
v' = v + q.w * t + cross(q.xyz, t)
*/

function quaternionApply2( dst,q )
{

  _assert( dst.length === 3 && q.length === 4,'quaternionApply :','expects vector and quaternion as arguments' );
  throw _.err( 'not tested' );
  var qvector = this.fromSubArray( dst,0,3 );

  var cross1 = this.cross( qvector,dst );
  this.mulScalar( cross1,2 );

  var cross2 = this.cross( qvector,cross1 );
  this.mulScalar( cross1,q.eGet( 3 ) );

  dst.eSet( 0, dst.eSet( 0 ) + cross1.eGet( 0 ) + cross2.eGet( 0 ) );
  dst.eSet( 1, dst.eGet( 1 ) + cross1.eGet( 1 ) + cross2.eGet( 1 ) );
  dst.eSet( 2, dst.eGet( 2 ) + cross1.eGet( 2 ) + cross2.eGet( 2 ) );

  return dst;
}

var op = quaternionApply2.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function eulerApply( v,e )
{

  _.assert( arguments.length === 2 );

  throw _.err( 'not implemented' )

}

var op = eulerApply.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function reflect( v,normal )
{

  _.assert( arguments.length === 2 );
  _.assert( _.vectorIs( v ) );
  _.assert( _.vectorIs( normal ) );

  debugger;
  throw _.err( 'not tested' );

  var result = this.mulScalar( normal.clone() , 2*this.dot( v,normal ) );

  return result;
}

var op = reflect.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function matrixApplyTo( dst,srcMatrix )
{
  _.assert( arguments.length === 2 );
  _.assert( _.spaceIs( srcMatrix ) );
  debugger;
  return _.space.mul( dst,[ srcMatrix,dst ] );
}

var op = matrixApplyTo.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.takindistanceSqrgVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function matrixHomogenousApply( dst,srcMatrix )
{
  _.assert( arguments.length === 2 );
  _.assert( _.spaceIs( srcMatrix ) );
  return srcMatrix.matrixHomogenousApply( dst );
}

var op = matrixHomogenousApply.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function matrixDirectionsApply( v,m )
{
  _.assrt( arguments.length === 2 );
  m.matrixDirectionsApply( v );
  return v;
}

var op = matrixDirectionsApply.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function swapVectors( v1,v2 )
{

  _assert( arguments.length === 2 );
  _assert( v1.length === v2.length );

  for( var i = 0 ; i < v1.length ; i++ )
  {
    var val = v1.eGet( i );
    v1.eSet( i,v2.eGet( i ) );
    v2.eSet( i,val );
  }

}

var op = swapVectors.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = true;

//

function swapAtoms( v,i1,i2 )
{

  _assert( arguments.length === 3 );
  _assert( 0 <= i1 && i1 < v.length );
  _assert( 0 <= i2 && i2 < v.length );
  _assert( _.numberIs( i1 ) );
  _assert( _.numberIs( i2 ) );

  var val = v.eGet( i1 );
  v.eSet( i1,v.eGet( i2 ) );
  v.eSet( i2,val );

  return v;
}

var op = swapAtoms.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 3;
op.takingVectors = 1;
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function formate( dst,srcs )
{
  var ape = srcs.length;
  var l = dst.length / ape;

  _.assert( _.arrayIs( srcs ) );
  _.assert( _.numberIsInt( l ) );

  // debugger;

  for( var a = 0 ; a < ape ; a++ )
  {
    var src = srcs[ a ];

    if( _.numberIs( src ) )
    {
      for( var i = 0 ; i < l ; i++ )
      dst.eSet( i*ape+a , src );
    }
    else
    {
      src = _.vector.from( src );
      _.assert( src.length === l );
      for( var i = 0 ; i < l ; i++ )
      dst.eSet( i*ape+a , src.eGet( i ) );
    }
  }

  // debugger;
  return dst;
}

var op = formate.operation = Object.create( null );
op.takingArguments = [ 1,2 ];
op.takingVectors = [ 1,1 ];
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;
op.reducing = false;
op.commutative = false;

// --
// atom-wise, modifying, taking single vector : self
// --

function _operationTakingDstSrcReturningSelfComponentWise_functor( o )
{

  var onEach = o.onEach;
  var onAtomsBegin = o.onAtomsBegin || function(){};
  var onAtomsEnd = o.onAtomsEnd || function(){};

  _assert( _.objectIs( o ) );
  _assert( _.routineIs( onEach ) );
  _assert( _.routineIs( onAtomsBegin ) );
  _assert( _.routineIs( onAtomsEnd ) );
  _assert( arguments.length === 1 );

  var routine = function _operationTakingDstSrcReturningSelfComponentWise( dst,src )
  {

    var length = dst.length;
    if( !src )
    src = dst;

    _assert( arguments.length <= 2 );
    _assert( dst.length === src.length,'src and dst must have same length' );

    onAtomsBegin.call( this,dst,src );

    for( var i = 0 ; i < length ; i++ )
    onEach.call( this,dst,src,i );

    onAtomsEnd.call( this,dst,src );

    return dst;
  }

  var op = routine.operation = Object.create( null );
  op.atomWise = true;
  op.commutative = true;
  op.takingArguments = [ 1,2 ];
  op.takingVectors = [ 1,2 ];
  op.takingVectorsOnly = true;
  op.returningSelf = true;
  op.returningNew = false;
  op.returningArray = false;
  op.modifying = true;

  return routine;
}

//

var inv = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function inv( dst,src,i )
  {
    dst.eSet( i, 1 / src.eGet( i ) );
  }
});

//

var invOrOne = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function invOrOne( dst,src,i )
  {
    if( src.eGet( i ) === 0 )
    dst.eSet( i,1 );
    else
    dst.eSet( i,1 / src.eGet( i ) );
  }
});

//

var floor = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function floor( dst,src,i )
  {
    dst.eSet( i, Math.floor( src.eGet( i ) ) );
  }
});

//

var ceil = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function ceil( dst,src,i )
  {
    dst.eSet( i, Math.ceil( src.eGet( i ) ) );
  }
});

//

var abs = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function abs( dst,src,i )
  {
    dst.eSet( i, Math.abs( src.eGet( i ) ) );
  }
});

//

// var round = _operationTakingDstSrcReturningSelfComponentWise_functor
// ({
//   onEach : function round( dst,src,i )
//   {
//     debugger;
//     dst.eSet( i, Math.round( src.eGet( i ) ) );
//   }
// });

//

var _normalizeM;
var normalize = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onAtomsBegin : function normalize( dst,src )
  {
    _normalizeM = this.mag( src );
    if( !_normalizeM )
    _normalizeM = 1;
    _normalizeM = 1 / _normalizeM;
  },
  onEach : function normalize( dst,src,i )
  {
    dst.eSet( i,src.eGet( i ) * _normalizeM );
  },
});

// --
// float / vector
// --

function _operationReturningSelfTakingVariantsComponentWise_functor( operation )
{
  var result = Object.create( null );

  _.assert( operation.assigning === undefined );

  var operationForFunctor = _.mapExtend( null,operation );
  operationForFunctor.assigning = 1;
  result.assigning = _operationReturningSelfTakingVariantsComponentWiseAct_functor( operationForFunctor );

  var operationForFunctor = _.mapExtend( null,operation );
  operationForFunctor.assigning = 0;
  result.copying = _operationReturningSelfTakingVariantsComponentWiseAct_functor( operationForFunctor );

  return result;
}

_operationReturningSelfTakingVariantsComponentWise_functor.defaults =
{
  takingArguments : null,
  homogenous : 0,
  onEach : null,
  onAtomsBegin : function(){},
  onAtomsEnd : function(){},
  onMakeIdentity : function(){},
}

//

function _operationReturningSelfTakingVariantsComponentWiseAct_functor( operation )
{

  _assert( arguments.length === 1 );
  _.routineOptions( _operationReturningSelfTakingVariantsComponentWiseAct_functor,operation );
  _assert( _.objectIs( operation ) );
  _assert( _.routineIs( operation.onEach ) );
  _assert( _.routineIs( operation.onAtomsBegin ) );
  _assert( _.routineIs( operation.onAtomsEnd ) );
  _assert( _.arrayIs( operation.takingArguments ) );

  var onAtomsBegin = operation.onAtomsBegin;
  var onEach = operation.onEach;
  var onAtomsEnd = operation.onAtomsEnd;
  var onMakeIdentity = operation.onMakeIdentity;
  var takingArguments = operation.takingArguments;
  var homogenous = operation.homogenous;

  /* */

  var routine = function _operationReturningSelfTakingVariantsComponentWise( dst )
  {

    if( operation.assigning )
    _.assert( _.vectorIs( dst ) );

    var args = _.vector.variants( arguments );

    if( !operation.assigning )
    {
      dst = _.vector.fromArray( this.makeArrayOfLengthZeroed( args[ 0 ].length ) );
      args.unshift( dst );
      onMakeIdentity.call( args,dst );
    }

    var length = dst.length;
    _.assert( takingArguments[ 0 ] <= args.length && args.length <= takingArguments[ 1 ],args.length,operation.assigning );
    _.assert( _.vectorIs( dst ) );

    onAtomsBegin.apply( args,args,length );

    if( homogenous )
    {

      for( var i = 0 ; i < length ; i++ )
      {
        for( var a = 1 ; a < args.length ; a++ )
        {
          onEach.call( args,dst,args[ a ],i );
        }
      }

    }
    else
    {
      args.push( 0 );

      for( var i = 0 ; i < length ; i++ )
      {
        args[ args.length-1 ] = i;
        onEach.apply( args,args );
      }

    }

    onAtomsEnd.apply( args,args,length );

    return dst;
  }

  var op = routine.operation = Object.create( null );
  op.takingArguments = takingArguments;
  op.takingVectors = [ 1,takingArguments[ 1 ] ];
  op.takingVectorsOnly = false;
  op.returningSelf = false;
  op.returningNew = true;
  op.modifying = true;

  return routine;
}

_operationReturningSelfTakingVariantsComponentWiseAct_functor.defaults =
{
  assigning : 0,
}

_operationReturningSelfTakingVariantsComponentWiseAct_functor.defaults.__proto__ = _operationReturningSelfTakingVariantsComponentWise_functor.defaults;

//

var add = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 2,Infinity ],
  homogenous : 1,
  onEach : function add( dst,src,i )
  {
    var d = dst.eGet( i );
    var s = src.eGet( i );

    var r = d + s;

    dst.eSet( i,r );
  }
});

//

var sub = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 2,Infinity ],
  homogenous : 1,
  onEach : function sub( dst,src,i )
  {
    var d = dst.eGet( i );
    var s = src.eGet( i );

    var r = d - s;

    dst.eSet( i,r );
  }
});

//

var mul = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 2,Infinity ],
  homogenous : 1,
  onMakeIdentity : function( dst )
  {
    _.vector.assignScalar( dst,1 );
  },
  onEach : function mul( dst,src,i )
  {
    var d = dst.eGet( i );
    var s = src.eGet( i );

    var r = d * s;

    dst.eSet( i,r );
  }
});

//

var div = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 2,Infinity ],
  homogenous : 1,
  onMakeIdentity : function( dst )
  {
    debugger;
    _.vector.assignScalar( dst,1 );
  },
  onEach : function div( dst,src,i )
  {
    debugger;
    var d = dst.eGet( i );
    var s = src.eGet( i );

    var r = d / s;

    dst.eSet( i,r );
  }
});

//

var min = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 2,Infinity ],
  homogenous : 1,
  onMakeIdentity : function( dst )
  {
    debugger;
    _.vector.assignScalar( dst,+Infinity );
  },
  onEach : function min( dst,src,i )
  {
    var d = dst.eGet( i );
    var s = src.eGet( i );

    var r = _min( d,s );

    dst.eSet( i,r );
  }
});

//

var max = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 2,Infinity ],
  homogenous : 1,
  onMakeIdentity : function( dst )
  {
    debugger;
    _.vector.assignScalar( dst,-Infinity );
  },
  onEach : function max( dst,src,i )
  {
    var d = dst.eGet( i );
    var s = src.eGet( i );

    var r = _max( d,s );

    dst.eSet( i,r );
  }
});

//

var clamp = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 3,3 ],
  onEach : function clamp( dst,min,max,i )
  {
    var vmin = min.eGet( i );
    var vmax = max.eGet( i );
    if( dst.eGet( i ) > vmax ) dst.eSet( i,vmax );
    else if( dst.eGet( i ) < vmin ) dst.eSet( i,vmin );
  }
});

//

var randomInRange = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 3,3 ],
  onEach : function randomInRange( dst,min,max,i )
  {
    var vmin = min.eGet( i );
    var vmax = max.eGet( i );
    dst.eSet( i,vmin + Math.random()*( vmax-vmin ) );
  }
});

//

var mix = _operationReturningSelfTakingVariantsComponentWise_functor
({
  takingArguments : [ 3,3 ],
  onEach : function mix( dst,src,progress,i )
  {
    debugger;
    throw _.err( 'not tested' );
    var v1 = dst.eGet( i );
    var v2 = src.eGet( i );
    var p = progress.eGet( i );
    dst.eSet( i,v1*( 1-p ) + v2*( p ) );
  }
});

  // add : add,
  // sub : sub,
  // mul : mul,
  // div : div,
  // min : min,
  // max : max,

// --
// atom-wise,
// vectors only -> self
// --

function _handleAtom_functor( o )
{

  var onAtom = o.onAtom;
  var handleAtom = null;

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.input ) );
  _.assert( _.routineIs( onAtom ) || _.arrayIs( onAtom ) );

  if( _.arrayIdentical( o.input , [ 'vw','vr+' ] ) || _.arrayIdentical( o.input , [ 'vw','vr*' ] ) )
  {

    handleAtom = function handleAtom( o )
    {

      for( var a = 0 ; a < o.srcContainers.length ; a++ )
      {
        var src = o.srcContainers[ a ];
        o.srcContainer = src;
        o.srcContainerIndex = a;
        o.srcElement = src.eGet( o.key );

        var r = onAtom.call( this,o );
        _.assert( r === undefined );
      }

      o.dstContainer.eSet( o.key,o.dstElement );

    }

    handleAtom.defaults =
    {
      key : -1,
      args : null,
      dstElement : null,
      dstContainer : null,
      srcElement : null,
      srcContainer : null,
      srcContainerIndex : -1,
      srcContainers : null,
    }

    handleAtom.own = { onAtom : onAtom };

  }
  else if( _.arrayIdentical( o.input , [ 'vw','s' ] ) || _.arrayIdentical( o.input , [ 'vw|s','s' ] ) )
  {

    var allowingDstScalar = _.strHasAny( o.inputWithoutLast[ 0 ] , [ '|s','s|' ] );

    var handleAtom;
    if( allowingDstScalar )
    handleAtom = function handleAtom( o )
    {
      var r = onAtom.call( this,o );
      _.assert( r === undefined );
      _.assert( _.numberIs( o.dstElement ) );
      if( !_.numberIs( o.dstContainer ) )
      o.dstContainer.eSet( o.key,o.dstElement );
    }
    else
    handleAtom = function handleAtom( o )
    {
      var r = onAtom.call( this,o );
      _.assert( r === undefined );
      _.assert( _.numberIs( o.dstElement ) );
      o.dstContainer.eSet( o.key,o.dstElement );
    }

    handleAtom.defaults =
    {
      key : -1,
      args : null,
      dstElement : null,
      dstContainer : null,
      srcElement : null,
    }

    handleAtom.own = { onAtom : onAtom };

  }
  else if
  (
    ( _.arrayIdentical( o.inputWithoutLast , [ 'vw' ] ) || _.arrayIdentical( o.inputWithoutLast , [ 'vw|s' ] ) )
    && _.strBegins( o.inputLast,'vr|s*' )
    && o.commutative === false
  )
  {

    handleAtom = function handleAtom( o )
    {

      for( var a = 0 ; a < o.srcContainers.length ; a++ )
      {
        var src = o.srcContainers[ a ];
        o.srcElements[ a ] = src.eGet( o.key );
      }

      var r = onAtom.call( this,o );
      _.assert( r === undefined );
      o.dstContainer.eSet( o.key,o.dstElement );

    }

    handleAtom.defaults =
    {
      key : -1,
      args : null,
      dstElement : null,
      dstContainer : null,
      srcElements : null,
      srcContainers : null,
    }

    handleAtom.own = { onAtom : onAtom };

  }
  else if( _.arrayIdentical( o.input , [ 'vw|s|n','vr|s','vr*|s*' ] ) && o.commutative === true )
  {

    handleAtom = function handleAtom( o )
    {

      // o.dstElement = o.srcContainers[ 0 ].eGet( o.key );
      for( var a = 0 ; a < o.srcContainers.length ; a++ )
      {
        var src = o.srcContainers[ a ];
        o.srcElement = src.eGet( o.key );
        var r = onAtom.call( this,o );
        _.assert( r === undefined );
      }

      // debugger;
      // var r = onAtom.call( this,o );
      // _.assert( r === undefined );
      o.dstContainer.eSet( o.key , o.dstElement );

    }

    handleAtom.defaults =
    {
      key : -1,
      args : null,
      dstElement : null,
      dstContainer : null,
      srcElement : null,
      srcContainers : null,
    }

    handleAtom.own = { onAtom : onAtom };

  }
  else _.assert( 0,'unknown kind of input',o.input );

  if( _.routineIs( o.onAtom ) )
  o.onAtom = [ o.onAtom ];
  o.onAtom.unshift( handleAtom );

  return handleAtom;
}

//

function _onVectors_functor( o )
{

  var takingArguments = o.takingArguments;
  var onVectors = null;
  var onAtom = o.onAtom[ 0 ];

  // if( _.strHas( o.name , 'mul' ) )
  // debugger;

  _.assert( arguments.length === 1 );
  _.assert( takingArguments.length === 2 );
  _.assert( o.handleAtom === undefined );
  _.assert( _.arrayIs( o.onAtom ) );
  _.assert( _.routineIs( onAtom ) );

  /* */

  if( _.arrayIdentical( o.input , [ 'vw','vr+' ] ) || _.arrayIdentical( o.input , [ 'vw','vr*' ] ) )
  {

    onVectors = function onVectors()
    {

      var dst = arguments[ 0 ];
      var o = Object.create( null );
      o.key = -1;
      o.args = arguments;
      o.dstElement = null;
      o.dstContainer = dst;
      o.srcElement = null;
      o.srcContainer = dst;
      o.srcContainerIndex = -1;
      o.srcContainers = _.arraySlice( arguments,1,arguments.length );
      Object.preventExtensions( o );

      /* */

      if( Config.debug )
      {
        _.assert( _.vectorIs( dst ) );
        _.assert( arguments.length >= 1,'expects at least one argument' );
        _.assert( takingArguments[ 0 ] <= arguments.length && arguments.length <= takingArguments[ 1 ],'expects ', takingArguments, ' arguments' );
        for( var a = 0 ; a < o.srcContainers.length ; a++ )
        {
          var src = o.srcContainers[ a ];
          _.assert( _.vectorIs( src ) );
          _.assert( dst.length === src.length,'src and dst should have same length' );
        }
      }

      /* */

      for( var k = 0 ; k < dst.length ; k++ )
      {
        o.key = k;
        o.dstElement = dst.eGet( k );
        onAtom.call( this,o );
      }

      return dst;
    }

    onVectors.own = { onAtom : onAtom };
    onVectors.operation = o;
    o.takingArguments = takingArguments;
    o.takingVectors = takingArguments;
    o.takingVectorsOnly = true;
    o.commutative = true;
    o.atomWise = true;
    o.returningSelf = true;
    o.returningNew = false;
    o.returningArray = false;
    o.modifying = true;
    o.operation = o;

    _.assert( takingArguments[ 0 ] > 0 && takingArguments[ 1 ] === Infinity );

  }
  else if( _.arrayIdentical( o.input , [ 'vw','s' ] ) || _.arrayIdentical( o.input , [ 'vw|s','s' ] ) )
  {

    var allowingDstScalar = _.strHasAny( o.inputWithoutLast[ 0 ] , [ '|s','s|' ] );

    onVectors = function onVectors( dst,src )
    {

      if( Config.debug )
      {
        _.assert( arguments.length === 2,'expects 2 arguments' );
        if( allowingDstScalar )
        _.assert( _.vectorIs( dst ) || _.numberIs( dst ) );
        else
        _.assert( _.vectorIs( dst ) );
        _.assert( _.numberIs( src ) );
      }

      /* */

      var o = Object.create( null );
      o.key = -1;
      o.args = arguments;
      o.dstContainer = dst;
      o.srcElement = src;
      o.dstElement = null;
      Object.preventExtensions( o );

      if( allowingDstScalar && _.numberIs( dst ) )
      {
        o.key = 0;
        o.dstElement = dst;
        onAtom.call( this,o );
        dst = o.dstElement;
      }
      else
      for( var k = 0 ; k < dst.length ; k++ )
      {
        o.key = k;
        o.dstElement = dst.eGet( k );
        onAtom.call( this,o );
      }

      return dst;
    }

    onVectors.own = { onAtom : onAtom };
    onVectors.operation = o;
    o.takingArguments = [ 2,2 ];
    if( !o.takingVectors )
    o.takingVectors = [ 1,1 ];
    else
    o.takingVectors[ 1 ] = 1;
    o.takingVectorsOnly = false;
    o.commutative = true;
    o.atomWise = true;
    o.returningSelf = true;
    o.returningNew = false;
    o.returningArray = false;
    o.returningNumber = true;
    o.modifying = true;
    o.operation = o;

    _.assert( takingArguments[ 0 ] === 2 && takingArguments[ 1 ] === 2 );

  }
  else if
  (
    ( _.arrayIdentical( o.inputWithoutLast , [ 'vw' ] ) || _.arrayIdentical( o.inputWithoutLast , [ 'vw|s' ] ) )
    && _.strBegins( o.inputLast,'vr|s*' )
    && o.commutative === false
  )
  {

    var allowingDstScalar = _.strHasAny( o.inputWithoutLast[ 0 ] , [ '|s','s|' ] );

    onVectors = function onVectors()
    {

      var unwrap = 0;
      var args = _.arraySlice( arguments,1,arguments.length );
      var dst = arguments[ 0 ];
      var o = Object.create( null );
      o.key = -1;
      o.args = args;
      o.dstElement = null
      o.dstContainer = dst;
      o.srcElements = [];
      o.srcContainers = args;
      Object.preventExtensions( o );

      /* */

      if( allowingDstScalar && _.numberIs( dst ) )
      {

        for( var a = 0 ; a < args.length ; a++ )
        {
          var src = args[ a ];
          if( _.vectorIs( src ) )
          {
            dst = o.dstContainer = vector.makeArrayOfLengthWithValue( src.length , dst );
            break;
          }
        }

        if( !_.vectorIs( dst ) )
        {
          dst = o.dstContainer = vector.makeArrayOfLengthWithValue( 1 , dst );
          unwrap = 1;
        }
      }

      /* */

      if( _.vectorIs( dst ) )
      for( var a = 0 ; a < args.length ; a++ )
      {
        var src = args[ a ];
        src = args[ a ] = vector.fromMaybeNumber( src,dst.length );
      }

      /* */

      if( Config.debug )
      {
        _.assert( _.vectorIs( dst ) || ( _.numberIs( dst ) && allowingDstScalar ) );
        _.assert( takingArguments[ 0 ] <= arguments.length && arguments.length <= takingArguments[ 1 ],'expects ', takingArguments, ' arguments' );
        for( var a = 0 ; a < args.length ; a++ )
        {
          var src = args[ a ];
          _.assert( _.vectorIs( src ) || _.numberIs( src ) );
          _.assert( _.numberIs( src ) || dst.length === src.length,'src and dst should have same length' );
        }
      }

      // if( !_.vectorIs( dst ) )
      // debugger;

      /* */

      // if( allowingDstScalar && _.numberIs( dst ) )
      // {
      //   o.key = 0;
      //   o.dstElement = dst;
      //   onAtom.call( this,o );
      //   dst = o.dstElement;
      // }
      // else

      for( var k = 0 ; k < dst.length ; k++ )
      {
        o.key = k;
        o.dstElement = dst.eGet( k );
        onAtom.call( this,o );
      }

      if( unwrap )
      debugger;
      if( unwrap )
      return dst.eGet( 0 );

      return dst;
    }

    onVectors.own = { onAtom : onAtom };
    onVectors.operation = o;
    o.takingArguments = takingArguments;
    if( _.nothing( o.takingVectors ) )
    o.takingVectors = [ 1,takingArguments[ 1 ] ];

    var def =
    {
      takingVectorsOnly : false,
      commutative : false,
      atomWise : true,
      returningSelf : true,
      returningNew : false,
      returningArray : false,
      modifying : true,
    }

    _.mapSupplementNulls( o,def );
    _.assert( takingArguments[ 0 ] >= 2 && takingArguments[ 1 ] >= 2 );

  }
  else if( _.arrayIdentical( o.input , [ 'vw|s|n','vr|s','vr*|s*' ] ) && o.commutative === true )
  {

    onVectors = function onVectors()
    {

      var hasDst = 1;
      var unwrap = 0;
      var args = _.arraySlice( arguments,0,arguments.length );
      var dst = arguments[ 0 ];
      var firstSrcContainer = null;
      var o = Object.create( null );
      o.key = -1;
      o.args = args;
      o.dstElement = null;
      o.dstContainer = dst;
      o.srcContainers = null;
      // o.srcContainers = args.slice( 1 );
      o.srcElement = null;
      Object.preventExtensions( o );

      /* */

      if( _.numberIs( dst ) || dst === null )
      {

        hasDst = 0;

        for( var a = 0 ; a < args.length ; a++ )
        {
          var src = args[ a ];
          if( _.vectorIs( src ) )
          {
            if( dst === null )
            dst = o.dstContainer = vector.makeArrayOfLengthWithValue( src.length , 0 );
            else
            dst = o.dstContainer = vector.makeArrayOfLengthWithValue( src.length , dst );
            break;
          }
        }

        if( !_.vectorIs( dst ) )
        {
          if( dst === null )
          dst = o.dstContainer = vector.makeArrayOfLengthWithValue( 1 , 0 );
          else
          dst = o.dstContainer = vector.makeArrayOfLengthWithValue( 1 , dst );
          unwrap = 1;
        }

        // args[ 0 ] = dst;
        // firstSrcContainer = o.args[ 1 ];
        // o.srcContainers = o.args.slice( 2 );

      }

      /* */

      if( _.vectorIs( dst ) )
      for( var a = 1 ; a < args.length ; a++ )
      {
        var src = args[ a ];
        src = args[ a ] = vector.fromMaybeNumber( src,dst.length );
      }

      if( hasDst )
      {
        o.srcContainers = o.args.slice( 1 );
        firstSrcContainer = o.args[ 0 ];
      }
      else
      {
        if( _.numberIs( args[ 0 ] ) )
        {
          firstSrcContainer = dst;
          o.srcContainers = o.args.slice( 1 );
        }
        else
        {
          firstSrcContainer = o.args[ 1 ];
          o.srcContainers = o.args.slice( 2 );
        }
        args[ 0 ] = dst;
      }

      /* */

      if( Config.debug )
      {
        _.assert( _.vectorIs( dst ) || _.numberIs( dst ) );
        _.assert( takingArguments[ 0 ] <= arguments.length && arguments.length <= takingArguments[ 1 ],'expects ', takingArguments, ' arguments' );
        for( var a = 0 ; a < args.length ; a++ )
        {
          var src = args[ a ];
          _.assert( _.vectorIs( src ) || _.numberIs( src ) );
          _.assert( _.numberIs( src ) || dst.length === src.length,'src and dst should have same length' );
        }
      }

      // if( dst.sameWith( args[ 0 ] ) )
      // debugger;
      // if( !dst.sameWith( args[ 0 ] ) )
      // dst.assign( args[ 0 ] );

      for( var k = 0 ; k < dst.length ; k++ )
      {
        o.key = k;
        o.dstElement = firstSrcContainer.eGet( k );
        onAtom.call( this,o );
      }

      if( unwrap )
      debugger;
      if( unwrap )
      return dst.eGet( 0 );

      return dst;
    }

    onVectors.own = { onAtom : onAtom };
    onVectors.operation = o;
    o.takingArguments = takingArguments;
    if( _.nothing( o.takingVectors ) )
    o.takingVectors = [ 1,takingArguments[ 1 ] ];

    var def =
    {
      takingVectorsOnly : false,
      commutative : true,
      atomWise : true,
      returningSelf : true,
      returningNew : true,
      returningArray : false,
      modifying : true,
    }

    _.mapSupplementNulls( o,def );
    _.assert( takingArguments[ 0 ] === 2 && takingArguments[ 1 ] >= 3 );

  }
  else _.assert( 0,'unknown kind of input',o.input );

  /* */

  _.assert( o.onVectors === undefined );
  o.onVectors = [];
  o.onVectors.unshift( onVectors );

  return onVectors;
}

//

/*
  addScalar
  input : [ 'vw','s' ],

  addVectorScaled
  input : [ 'vw','vr|s*2' ],

  addVectors
  input : [ 'vw','vr+' ],

  clamp
  input : [ 'vw','vr|s*3' ],

  mix
  input : [ 'vw','vr|s*3' ],
*/

function _operationOnVector_functor( o )
{

  if( _.routineIs( o ) )
  o = _.mapExtend( null,{ onAtom : o } );
  else
  o = _.mapExtend( null,o );

  var onAtom = o.onAtom;
  if( o.takingArguments === undefined )
  o.takingArguments = onAtom.takingArguments;

  /* */

  if( o.name === 'isFinite' )
  debugger;

  _.assertMapHasOnly( o,_operationOnVector_functor.defaults );
  _.assert( o.atomOperation );
  _.assert( _.routineIs( onAtom ) );
  _.assert( _.arrayIs( o.takingArguments ) );
  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.input ) || _.arrayIs( o.input ) );
  _.assert( _.boolIs( o.commutative ) || _.boolIs( o.commutative ) );

  _.assert( o.handleAtom === undefined );
  _.assert( o.handleVector === undefined );
  _.assert( o.handleVectors === undefined );
  _.assert( o.handleBegin === undefined );
  _.assert( o.handleEnd === undefined );

  /* */

  if( o.commutative === null )
  o.commutative = onAtom.commutative;

  if( o.input === null )
  o.input = onAtom.input;
  o.inputWithoutLast = o.input.slice( 0,o.input.length-1 );
  o.inputLast = o.input[ o.input.length-1 ];

  /* */

  _handleAtom_functor( o );
  _onVectors_functor( o );

  /* */

  _.assert( _.arrayIs( o.takingArguments ) );
  _.assert( _.routineIs( o.onVectors[ 0 ] ) );

  _.assert( o.handleAtom === undefined );
  _.assert( o.handleVector === undefined );
  _.assert( o.handleVectors === undefined );
  _.assert( o.handleBegin === undefined );
  _.assert( o.handleEnd === undefined );

  return o.onVectors[ 0 ];
}

_operationOnVector_functor.defaults =
{
}

_operationOnVector_functor.defaults.__proto__ = OperationDescriptor;

// --
//
// --

function declareAomWiseParallelVectorsRoutines()
{

  // debugger;
  for( var op in operations.atomWiseCommutative )
  {

    var atomOperation = operations.atomWiseCommutative[ op ];
    var routineName = op + ( atomOperation.postfix !== undefined && atomOperation.postfix !== null ? atomOperation.postfix : 'Vectors' );
    var operation = _.mapExtend( null,atomOperation );

    _.assert( operation.atomOperation === undefined );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( _.routineIs( atomOperation.onAtom ) );
    _.assert( !Routines[ routineName ] );

    operation.atomOperation = atomOperation;

    if( !operation.takingArguments )
    operation.takingArguments = [ 2,Infinity ];
    else
    operation.takingArguments[ 1 ] = Infinity;

    if( operation.takingArguments[ 0 ] === 1 )
    operation.input = [ 'vw','vr*' ];
    else if( operation.takingArguments[ 0 ] > 1 )
    operation.input = [ 'vw','vr+' ];
    else _.assert( 0,'unexpected' );

    operation.name = routineName;

    Routines[ routineName ] = _operationOnVector_functor( operation );

  }

  _.assert( Routines.addVectors );

}

//

function declareAomWiseParallelScalarRoutines()
{

  for( var op in operations.atomWiseCommutative )
  {
    var routineName = op + 'Scalar';
    var atomOperation = operations.atomWiseCommutative[ op ];
    var operation = _.mapExtend( null,atomOperation );

    _.assert( operation.atomOperation === undefined );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( _.routineIs( atomOperation.onAtom ) );
    _.assert( !Routines[ routineName ] );

    operation.atomOperation = atomOperation;
    operation.input = [ 'vw|s','s' ];
    operation.takingArguments = [ 2,2 ];
    operation.name = routineName;

    Routines[ routineName ] = _operationOnVector_functor( operation );

  }

  _.assert( Routines.addScalar );
}

//

function declareAomWiseParalleRoutines()
{

  _.assert( !Routines.add );
  _.assert( !Routines.assign );
  _.assert( !Routines.min );
  _.assert( !Routines.max );

  // debugger;
  for( var op in operations.atomWiseCommutative )
  {
    var atomOperation = operations.atomWiseCommutative[ op ];

    if( op === 'assign' )
    continue;

    if( atomOperation.postfix )
    debugger;

    // var routineName = op + ( atomOperation.postfix !== undefined && atomOperation.postfix !== null ? atomOperation.postfix : 'Vectors' );
    var routineName = op;
    // debugger;
    var operation = _.mapExtend( null,atomOperation );

    _.assert( operation.atomOperation === undefined );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( _.routineIs( atomOperation.onAtom ) );
    _.assert( !Routines[ routineName ] );

    operation.atomOperation = atomOperation;
    operation.returningNumber = 1;

    // if( !operation.takingArguments )
    operation.takingArguments = [ 2,Infinity ];
    operation.takingVectors = [ 0,Infinity ];
    // else
    // operation.takingArguments[ 1 ] = Infinity;

    // if( operation.takingArguments[ 0 ] === 1 )
    operation.input = [ 'vw|s|n','vr|s','vr*|s*' ];
    // else if( operation.takingArguments[ 0 ] > 1 )
    // operation.input = [ 'vw','vr+' ];
    // else _.assert( 0,'unexpected' );

    operation.name = routineName;

    Routines[ routineName ] = _operationOnVector_functor( operation );

  }

  _.assert( Routines.add );
  _.assert( _.arrayIdentical( Routines.add.operation.takingVectors,[ 0,Infinity ] ) );
  _.assert( Routines.min );
  _.assert( Routines.max );

}

//

function declareAomWiseNotParallelRoutines()
{

  for( var op in operations.atomWiseNotCommutative )
  {
    var routineName = op;
    var atomOperation = operations.atomWiseNotCommutative[ op ];
    var operation = _.mapExtend( null,atomOperation );

    _.assert( operation.atomOperation === undefined );
    _.assert( operation.input );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( _.routineIs( atomOperation.onAtom ) );
    _.assert( !Routines[ routineName ] );
    _.assert( operation.commutative === false );

    operation.atomOperation = atomOperation;
    operation.name = routineName;

    // if( op === 'mix' )
    // debugger;

    Routines[ routineName ] = _operationOnVector_functor( operation );

  }

  _.assert( Routines.addScaled );

}

// --
// reduce to element
// --

function _normalizeOperationArity( operation )
{

  if( operation.takingArguments === undefined || operation.takingArguments === null )
  operation.takingArguments = operation.takingVectors;

  if( operation.takingVectors === undefined || operation.takingVectors === null )
  operation.takingVectors = operation.takingArguments;

  if( operation.takingArguments === undefined || operation.takingArguments === null )
  operation.takingArguments = [ 1,Infinity ];

  if( operation.takingVectors === undefined || operation.takingVectors === null )
  operation.takingVectors = [ 1,Infinity ];

  operation.takingArguments = _.numbersFromNumber( operation.takingArguments,2 ).slice();
  operation.takingVectors = _.numbersFromNumber( operation.takingVectors,2 ).slice();

  if( operation.takingArguments[ 0 ] < operation.takingVectors[ 0 ] )
  operation.takingArguments[ 0 ] = operation.takingVectors[ 0 ];

  return operation;
}

//

function _normalizeOperationFunctions( operationMake,operation )
{

  var atomDefaults = operationMake.atomDefaults;

  _.assert( arguments.length === 2 );
  _.assert( _.objectIs( atomDefaults ) );

  function normalize( name )
  {
    if( _.routineIs( operation[ name ] ) )
    operation[ name ] = [ operation[ name ] ];
    else if( operation[ name ] === undefined || operation[ name ] === null )
    operation[ name ] = [];
    else if( !_.arrayIs( operation[ name ] ) )
    _.assert( 0,'unexpected type of operation function',name,_.strTypeOf( operation[ name ] ) );

    if( operation[ name ][ 0 ] )
    if( operation[ name ][ 0 ].defaults === atomDefaults )
    operation[ name ].splice( 0,1 );
  }

  normalize( 'onAtom' );
  normalize( 'onAtomsBegin' );
  normalize( 'onAtomsEnd' );
  normalize( 'onVectors' );

  return operation;
}

//

function __operationReduceToScalar_functor( operation )
{
  var atomDefaults = __operationReduceToScalar_functor.atomDefaults;

  _normalizeOperationArity( operation );
  _.routineOptions( __operationReduceToScalar_functor,operation );
  _normalizeOperationFunctions( __operationReduceToScalar_functor,operation );

  // debugger;
  // if( operation.name === 'isFinite' )
  // debugger;

  if( !operation.onAtomsBegin.length )
  operation.onAtomsBegin.push( function onAtomsBegin( o )
  {
    debugger;
    o.result = 0;
  });

  if( !operation.onAtomsEnd.length )
  operation.onAtomsEnd.push( function onAtomsEnd( o )
  {
  });

  var onAtom = operation.onAtom[ 0 ];
  var onAtomsBegin = operation.onAtomsBegin[ 0 ];
  var onAtomsEnd = operation.onAtomsEnd[ 0 ];

  var filtering = operation.filtering;
  var takingArguments = operation.takingArguments;
  var takingVectors = operation.takingVectors;

  if( operation.filtering )
  takingArguments[ 1 ] += 1;

  _.assert( takingVectors.length === 2 );
  _.assert( takingArguments.length === 2 );

  _.assert( _.objectIs( operation ) );
  _.assert( operation.onVectors.length === 0 );
  _.assert( _.routineIs( onAtom ) );
  _.assert( _.routineIs( onAtomsBegin ) );
  _.assert( _.routineIs( onAtomsEnd ) );
  _.assert( onAtom.length === 1 );
  _.assert( onAtomsBegin.length === 1 );
  _.assert( onAtomsEnd.length === 1 );
  // _.assert( _.boolLike( operation.interruptible ) );

  /* */

  function handleBegin( o )
  {

    _.assert( arguments.length === 1 )

    var op = Object.create( null );
    _.mapExtend( op , atomDefaults );
    Object.preventExtensions( op );

    _.mapExtend( op,o );
    // op.numberOfArguments = numberOfArguments;
    _.assert( op.args );

    /* */

    if( Config.debug && takingArguments )
    {
      _assert( takingArguments[ 0 ] <= o.args.length && o.args.length <= takingArguments[ 1 ] );
    }

    op.filter = null;
    op.numberOfArguments = o.args.length;
    if( filtering )
    {
      op.numberOfArguments -= 1;
      op.filter = o.args[ op.numberOfArguments ];
      _.routineIs( op.filter );
      _.assert( op.filter.length === 2 );
    }

    op.numberOfArguments = _.clamp( op.numberOfArguments,takingVectors );

    /* */

    // var op = Object.create( null );
    // _.mapExtend( op , atomDefaults );
    // Object.preventExtensions( op );
    //
    // _.mapExtend( op,o );
    // op.numberOfArguments = numberOfArguments;
    // _.assert( op.args );

    var r = onAtomsBegin.call( this,op );
    _.assert( r === undefined );
    _.assert( op.result !== undefined );

    return op;
  }

  handleBegin.defaults = atomDefaults;
  handleBegin.own = { onAtomsBegin : onAtomsBegin };

  /* */

  function handleEnd( op )
  {
    var r = onAtomsEnd.call( this,op );
    _.assert( r === undefined );
    _.assert( op.result !== undefined );
  }

  handleBegin.defaults = atomDefaults;
  handleEnd.own = { onAtomsEnd : onAtomsEnd };

  /* */

  var handleAtom = null;

  if( operation.interruptible )
  handleAtom = function handleAtom( o )
  {

    if( o.filter )
    if( !o.filter.call( this,o.element,o ) )
    return;

    var r = onAtom.call( this,o );

    _.assert( r === undefined || r === false );
    _.assert( o.result !== undefined );

    return r;
  }
  else
  handleAtom = function handleAtom( o )
  {

    if( o.filter )
    if( !o.filter.call( this,o.element,o ) )
    return;

    var r = onAtom.call( this,o );

    _.assert( r === undefined );
    _.assert( o.result !== undefined );

  }

  handleAtom.defaults = atomDefaults;
  handleAtom.own = { onAtom : onAtom };

  /* */

  var routine = null;

  if( operation.interruptible )
  routine = function operationReduce()
  {

    var op = handleBegin({ args : arguments });

    for( var a = 0 ; a < op.numberOfArguments ; a++ )
    {

      op.container = arguments[ a ]
      _.assert( _.vectorIs( op.container ),'expects vector' );

      var length = op.container.length;
      for( var key = 0 ; key < length ; key++ )
      {
        op.key = key;
        op.element = op.container.eGet( key );
        // debugger;
        var continuing = handleAtom.call( this,op );
        if( continuing === false )
        break;
      }

      if( continuing === false )
      break;
    }

    handleEnd( op );

    return op.result;
  }
  else
  routine = function operationReduce()
  {

    var op = handleBegin({ args : arguments });

    for( var a = 0 ; a < op.numberOfArguments ; a++ )
    {

      op.container = arguments[ a ]
      _.assert( _.vectorIs( op.container ),'expects vector' );

      var length = op.container.length;
      for( var key = 0 ; key < length ; key++ )
      {
        op.key = key;
        op.element = op.container.eGet( key );
        handleAtom.call( this,op );
      }

    }

    handleEnd( op );

    return op.result;
  }

  /* */

  operation.onAtomsBegin.unshift( handleBegin );
  operation.onAtomsEnd.unshift( handleEnd );
  operation.onAtom.unshift( handleAtom );
  operation.onVectors.unshift( routine );
  operation.onOperationMake = __operationReduceToScalar_functor;

  var operationDefaults =
  {
    takingArguments : [ 0,Infinity ],
    takingVectors : null,
    takingVectorsOnly : !filtering,
    returningSelf : false,
    returningNew : false,
    returningArray : false,
    returningNumber : ( operation.returningNumber !== undefined && operation.returningNumber !== null ? !!operation.returningNumber : true ),
    modifying : false,
    reducing : true,
  }

  _.mapSupplementNulls( operation,operationDefaults );
  routine.operation = operation;
  routine.own =
  {
    onAtom : handleAtom,
    onAtomsBegin : handleBegin,
    onAtomsEnd : handleEnd,
  };

  return routine;
}

__operationReduceToScalar_functor.defaults =
{
  onAtom : null,
  onAtomsBegin : null,
  onAtomsEnd : null,
  filtering : null,
  takingArguments : [ 0,Infinity ],
  takingVectors : [ 0,Infinity ],
}

__operationReduceToScalar_functor.defaults.__proto__ = OperationDescriptor;

__operationReduceToScalar_functor.atomDefaults =
{
  container : null,
  key : -1,
  element : null,
  result : null,
  args : null,
  filter : null,
  numberOfArguments : null,
}

//

function _operationReduceToScalar_functor( o )
{
  var result = Object.create( null );
  var filtering = o.filtering;

  _assert( _.objectIs( o ) );
  _assertMapHasOnly( o,_operationReduceToScalar_functor.defaults );

  var operation = _.mapExtend( null,o );
  operation.filtering = false;
  result.trivial = __operationReduceToScalar_functor( operation );

  var operation = _.mapExtend( null,o );
  operation.filtering = true;
  result.filtering = __operationReduceToScalar_functor( operation );

  return result;
}

_operationReduceToScalar_functor.defaults =
{
}

_operationReduceToScalar_functor.defaults.__proto__ = __operationReduceToScalar_functor.defaults;

//

function declareReducingRoutines()
{

  // debugger;

  for( var op in operations.atomWiseReducing )
  {

    var routineName = op;
    var atomOperation = operations.atomWiseReducing[ op ];
    var operation = _.mapExtend( null,atomOperation );

    _.assert( operation.atomOperation === undefined );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( _.routineIs( atomOperation.onAtom ) );
    _.assert( !Routines[ routineName ] );

    operation.commutative = true;
    operation.atomOperation = atomOperation;
    operation.name = routineName;

    var r = _operationReduceToScalar_functor( operation );
    Routines[ routineName ] = r.trivial;
    Routines[ routineName + 'Filtering' ] = r.filtering;

  }

  // debugger;
  _.assert( _.routineIs( Routines.reduceToMean ) );
  _.assert( _.routineIs( Routines.reduceToMeanFiltering ) );
  _.assert( _.routineIs( Routines.isFinite ) );
  _.assert( _.routineIs( Routines.isFiniteFiltering ) );

}

// --
// reduce to greatest
// --

function _operationReduceToExtremal_functor( operation )
{

  _assertMapHasOnly( operation,_operationReduceToExtremal_functor.defaults );
  _assert( _.objectIs( operation ) );
  _assert( _.routineIs( operation.onDistance ) );
  _assert( _.routineIs( operation.onIsGreater ) );
  _assert( _.numberIs( operation.distanceOnBegin ) );

  _assert( operation.onDistance.length === 1 );
  _assert( operation.onIsGreater.length === 2 );

  var onDistance = operation.onDistance;
  var onIsGreater = operation.onIsGreater;
  var distanceOnBegin = operation.distanceOnBegin;
  var valueName = _.nameUnfielded( operation.valueName ).coded;

  var _gened = _operationReduceToScalar_functor
  ({
    onAtom : function( o )
    {

      _.assert( o.container.length,'not tested' );

      var distance = onDistance( o );
      if( onIsGreater( distance,o.result.value ) )
      {
        o.result.container = o.container;
        o.result[ valueName ] = distance;
        o.result.index = o.key;
      }

    },
    onAtomsBegin : function( o )
    {
      o.result = Object.create( null );
      o.result.container = null;
      o.result.index = -1;
      o.result[ valueName ] = distanceOnBegin;
    },
    takingVectors : operation.takingVectors,
    returningNumber : false,
  });

  return _gened;
}

_operationReduceToExtremal_functor.defaults =
{
  onDistance : null,
  onIsGreater : null,
  takingArguments : null,
  takingVectors : null,
  distanceOnBegin : null,
  valueName : null,
}

//

var reduceToClosest = _operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    debugger;
    _.assert( o.container.length,'not tested' );
    _.assert( 0,'not tested' );
    return Math.abs( o.result.instance - o.element );
  },
  onIsGreater : function( a,b )
  {
    return a < b;
  },
  takingArguments : 2,
  takingVectors : 1,
  distanceOnBegin : +Infinity,
  valueName : { distance : 'distance' },
});

//

var reduceToFurthest = _operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    debugger;
    _.assert( o.container.length,'not tested' );
    _.assert( 0,'not tested' );
    return Math.abs( o.result.instance - o.element );
  },
  onIsGreater : function( a,b )
  {
    return a > b;
  },
  takingArguments : 2,
  takingVectors : 1,
  distanceOnBegin : -Infinity,
  valueName : { distance : 'distance' },
});

//

var reduceToMin = _operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    debugger;
    _.assert( o.container.length,'not tested' );
    _.assert( 0,'not tested' );
    return o.element;
  },
  onIsGreater : function( a,b )
  {
    return a < b;
  },
  distanceOnBegin : +Infinity,
  valueName : { value : 'value' },
});

//

var reduceToMinAbs = _operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    _.assert( o.container.length,'not tested' );
    return abs( o.element );
  },
  onIsGreater : function( a,b )
  {
    return a < b;
  },
  distanceOnBegin : -Infinity,
  valueName : { value : 'value' },
});

//

var reduceToMax = _operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    _.assert( o.container.length,'not tested' );
    return o.element;
  },
  onIsGreater : function( a,b )
  {
    return a > b;
  },
  distanceOnBegin : -Infinity,
  valueName : { value : 'value' },
});

//

var reduceToMaxAbs = _operationReduceToExtremal_functor
({
  onDistance : function( o )
  {
    _.assert( o.container.length,'not tested' );
    return abs( o.element );
  },
  onIsGreater : function( a,b )
  {
    return a > b;
  },
  distanceOnBegin : -Infinity,
  valueName : { value : 'value' },
});

//

function _distributionRangeSummaryBegin( o )
{

  o.result = { min : Object.create( null ), max : Object.create( null ), };

  o.result.min.value = +Infinity;
  o.result.min.index = -1;
  o.result.min.container = null;
  o.result.max.value = -Infinity;
  o.result.max.index = -1;
  o.result.max.container = null;

}

function _distributionRangeSummaryEach( o )
{

  _.assert( o.container.length,'not tested' );

  if( o.element > o.result.max.value )
  {
    o.result.max.value = o.element;
    o.result.max.index = o.key;
    o.result.max.container = o.container;
  }

  if( o.element < o.result.min.value )
  {
    o.result.min.value = o.element;
    o.result.min.index = o.key;
    o.result.min.container = o.container;
  }

}

function _distributionRangeSummaryEnd( o )
{
  if( o.result.min.index === -1 )
  {
    o.result.min.value = NaN;
    o.result.max.value = NaN;
  }
  o.result.median = ( o.result.min.value + o.result.max.value ) / 2;
}

var distributionRangeSummary = _operationReduceToScalar_functor
({
  onAtom : _distributionRangeSummaryEach,
  onAtomsBegin : _distributionRangeSummaryBegin,
  onAtomsEnd : _distributionRangeSummaryEnd,
  returningNumber : false,
});

//

function reduceToMinValue()
{
  var result = Self.reduceToMin.apply( Self,arguments );
  return result.value;
}

var op = reduceToMinValue.operation = Object.create( null );
op.takingArguments = [ 1,Infinity ];
op.takingVectors = [ 1,Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.returningNumber = true;
op.modifying = false;

//

function reduceToMaxValue()
{
  var result = Self.reduceToMax.apply( Self,arguments );
  return result.value;
}

var op = reduceToMaxValue.operation = Object.create( null );
op.takingArguments = [ 1,Infinity ];
op.takingVectors = [ 1,Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.returningNumber = true;
op.modifying = false;

//

function distributionRangeSummaryValue()
{
  var result = Self.distributionRangeSummary.apply( Self,arguments );
  return [ result.min.value,result.max.value ];
}

var op = distributionRangeSummaryValue.operation = Object.create( null );
op.takingArguments = [ 1,Infinity ];
op.takingVectors = [ 1,Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.returningNumber = false;
op.modifying = false;

// --
// zip reductor
// --

function dot( dst,src )
{
  var result = 0;
  var length = dst.length;

  _assert( _.vectorIs( dst ) );
  _assert( _.vectorIs( src ) );
  _assert( dst.length === src.length,'src and dst should have same length' );
  _assert( arguments.length === 2 );

  for( var s = 0 ; s < length ; s++ )
  {
    result += dst.eGet( s ) * src.eGet( s );
  }

  return result;
}

var op = dot.operation = Object.create( null );
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function distance( src1,src2 )
{
  var result = this.distanceSqr( src1,src2 );
  result = sqrt( result );
  return result;
}

var op = distance.operation = Object.create( null );
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function distanceSqr( src1,src2 )
{
  var result = 0;
  var length = src1.length;

  _assert( src1.length === src2.length,'vector.distanceSqr :','src1 and src2 should have same length' );

  for( var s = 0 ; s < length ; s++ )
  {
    result += _sqr( src1.eGet( s ) - src2.eGet( s ) );
  }

  return result;
}

var op = distanceSqr.operation = Object.create( null );
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

// --
// interruptible reductor with bool result
// --

function _equalAre( src1,src2,iterator )
{
  var length = src2.length;

  _assert( arguments.length === 3 );

  if( !( src1.length >= 0 ) )
  return false;

  if( !( src2.length >= 0 ) )
  return false;

  if( !_.vectorIs( src1 ) )
  return false;
  if( !_.vectorIs( src2 ) )
  return false;

  if( iterator.strict )
  if( src1._vectorBuffer.constructor !== src2._vectorBuffer.constructor )
  return false;

  if( !iterator.contain )
  if( src1.length !== length )
  return false;

  if( !length )
  return true;

  for( var i = 0 ; i < length ; i++ )
  {
    if( !iterator.onSameNumbers( src1.eGet( i ),src2.eGet( i ) ) )
    return false;
  }

  return true;
}

var op = _equalAre.operation = Object.create( null );
op.takingArguments = 3;
op.takingVectors = 2;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;
op.reducing = true;
op.commutative = true;

//

function equalAre( src1,src2,iterator )
{
  var iterator = _._entityEqualIteratorMake( iterator );
  _assert( arguments.length === 2 || arguments.length === 3 );
  return this._equalAre( src1,src2,iterator )
}

var op = equalAre.operation = Object.create( null );
op.takingArguments = [ 2,3 ];
op.takingVectors = 2;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;
op.reducing = true;
op.commutative = true;

//

function identicalAre( src1,src2,iterator )
{
  iterator = iterator || Object.create( null );
  iterator.strict = 1;
  iterator = _._entityEqualIteratorMake( iterator );
  _assert( arguments.length === 2 || arguments.length === 3 );
  return this._equalAre( src1,src2,iterator )
}

var op = identicalAre.operation = Object.create( null );
op.takingArguments = [ 2,3 ];
op.takingVectors = 2;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;
op.reducing = true;
op.commutative = true;

//

function equivalentAre( src1,src2,iterator )
{
  iterator = iterator || Object.create( null );
  iterator.strict = 0;
  iterator = _._entityEqualIteratorMake( iterator );
  _assert( arguments.length === 2 || arguments.length === 3 );
  return this._equalAre( src1,src2,iterator );
}

var op = equivalentAre.operation = Object.create( null );
op.takingArguments = [ 2,3 ];
op.takingVectors = 2;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;
op.reducing = true;
op.commutative = true;

//

function areParallel( src1,src2,eps )
{
  var length = src1.length;
  var eps = ( eps !== undefined ) ? eps : EPS;

  _.assert( src1.length === src2.length,'vector.distanceSqr :','src1 and src2 should have same length' );

  if( !length ) return true;

  var ratio = 0;
  var s = 0;
  while( s < length )
  {

    var isZero1 = src1.eGet( s ) === 0;
    var isZero2 = src2.eGet( s ) === 0;

    if( isZero1 ^ isZero2 )
    return false;

    if( isZero1 )
    {
      s += 1;
      continue;
    }

    var ratio = src1.eGet( s ) / src2.eGet( s );
    break;

    s += 1;

  }

  while( s < length )
  {

    var r = src1.eGet( s ) / src2.eGet( s );

    if( abs( r - ratio ) > eps )
    return false;

    s += 1;

  }

  return true;
}

var op = areParallel.operation = Object.create( null );
op.takingArguments = [ 2,3 ];
op.takingVectors = 2;
op.takingVectorsOnly = false;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;
op.reducing = true;
op.commutative = true;

// --
//
// --

// debugger;
declareAomWiseParallelVectorsRoutines();
declareAomWiseParallelScalarRoutines();
declareAomWiseParalleRoutines();
declareAomWiseNotParallelRoutines();
declareReducingRoutines();
// debugger;

// --
// helper
// --

function mag( v )
{

  _assert( arguments.length === 1 );

  return this.reduceToMag( v );
}

var op = mag.operation = _.mapExtend( null , Routines.reduceToMag.operation );
op.takingArguments = [ 1,1 ];
op.takingVectors = [ 1,1 ];

//

function magSqr( v )
{

  _assert( arguments.length === 1 );

  return this.reduceToMagSqr( v );
}

var op = magSqr.operation = _.mapExtend( null , Routines.reduceToMagSqr.operation );
op.takingArguments = [ 1,1 ];
op.takingVectors = [ 1,1 ];

//

function median( v )
{
  debugger;
  var result = this.distributionRangeSummary( v ).median;
  debugger;
  return result;
}

var op = median.operation = _.mapExtend( null , distributionRangeSummary.trivial.operation );

//

function distributionSummary( v )
{
  var result = Object.create( null );

  result.range = this.distributionRangeSummary( v );
  delete result.range.min.container;
  delete result.range.max.container;

  result.mean = this.mean( v );
  result.variance = this.variance( v,result.mean );
  result.standardDeviation = this.standardDeviation( v,result.mean );
  result.kurtosisExcess = this.kurtosisExcess( v,result.mean );
  result.skewness = this.skewness( v,result.mean );

  return result;
}

var op = distributionSummary.operation = _.mapExtend( null , Routines._momentCentral.operation );
op.takingArguments = [ 1,1 ];

//

function momentCentral( v,degree,mean )
{
  _assert( arguments.length === 2 || arguments.length === 3 );

  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  return this._momentCentral( v,degree,mean );
}

var op = momentCentral.operation = _.mapExtend( null , Routines._momentCentral.operation );
op.takingArguments = [ 2,3 ];

//

function momentCentralFiltering( v,degree,mean,filter )
{
  _assert( arguments.length === 3 || arguments.length === 4 );

  if( _.routineIs( mean ) )
  {
    _assert( filter === undefined );
    filter = mean;
    mean = null;
  }

  debugger;
  if( mean === undefined || mean === null )
  mean = _.avector.meanFiltering( v,filter );

  return this._momentCentralFiltering( v,degree,mean,filter );
}

var op = momentCentralFiltering.operation = _.mapExtend( null , Routines._momentCentralFiltering.operation );
op.takingArguments = [ 3,4 ];

//

function variance( v,mean )
{
  _assert( arguments.length === 1 || arguments.length === 2 );
  var degree = 2;
  return this.momentCentral( v,degree,mean );
}

var op = variance.operation = _.mapExtend( null , momentCentral.operation );
op.takingArguments = [ 1,2 ];

//

function varianceFiltering( v,mean,filter )
{
  _assert( arguments.length === 2 || arguments.length === 3 );

  if( _.routineIs( mean ) )
  {
    _assert( filter === undefined );
    filter = mean;
    mean = null;
  }

  var degree = 2;
  return this.momentCentralFiltering( v,degree,mean,filter );
}

var op = varianceFiltering.operation = _.mapExtend( null , momentCentralFiltering.operation );
op.takingArguments = [ 1,2 ];

//

function standardDeviation()
{
  var result = this.variance.apply( this,arguments );
  return _sqrt( result );
}

var op = standardDeviation.operation = _.mapExtend( null , variance.operation );

//

function standardDeviationNormalized( v,mean )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  var result = this.variance( v,mean );

  return _sqrt( result ) / mean;
}

var op = standardDeviationNormalized.operation = _.mapExtend( null , variance.operation );

//

function kurtosis( v,mean )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  var variance = this.variance( v,mean );
  var result = this.momentCentral( v,4,mean );

  return result / _pow( variance,2 );
}

var op = kurtosis.operation = _.mapExtend( null , variance.operation );

//

/* kurtosis of normal distribution is three */

function kurtosisNormalized( v,mean )
{
  var result = this.kurtosis.apply( this,arguments );
  return result - 3;
}

var op = kurtosisNormalized.operation = _.mapExtend( null , variance.operation );

//

function skewness( v,mean )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( mean === undefined || mean === null )
  mean = _.avector.mean( v );

  var moment = this.moment( v,3 );
  var std = this.std( v,mean );

  return moment / _pow( std,3 );
}

var op = skewness.operation = _.mapExtend( null , variance.operation );

// --
// prototype
// --

var RoutinesMathematical =
{

  // basic

  assign : assign,
  assignVector : assignVector,

  clone : clone,
  makeSimilar : makeSimilar,

  slice : slice,
  subarray : subarray,

  toArray : toArray,
  _toStr : _toStr,

  gather : gather,


  // special

  sort : sort,
  randomInRadius : randomInRadius,

  // boundingSphereExpend : boundingSphereExpend,
  // bsphereFromBbox : bsphereFromBbox,

  crossWithPoints : crossWithPoints,
  _cross3 : _cross3,
  cross3 : cross3,
  cross : cross,

  quaternionApply : quaternionApply,
  quaternionApply2 : quaternionApply2,
  eulerApply : eulerApply,

  reflect : reflect,

  matrixApplyTo : matrixApplyTo,
  matrixHomogenousApply : matrixHomogenousApply,
  matrixDirectionsApply : matrixDirectionsApply,

  swapVectors : swapVectors,
  swapAtoms : swapAtoms,

  formate : formate,


  // atom-wise, modifying, taking single vector : self

  /* _operationTakingDstSrcReturningSelfComponentWise_functor */

  inv : inv,
  invOrOne : invOrOne,

  floor : floor,
  ceil : ceil,
  abs : abs,
  // round : round,

  normalize : normalize,


  // atom-wise, assigning, mixed : self

  /* _operationReturningSelfTakingVariantsComponentWise_functor */
  /* _operationReturningSelfTakingVariantsComponentWiseAct_functor */

  addAssigning : add.assigning,
  subAssigning : sub.assigning,
  mulAssigning : mul.assigning,
  divAssigning : div.assigning,

  minAssigning : min.assigning,
  maxAssigning : max.assigning,
  clampAssigning : clamp.assigning,
  randomInRangeAssigning : randomInRange.assigning,
  mixAssigning : mix.assigning,


  // atom-wise, copying, mixed : self

  addCopying : add.copying,
  subCopying : sub.copying,
  mulCopying : mul.copying,
  divCopying : div.copying,

  minCopying : min.copying,
  maxCopying : max.copying,
  clampCopying : clamp.copying,
  randomInRangeCopying : randomInRange.copying,
  mixCopying : mix.copying,

/*
  _handleAtom_functor : _handleAtom_functor,
  _onVectors_functor : _onVectors_functor,
  _operationOnVector_functor : _operationOnVector_functor,
*/

  // atom-wise,
  // 1 vector , 1 scalar -> self

  addScalar : Routines.addScalar,
  subScalar : Routines.subScalar,
  mulScalar : Routines.mulScalar,
  divScalar : Routines.divScalar,

  assignScalar : Routines.assignScalar,
  minScalar : Routines.minScalar,
  maxScalar : Routines.maxScalar,


// atom-wise,
// vectors only -> self

  addVectors : Routines.addVectors,
  subVectors : Routines.subVectors,
  mulVectors : Routines.mulVectors,
  divVectors : Routines.divVectors,

  assignVectors : Routines.assignVectors,
  minVectors : Routines.minVectors,
  maxVectors : Routines.maxVectors,


// atom-wise, commutative
// generic -> self

  add : Routines.add,
  sub : Routines.sub,
  mul : Routines.mul,
  div : Routines.div,

  min : Routines.min,
  max : Routines.max,

  // assign : Routines.assign,


// atom-wise, not atom-parallel
// vector scaled -> self

  addScaled : Routines.addScaled,
  subScaled : Routines.subScaled,
  mulScaled : Routines.mulScaled,
  divScaled : Routines.divScaled,

  clamp : Routines.clamp, /* !!! */
  mix : Routines.mix, /* !!! */

  // reduce to scalar

  /* _operationReduceToScalar_functor */

  polynomApply : Routines.polynomApply,
  mean : Routines.mean,
  moment : Routines.moment,
  _momentCentral : Routines._momentCentral,
  // momentCentral : Routines.momentCentral,
  reduceToMean : Routines.reduceToMean,
  reduceToProduct : Routines.reduceToProduct,
  reduceToSum : Routines.reduceToSum,
  reduceToAbsSum : Routines.reduceToAbsSum,
  reduceToMag : Routines.reduceToMag,
  reduceToMagSqr : Routines.reduceToMagSqr,

  polynomApplyFiltering : Routines.polynomApplyFiltering,
  meanFiltering : Routines.meanFiltering,
  momentFiltering : Routines.momentFiltering,
  _momentCentralFiltering : Routines._momentCentralFiltering,
  // momentCentralFiltering : Routines.momentCentralFiltering,
  reduceToMeanFiltering : Routines.reduceToMeanFiltering,
  reduceToProductFiltering : Routines.reduceToProductFiltering,
  reduceToSumFiltering : Routines.reduceToSumFiltering,
  reduceToAbsSumFiltering : Routines.reduceToAbsSumFiltering,
  reduceToMagFiltering : Routines.reduceToMagFiltering,
  reduceToMagSqrFiltering : Routines.reduceToMagSqrFiltering,

  isFinite : Routines.isFinite,
  isNan : Routines.isNan,
  // isValid : Routines.isValid,
  isInt : Routines.isInt,
  isZero : Routines.isZero,

  isFiniteFiltering : Routines.isFiniteFiltering,
  isNanFiltering : Routines.isNanFiltering,
  // isValidFiltering : Routines.isValidFiltering,
  isIntFiltering : Routines.isIntFiltering,
  isZeroFiltering : Routines.isZeroFiltering,

    // isFinite : isFinite,
    // isNan : isNan,
    // isValid : isValid,
    // isInt : isInt,
    // isZero : isZero,


  // reduce to extremal

  /* _operationReduceToExtremal_functor*/

  reduceToClosestFiltering : reduceToClosest.filtering,
  reduceToFurthestFiltering : reduceToFurthest.filtering,
  reduceToMinFiltering : reduceToMin.filtering,
  reduceToMinAbsFiltering : reduceToMinAbs.filtering,
  reduceToMaxFiltering : reduceToMax.filtering,
  reduceToMaxAbsFiltering : reduceToMaxAbs.filtering,
  distributionRangeSummaryFiltering : distributionRangeSummary.filtering,

  reduceToClosest : reduceToClosest.trivial,
  reduceToFurthest : reduceToFurthest.trivial,
  reduceToMin : reduceToMin.trivial,
  reduceToMinAbs : reduceToMinAbs.trivial,
  reduceToMax : reduceToMax.trivial,
  reduceToMaxAbs : reduceToMaxAbs.trivial,
  distributionRangeSummary : distributionRangeSummary.trivial,

  reduceToMinValue : reduceToMinValue,
  reduceToMaxValue : reduceToMaxValue,
  distributionRangeSummaryValue : distributionRangeSummaryValue,


  // zip reductor

  dot : dot,
  distance : distance,
  distanceSqr : distanceSqr,


  // interruptible reductor with bool result

  _equalAre : _equalAre,
  equalAre : equalAre,
  identicalAre : identicalAre,
  equivalentAre : equivalentAre,

  areParallel : areParallel,


  // helper

  mag : mag,
  magSqr : magSqr,
  median : median,

  momentCentral : momentCentral,
  momentCentralFiltering : momentCentralFiltering,

  distributionSummary : distributionSummary,

  variance : variance,
  varianceFiltering : varianceFiltering,

  std : standardDeviation,
  standardDeviation : standardDeviation,
  coefficientOfVariation : standardDeviationNormalized,
  standardDeviationNormalized : standardDeviationNormalized,

  kurtosis : kurtosis,
  kurtosisNormalized : kurtosisNormalized,
  kurtosisExcess : kurtosisNormalized,

  skewness : skewness,

}

// debugger;
for( var r in Routines )
_.assert( RoutinesMathematical[ r ],'routine',r,'was not declared explicitly in the proto map' );
// debugger;

//

var Forbidden =
{
  /*clamp : 'clamp',*/
  randomInRange : 'randomInRange',
  // mix : 'mix',
  // add : 'add',
  // sub : 'sub',
  // mul : 'mul',
  // div : 'div',
  // min : 'min',
  // max : 'max',
}

// --
// adjust routines
// --

function _adjustRoutine( theRoutine,routineName )
{

  if( _.objectIs( theRoutine ) )
  {
    for( var r in theRoutine )
    _adjustRoutine( theRoutine[ r ],r );
    return;
  }

  _.assert( _.routineIs( theRoutine ),'routine',routineName,'is not defined' );
  _.assert( _.mapIs( theRoutine.operation ),'operation of routine',routineName,'is not defined' );

  var operation = theRoutine.operation;
  if( operation.valid )
  return;

  /* adjust */

  operation.returningArray = !!operation.returningArray;
  operation.returningNumber = !!operation.returningNumber;
  operation.reducing = !!operation.reducing;

  operation.atomWise = !!operation.atomWise;
  operation.commutative = !!operation.commutative;
  operation.special = !!operation.special;

  /* var */

  var takingArguments = operation.takingArguments;
  var takingVectors = operation.takingVectors;
  var takingVectorsOnly = operation.takingVectorsOnly;
  var atomWise = operation.atomWise;
  var commutative = operation.commutative;

  var modifying = operation.modifying;
  var reducing = operation.reducing;

  var returningNew = operation.returningNew;
  var returningSelf = operation.returningSelf;
  var returningArray = operation.returningArray;
  var returningNumber = operation.returningNumber;

  var differentReturns = 0;
  differentReturns += operation.returningNew ? 1 : 0;
  differentReturns += operation.returningSelf ? 1 : 0;
  differentReturns += operation.returningArray ? 1 : 0;
  differentReturns += operation.returningNumber ? 1 : 0;

  var returningOnly = operation.returningOnly;
  if( returningOnly === null || returningOnly === undefined )
  {
    returningOnly = '';
    if( differentReturns === 1 )
    {
      returningOnly = operation.returningNew ? 'new' : returningOnly;
      returningOnly = operation.returningSelf ? 'self' : returningOnly;
      returningOnly = operation.returningArray ? 'array' : returningOnly;
      returningOnly = operation.returningNumber ? 'number' : returningOnly;
    }
    operation.returningOnly = returningOnly;
  }

  /* verify */

  // _.assert( operation.name === routineName || operation.name === undefined );
  _.assert( operation.routine === theRoutine || operation.routine === undefined );
  _.assert( _.routineIs( theRoutine ) );
  _.assert( _.mapIs( operation ) );
  _.assert( _.numberIs( takingArguments ) || _.arrayIs( takingArguments ) );
  _.assert( _.numberIs( takingVectors ) || _.arrayIs( takingVectors ) );
  _.assert( _.boolIs( atomWise ) );
  _.assert( _.boolIs( commutative ) );
  _.assert( _.boolIs( takingVectorsOnly ) );
  _.assert( _.boolIs( modifying ) );
  _.assert( _.boolIs( reducing ) );

  // _.assert( returningNew != returningSelf || !returningNew || _.strHas( operation.input[ 0 ],'|n' ) );
  _.assert( _.boolIs( returningSelf ) );
  _.assert( _.boolIs( returningNew ) );
  _.assert( _.boolIs( returningArray ) );
  _.assert( _.boolIs( returningNumber ) );
  _.assert( _.strIs( returningOnly ) );
  _.assert( ( !!returningOnly ) == ( differentReturns == 1 ) );

  _.assert( operation.handleAtom === undefined );
  _.assert( operation.handleVector === undefined );
  _.assert( operation.handleVectors === undefined );
  _.assert( operation.handleBegin === undefined );
  _.assert( operation.handleEnd === undefined );

  _.accessorForbid
  ({
    object : operation,
    names :
    {
      handleAtom : 'handleAtom',
      handleVector : 'handleVector',
      handleVectors : 'handleVectors',
      handleBegin : 'handleBegin',
      handleEnd : 'handleEnd',
      onBegin : 'onBegin',
      onEnd : 'onEnd',
    },
  });

  var _names = _.mapKeys( OperationDescriptor );
  _.arrayRemoveOnce( _names,'name' );
  _.accessorForbid
  ({
    object : theRoutine,
    names : _names,
  });

  /* adjust */

  operation.takingArguments = _.numbersFromNumber( takingArguments,2 );
  operation.takingVectors = _.numbersFromNumber( takingVectors,2 );
  operation.name = routineName;
  operation.routine = theRoutine;
  operation.valid = 1;

  /* validate */

  _.assert( _.routineIs( theRoutine ) );
  _.assert( _.mapIs( operation ) );
  _.assert( operation.name === routineName );
  _.assert( operation.routine === theRoutine );
  _.assert( operation.takingArguments.length === 2 );
  _.assert( operation.takingVectors.length === 2 );
  _.assert( operation.takingArguments[ 0 ] >= operation.takingVectors[ 0 ] );
  _.assert( operation.takingArguments[ 1 ] >= operation.takingVectors[ 1 ] );

}

//

_.assert( RoutinesMathematical.assign );
_.assert( RoutinesMathematical.assign.operation );
_.assert( RoutinesMathematical.assign.operation.takingArguments );
// _.assert( _.numberIs( RoutinesMathematical.assign.operation.takingArguments ) );

for( var r in RoutinesMathematical )
_adjustRoutine( RoutinesMathematical[ r ],r );

// --
// proto
// --

var Proto =
{

  RoutinesMathematical : RoutinesMathematical,

  EPS : EPS,
  EPS2 : EPS2,

  Forbidden : Forbidden,

}

_.mapExtend( Proto,RoutinesMathematical );
_.mapExtend( Self,Proto );

_.assert( _.vector.reduceToMean );
_.assert( !_.vector.isValid );
_.assert( _.vector.isFinite );
_.assert( _.vector.reduceToMaxValue );
_.assert( RoutinesMathematical.reduceToMaxValue );

_.assert( _.vector.EPS >= 0 );
_.assert( _.vector.EPS2 >= 0 );

_.accessorForbid
({
  object : Self,
  names : Forbidden,
});

})();
