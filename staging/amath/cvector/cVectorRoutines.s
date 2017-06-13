(function _fVectorRoutines_s_() {

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
  returningSelf : null,
  returningNew : null,
  returningArray : null,
  returningNumber : null,
  modifying : null,
  reducing : null,
})
.end

// --
// basic
// --

function set( dst )
{
  var length = dst.length;
  var alength = arguments.length;

  if( alength === 2 )
  {
    if( _.numberIs( arguments[ 1 ] ) )
    this.assignScalar( dst,arguments[ 1 ] );
    else if( _hasLength( arguments[ 1 ] ) )
    this.assign( dst,_.vector.fromArray( arguments[ 1 ] ) );
    else _.assert( 0,'unknown arguments' );
  }
  else if( alength === 1 + length )
  {
    this.assign.call( this,dst,_.vector.fromArray( _arraySlice( arguments,1,alength ) ) );
  }
  else if( alength === 1 )
  {
  }
  else throw _.err( 'set :','unknown arguments' );

  return dst;
}

var op = set.operation = Object.create( null );
op.atomWise = true;
op.commutative = false;
op.takingArguments = [ 1,Infinity ];
op.takingVectors = [ 1,2 ];
op.takingVectorsOnly = false;
op.returningSelf = true;
op.returningNew = false;
op.modifying = true;

//

function assign( dst,src )
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

var op = assign.operation = Object.create( null );
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
    if( src._vectorBuffer.set )
    {
      result = new src._vectorBuffer.constructor( last-first );
      result.set( src._vectorBuffer );
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

// //
//
// function boundingSphereExpend( dst )
// {
//   var length = dst.length;
//   var dstPosition = _.vector.fromSubArray( dst,0,dst.length-1 );
//   var radius = dst.eGet( dst.length-1 );
//   var radiusSqr = radius*radius;
//
//   for( var a = 1 ; a < arguments.length ; a++ )
//   {
//
//     var src = arguments[ a ];
//     _assert( dst.length === src.length || dstPosition.length === src.length,'wrong length of vector' );
//
//     var srcPosition = _.vector.fromSubArray( src,0,length-1 );
//     var distanceSqr = _.vector.distanceSqr( dstPosition,srcPosition );
//
//     if( distanceSqr > radiusSqr )
//     {
//
//       var distance = sqrt( distanceSqr );
//       var offset = ( distance - radius ) / 2;
//
//       mix.call( this,dstPosition,srcPosition,offset / distance );
//
//       radius += offset;
//       radiusSqr = radius*radius;
//
//     }
//
//   }
//
//   dst.eSet( length-1,radius );
//
//   return dst;
// }
//
// var op = boundingSphereExpend.operation = Object.create( null );
// op.atomWise = false;
// op.commutative = false;
// op.takingArguments = [ 2,Infinity ];
// op.takingVectors = [ 2,Infinity ];
// op.takingVectorsOnly = true;
// op.returningSelf = true;
// op.returningNew = false;
// op.modifying = true;
//
// //
//
// function bsphereFromBbox( bsphere,bbox )
// {
//
//   _assert( bsphere.length === 4 && bbox.length === 6,'quaternionApply :','expects vector and quaternion as arguments' );
//
//   var center = this.subarray( bsphere,0,3 );
//   var bboxMin = this.subarray( bbox,0,3 );
//   var bboxMax = this.subarray( bbox,3,6 );
//
//   this.assign( center,bboxMin );
//   this.addVectors( center,bboxMax );
//   this.divScalar( center,2 );
//
//   var sizes = this.subVectors( clone( bboxMax ),bboxMin );
//   this.sort( sizes );
//
//   bsphere.eSet( 3,this.subarray( sizes,1,3 ).mag() / 2 );
//
//   return bsphere;
// }
//
// var op = bsphereFromBbox.operation = Object.create( null );
// op.atomWise = false;
// op.commutative = false;
// op.takingArguments = 2;
// op.takingVectors = 2;
// op.takingVectorsOnly = true;
// op.returningSelf = true;
// op.returningNew = false;
// op.modifying = true;

//

function cross( dst, src )
{

  _.assert( dst.length === 3 && src.length === 3,'implemented only for 3D' );

  var ax = dst.eGet( 0 ), ay = dst.eGet( 1 ), az = dst.eGet( 2 );
  var bx = src.eGet( 0 ), by = src.eGet( 1 ), bz = src.eGet( 2 );

  dst.eSet( 0, ay * bz - az * by );
  dst.eSet( 1, az * bx - ax * bz );
  dst.eSet( 2, ax * by - ay * bx );

  return dst;
}

var op = cross.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 2;
op.takingVectors = 2;
op.takingVectorsOnly = true;
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

function crossVectors( dst, src1, src2 )
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

var op = crossVectors.operation = Object.create( null );
op.atomWise = false;
op.commutative = false;
op.takingArguments = 3;
op.takingVectors = 3;
op.takingVectorsOnly = true;
op.returningSelf = true;
op.returningNew = false;
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

function matrixApply( dst,srcMatrix )
{
  _.assert( arguments.length === 2 );
  _.assert( _.spaceIs( srcMatrix ) );
  debugger;
  return _.space.mul( dst,[ srcMatrix,dst ] );
}

var op = matrixApply.operation = Object.create( null );
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

function mag( v )
{

  _assert( arguments.length === 1 );

  return this.reduceToMag( v );
}

var op = mag.operation = Object.create( null );
op.atomWise = true;
op.commutative = true;
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function magSqr( v )
{

  _assert( arguments.length === 1 );

  return this.reduceToMagSqr( v );
}

var op = magSqr.operation = Object.create( null );
op.atomWise = true;
op.commutative = true;
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

// --
// atom-wise, modifying, taking single vector : self
// --

function _operationTakingDstSrcReturningSelfComponentWise_functor( o )
{

  var onEach = o.onEach;
  var onBegin = o.onBegin || function(){};
  var onEnd = o.onEnd || function(){};

  _assert( _.objectIs( o ) );
  _assert( _.routineIs( onEach ) );
  _assert( _.routineIs( onBegin ) );
  _assert( _.routineIs( onEnd ) );
  _assert( arguments.length === 1 );

  var routine = function _operationTakingDstSrcReturningSelfComponentWise( dst,src )
  {

    var length = dst.length;
    if( !src )
    src = dst;

    _assert( arguments.length <= 2 );
    _assert( dst.length === src.length,'src and dst must have same length' );

    onBegin.call( this,dst,src );

    for( var i = 0 ; i < length ; i++ )
    onEach.call( this,dst,src,i );

    onEnd.call( this,dst,src );

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

var round = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onEach : function round( dst,src,i )
  {
    dst.eSet( i, Math.round( src.eGet( i ) ) );
  }
});

//

var _normalizeM;
var normalize = _operationTakingDstSrcReturningSelfComponentWise_functor
({
  onBegin : function normalize( dst,src )
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
  onBegin : function(){},
  onEnd : function(){},
  onMakeIdentity : function(){},
}

//

function _operationReturningSelfTakingVariantsComponentWiseAct_functor( operation )
{

  _assert( arguments.length === 1 );
  _.routineOptions( _operationReturningSelfTakingVariantsComponentWiseAct_functor,operation );
  _assert( _.objectIs( operation ) );
  _assert( _.routineIs( operation.onEach ) );
  _assert( _.routineIs( operation.onBegin ) );
  _assert( _.routineIs( operation.onEnd ) );
  _assert( _.arrayIs( operation.takingArguments ) );

  var onBegin = operation.onBegin;
  var onEach = operation.onEach;
  var onEnd = operation.onEnd;
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

    onBegin.apply( args,args,length );

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

    onEnd.apply( args,args,length );

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
  _.assert( _.routineIs( onAtom ) );

  if( _.arrayIdentical( o.input , [ 'vw','vr+' ] ) )
  {

    handleAtom = o.handleAtom = function handleAtom( o )
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

  }
  else if( _.arrayIdentical( o.input , [ 'vw','s' ] ) )
  {

    var handleAtom = o.handleAtom = function handleAtom( o )
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

  }
  else if( _.arrayIdentical( o.inputWithoutLast , [ 'vw' ] ) && _.strBegins( o.inputLast,'vr|s*' ) && o.commutative === false )
  {

    handleAtom = o.handleAtom = function handleAtom( o )
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

  }
  else _.assert( 0,'unknown kind of input',o.input );

  return handleAtom;
}

//

function _handleVector_functor( o )
{

  var takingArguments = o.takingArguments;
  var handleAtom = o.handleAtom;
  var handleVector = null;

  _.assert( arguments.length === 1 );
  _.assert( takingArguments.length === 2 );
  _.assert( handleAtom );

  if( _.arrayIdentical( o.input , [ 'vw','vr+' ] ) )
  {

    handleVector = function handleVector()
    {

      var dst = arguments[ 0 ];
      var o = Object.create( null );
      o.key = -1;
      o.args = arguments;
      o.dstContainer = dst;
      o.srcContainers = _.arraySlice( arguments,1,arguments.length );

      /* */

      if( Config.debug )
      {
        _.assert( _.vectorIs( dst ) );
        _.assert( arguments.length >= 2,'expects at least 2 vectors' );
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
        handleAtom.call( this,o );
      }

      return dst;
    }

    handleVector.operation = o;
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

    _.assert( takingArguments[ 0 ] === 2 && takingArguments[ 1 ] === Infinity );

  }
  else if( _.arrayIdentical( o.input , [ 'vw','s' ] ) )
  {

    handleVector = function handleVector( dst,src )
    {

      if( Config.debug )
      {
        _.assert( _.vectorIs( dst ) );
        _.assert( arguments.length === 2,'expects 2 arguments' );
        _.assert( _.numberIs( src ) );
      }

      /* */

      var o = Object.create( null );
      o.key = -1;
      o.args = arguments;
      o.dstContainer = dst;
      o.srcElement = src;

      for( var k = 0 ; k < dst.length ; k++ )
      {
        o.key = k;
        o.dstElement = dst.eGet( k );
        handleAtom.call( this,o );
      }

      return dst;
    }

    handleVector.operation = o;
    o.takingArguments = [ 2,2 ];
    o.takingVectors = [ 1,1 ];
    o.takingVectorsOnly = false;
    o.commutative = true;
    o.atomWise = true;
    o.returningSelf = true;
    o.returningNew = false;
    o.returningArray = false;
    o.modifying = true;
    o.operation = o;

    _.assert( takingArguments[ 0 ] === 2 && takingArguments[ 1 ] === 2 );

  }
  else if( _.arrayIdentical( o.inputWithoutLast , [ 'vw' ] ) && _.strBegins( o.inputLast,'vr|s*' ) && o.commutative === false )
  {

    handleVector = function handleVector()
    {

      var args = _.arraySlice( arguments,1,arguments.length );
      var dst = arguments[ 0 ];
      var o = Object.create( null );
      o.key = -1;
      o.args = args;
      o.dstContainer = dst;
      o.srcContainers = args;
      o.srcElements = [];

      /* */

      for( var a = 0 ; a < args.length ; a++ )
      {
        var src = args[ a ];
        src = args[ a ] = vector.fromMaybeNumber( src,dst.length );
      }

      /* */

      if( Config.debug )
      {
        _.assert( _.vectorIs( dst ) );
        _.assert( arguments.length >= 2,'expects at least 2 arguments' );
        _.assert( takingArguments[ 0 ] <= arguments.length && arguments.length <= takingArguments[ 1 ],'expects ', takingArguments, ' arguments' );
        for( var a = 0 ; a < args.length ; a++ )
        {
          var src = args[ a ];
          _.assert( _.vectorIs( src ) || _.numberIs( src ) );
          /*src = args[ a ] = vector.fromMaybeNumber( src,dst.length );*/
          _.assert( dst.length === src.length,'src and dst should have same length' );
        }
      }

      /* */

      for( var k = 0 ; k < dst.length ; k++ )
      {
        o.key = k;
        o.dstElement = dst.eGet( k );
        handleAtom.call( this,o );
      }

      return dst;
    }

    handleVector.operation = o;
    o.takingArguments = takingArguments;
    o.takingVectors = [ 1,takingArguments[ 1 ] ];
    o.takingVectorsOnly = false;
    o.commutative = false;
    o.atomWise = true;
    o.returningSelf = true;
    o.returningNew = false;
    o.returningArray = false;
    o.modifying = true;

    _.assert( takingArguments[ 0 ] >= 2 && takingArguments[ 1 ] >= 2 );

  }
  else _.assert( 0,'unknown kind of input',o.input );

  return handleVector;
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
  // o = _.mapExtend( null,{ operation : { onAtom : o } } );
  else
  o = _.mapExtend( null,o );

  var onAtom = o.onAtom;
  if( o.takingArguments === undefined )
  o.takingArguments = onAtom.takingArguments;

  /* */

  _.assertMapHasOnly( o,_operationOnVector_functor.defaults );
  _.assert( o.atomOperation );
  _.assert( _.routineIs( onAtom ) );
  _.assert( _.arrayIs( o.takingArguments ) );
  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.input ) || _.arrayIs( o.input ) );
  _.assert( _.boolIs( o.commutative ) || _.boolIs( o.commutative ) );

  /* */

  if( o.commutative === null )
  o.commutative = onAtom.commutative;

  if( o.input === null )
  o.input = onAtom.input;
  o.inputWithoutLast = o.input.slice( 0,o.input.length-1 );
  o.inputLast = o.input[ o.input.length-1 ];

  // var takingArguments = o.operation.takingArguments;
  // if( o.takingArguments !== null )
  // takingArguments = o.takingArguments;
  // o.takingArguments = takingArguments;

  /* */

  o.handleAtom = _handleAtom_functor( o );
  o.handleVector = _handleVector_functor( o );

  /* */

  _.assert( _.arrayIs( o.takingArguments ) );

  return o.handleVector;
}

_operationOnVector_functor.defaults =
{

  // operation : null,

  name : null,
  atomOperation : null,
  input : null,
  onAtom : null,
  onAtomBegin : null,
  onAtomEnd : null,

  takingArguments : null,
  commutative : null,
  atomWise : null,

}

//

function declareAomWiseParallelVectorsRoutines()
{

  for( var op in operations.atomWiseCommutative )
  {
    var routineName = op + 'Vectors';
    var atomOperation = operations.atomWiseCommutative[ op ];
    var operation = _.mapExtend( null,atomOperation );

    _.assert( operation.atomOperation === undefined );
    _.assert( _.strIsNotEmpty( operation.name ) );
    _.assert( _.routineIs( atomOperation.onAtom ) );
    _.assert( !Routines[ routineName ] );

    operation.atomOperation = atomOperation;
    operation.input = [ 'vw','vr+' ];
    operation.takingArguments = [ 2,Infinity ];
    operation.name = routineName;

    Routines[ routineName ] = _operationOnVector_functor( operation );

    // Routines[ routineName ] = _operationOnVector_functor
    // ({
    //   input : [ 'vw','vr+' ],
    //   takingArguments : [ 2,Infinity ],
    // });

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
    operation.input = [ 'vw','s' ];
    operation.takingArguments = [ 2,2 ];
    operation.name = routineName;

    Routines[ routineName ] = _operationOnVector_functor( operation );

  }

  _.assert( Routines.addScalar );

}

// function declareAomWiseParallelScalarRoutines()
// {
//
//   for( var op in operations.atomWiseCommutative )
//   {
//     var routineName = op + 'Scalar';
//     var operation = operations.atomWiseCommutative[ op ];
//     var onAtom = operation.onAtom;
//
//     _.assert( _.routineIs( onAtom ) );
//     _.assert( !Routines[ routineName ] );
//
//     Routines[ routineName ] = _operationOnVector_functor
//     ({
//       // onAtom : operation,
//       operation : operation,
//       input : [ 'vw','s' ],
//     });
//   }
//
//   _.assert( Routines.addScalar );
//
// }

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

    Routines[ routineName ] = _operationOnVector_functor( operation );

  }

  _.assert( Routines.addScaled );

}

// function declareAomWiseNotParallelRoutines()
// {
//
//   for( var op in operations.atomWiseNotCommutative )
//   {
//     var routineName = op;
//     var operation = operations.atomWiseNotCommutative[ op ];
//
//     _.assert( _.mapIs( operation ) );
//     _.assert( _.routineIs( operation.onAtom ) );
//     _.assert( !Routines[ routineName ] );
//
//     Routines[ routineName ] = _operationOnVector_functor
//     ({
//       operation : operation,
//     });
//   }
//
//   _.assert( Routines.addScaled );
//
// }

// --
// reduce to element
// --

function __operationReduceToScalar_functor( operation )
{

  _.routineOptions( __operationReduceToScalar_functor,operation );

  var onBegin = operation.onBegin;
  var onAtom = operation.onAtom;
  var onEnd = operation.onEnd;
  var filtering = operation.filtering;
  var takingArguments = operation.takingArguments = _.numbersFromNumber( operation.takingArguments,2 );
  var takingVectors = operation.takingVectors = _.numbersFromNumber( operation.takingVectors,2 );

  if( takingArguments[ 0 ] < takingVectors[ 0 ] )
  takingArguments[ 0 ] = takingVectors[ 0 ];

  _.assert( takingVectors.length === 2 );
  _.assert( takingArguments.length === 2 );

  if( !onBegin )
  onBegin = function( o )
  {
    debugger;
    o.result = 0;
  }

  if( !onEnd )
  onEnd = function( o )
  {
  }

  // if( _.arrayIs( takingVectors ) )
  // {
  //   // _assert( takingVectors[ 0 ] === takingVectors[ 1 ] );
  //   // takingVectors = takingVectors[ 0 ];
  // }
  //
  // if( takingArguments )
  // {
  //   // _assert( _.numberIs( takingArguments ) || _.arrayIs( takingArguments ) );
  //   // takingVectors = takingVectors[ 0 ];
  // }

  _assertMapHasOnly( operation,__operationReduceToScalar_functor.defaults );
  _assert( _.objectIs( operation ) );
  _assert( _.routineIs( onAtom ) );
  _assert( _.routineIs( onBegin ) );
  _assert( _.routineIs( onEnd ) );
  _assert( onAtom.length === 1 );
  _assert( onBegin.length === 1 );
  _assert( onEnd.length === 1 );

  /* */

  function handleBegin( o )
  {

    _.assert( arguments.length === 1 )

    var op = Object.create( null );
    op.container = null;
    op.key = -1;
    op.element = null;
    op.result = null;
    op.args = null;
    op.filter = null;
    Object.preventExtensions( op );

    _.mapExtend( op,o );
    _.assert( op.args );

    var r = onBegin.call( this,op );
    _.assert( r === undefined );
    _.assert( op.result !== undefined );

    return op;
  }

  /* */

  function handleEnd( op )
  {
    var r = onEnd.call( this,op );
    _.assert( r === undefined );
    _.assert( op.result !== undefined );
  }

  /* */

  function handleAtom( o )
  {

    if( o.filter )
    if( !o.filter.call( this,o.element,o ) )
    return;

    var r = onAtom.call( this,o );

    _.assert( r === undefined );
    _.assert( o.result !== undefined );

  }

  handleAtom.defaults =
  {
    container : null,
    key : -1,
    element : null,
    result : null,
    args : null,
    filter : null,
  }

  /* */

  var routine = function operationReduce()
  {

    /*console.log( 'operationReduce',operation );*/

    if( Config.debug && takingArguments )
    {
      _assert( takingArguments[ 0 ] <= arguments.length && arguments.length <= takingArguments[ 1 ] );
    }

    var filter = null;
    var numberOfArguments = arguments.length;
    if( filtering )
    {
      numberOfArguments -= 1;
      filter = arguments[ numberOfArguments ];
      _.routineIs( filter );
      _.assert( filter.length === 2 );
    }

    numberOfArguments = _.clamp( numberOfArguments,takingVectors );

    var op = handleBegin({ args : arguments , filter : filter });

    for( var a = 0 ; a < numberOfArguments ; a++ )
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

  operation.handleBegin = handleBegin;
  operation.handleEnd = handleEnd;
  operation.handleAtom = handleAtom;
  operation.handleVectors = routine;

  var def =
  {
    takingArguments : [ 0,Infinity ],
    takingVectors : [ 0,Infinity ],
    takingVectorsOnly : !filtering,
    returningSelf : false,
    returningNew : false,
    returningArray : false,
    returningNumber : ( operation.returningNumber !== undefined && operation.returningNumber !== null ? !!operation.returningNumber : true ),
    modifying : false,
    reducing : true,
  }

  _.mapSupplementNulls( operation,def );
  // _.mapExtend( routine,operation )
  routine.operation = operation;

  return routine;
}

__operationReduceToScalar_functor.defaults =
{
  onAtom : null,
  onBegin : null,
  onEnd : null,
  filtering : null,
  takingArguments : [ 0,Infinity ],
  takingVectors : [ 0,Infinity ],
  // takingArguments : null,
  // takingVectors : null,
  // returningNumber : null,
}

__operationReduceToScalar_functor.defaults.__proto__ = OperationDescriptor;

//

function _operationReduceToScalar_functor( o )
{
  var result = Object.create( null );
  var filtering = o.filtering;

  _assert( _.objectIs( o ) );
  _assertMapHasOnly( o,_operationReduceToScalar_functor.defaults );

  if( filtering === undefined || filtering === null || !filtering )
  {
    var operation = _.mapExtend( null,o );
    operation.filtering = false;
    result.trivial = __operationReduceToScalar_functor( operation );
  }

  if( filtering === undefined || filtering === undefined || filtering )
  {
    var operation = _.mapExtend( null,o );
    operation.filtering = true;
    result.filtering = __operationReduceToScalar_functor( operation );
  }

  return result;
}

_operationReduceToScalar_functor.defaults =
{
}

_operationReduceToScalar_functor.defaults.__proto__ = __operationReduceToScalar_functor.defaults;

//

var polynomApply = _operationReduceToScalar_functor
({

  onAtom : function( o )
  {
    debugger;
    var x = o.args[ 1 ];
    o.result += o.element * _pow( x,o.key );
  },
  onBegin : function( o )
  {
    debugger;
    o.result = 0;
  },
  onEnd : function( o )
  {
    debugger;
  },

  takingArguments : [ 2,2 ],
  takingVectors : [ 1,1 ],
  takingVectorsOnly : false,

});

//

var reduceToAverage = _operationReduceToScalar_functor
({
  onAtom : function( o )
  {
    o.result.total += o.element;
    o.result.nelement += 1;
  },
  onBegin : function( o )
  {
    o.result = Object.create( null );
    o.result.total = 0;
    o.result.nelement = 0;
  },
  onEnd : function( o )
  {
    o.result = o.result.total / o.result.nelement;
  },
});

//

var reduceToProduct = _operationReduceToScalar_functor
({
  onAtom : function( o )
  {
    o.result *= o.element;
  },
  onBegin : function( o )
  {
    o.result = 1;
  },
});

//

var reduceToSum = _operationReduceToScalar_functor
({
  onAtom : function( o )
  {
    o.result += o.element;
  },
  onBegin : function( o )
  {
    o.result = 0;
  },
});

//

var reduceToAbsSum = _operationReduceToScalar_functor
({
  onAtom : function( o )
  {
    debugger;
    o.result += abs( o.element );
  },
  onBegin : function( o )
  {
    o.result = 0;
  },
});

//

var reduceToMagSqr = _operationReduceToScalar_functor
({
  onAtom : function( o )
  {
    o.result += _sqr( o.element );
  },
  onBegin : function( o )
  {
    o.result = 0;
  },
});

//

var reduceToMag = Object.create( null )

reduceToMag.trivial = function reduceToMag()
{
  return sqrt( reduceToMagSqr.trivial.apply( this,arguments ) );
}

var op = reduceToMag.trivial.operation = Object.create( null );
op.takingArguments = [ 1,+Infinity ];
op.takingVectors = [ 1,+Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

reduceToMag.filtering = function reduceToMagFiltering()
{
  return sqrt( reduceToMagSqrFiltering.apply( this,arguments ) );
}

var op = reduceToMag.filtering.operation = Object.create( null );
op.takingArguments = [ 1,+Infinity ];
op.takingVectors = [ 1,+Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

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
    onBegin : function( o )
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

function _reduceToMinmaxBegin( o )
{

  o.result = { min : Object.create( null ), max : Object.create( null ), };

  o.result.min.value = +Infinity;
  o.result.min.index = -1;
  o.result.min.container = null;
  o.result.max.value = -Infinity;
  o.result.max.index = -1;
  o.result.max.container = null;

}

function _reduceToMinmaxEach( o )
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

function _reduceToMinmaxEnd( o )
{
  if( o.result.min.index === -1 )
  {
    o.result.min.value = NaN;
    o.result.max.value = NaN;
  }
}

var reduceToMinmax = _operationReduceToScalar_functor
({
  onAtom : _reduceToMinmaxEach,
  onBegin : _reduceToMinmaxBegin,
  onEnd : _reduceToMinmaxEnd,
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

function reduceToMinmaxValue()
{
  var result = Self.reduceToMinmax.apply( Self,arguments );
  return [ result.min.value,result.max.value ];
}

var op = reduceToMinmaxValue.operation = Object.create( null );
op.takingArguments = [ 1,Infinity ];
op.takingVectors = [ 1,Infinity ];
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.returningNumber = false;
op.modifying = false;

// --
// 2 vectors -> scalar
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

function _isFinite( src )
{
  var result = 0;

  _.assert( arguments.length === 1 );

  var length = src.length;
  for( var i = 0 ; i < length ; i++ )
  if( !isFinite( src.eGet( i ) ) )
  return false;

  return true;
}

var op = _isFinite.operation = Object.create( null );
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function _isNan( src )
{
  var result = 0;

  _.assert( arguments.length === 1 );

  var length = src.length;
  for( var i = 0 ; i < length ; i++ )
  if( isNaN( src.eGet( i ) ) ) return true;

  return false;
}

var op = _isNan.operation = Object.create( null );
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function isValid( src )
{
  _.assert( arguments.length === 1 );
  return !_isNan( src );
}

var op = isValid.operation = Object.create( null );
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function isInteger( src )
{
  var length = src.length;

  debugger;

  _.assert( arguments.length === 1 );

  for( var i = 0 ; i < src.length ; i++ )
  {
    if( Math.floor( src.eGet( i ) ) !== src.eGet( i ) )
    return false;
  }

  return true;
}

var op = isInteger.operation = Object.create( null );
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

function isZero( src )
{
  var length = src.length;

  _.assert( arguments.length === 1 );

  for( var i = 0 ; i < src.length ; i++ )
  {
    if( Math.abs( src.eGet( i ) ) > EPS2 )
    return false;
  }

  return true;
}

var op = isZero.operation = Object.create( null );
op.takingArguments = 1;
op.takingVectors = 1;
op.takingVectorsOnly = true;
op.returningSelf = false;
op.returningNew = false;
op.modifying = false;

//

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

//

function areParallel( src1,src2,eps )
{
  var length = src1.length;
  var eps = ( eps !== undefined ) ? eps : EPS;

  _assert( src1.length === src2.length,'vector.distanceSqr :','src1 and src2 should have same length' );

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

// --
//
// --

declareAomWiseParallelVectorsRoutines();
declareAomWiseParallelScalarRoutines();
declareAomWiseNotParallelRoutines();

// --
// prototype
// --

var routineMathematical =
{

  // basic

  set : set,

  assign : assign,
  /*copy : assign,*/
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

  cross : cross,
  crossWithPoints : crossWithPoints,
  crossVectors : crossVectors,

  quaternionApply : quaternionApply,
  quaternionApply2 : quaternionApply2,
  eulerApply : eulerApply,

  reflect : reflect,

  matrixApply : matrixApply,
  matrixHomogenousApply : matrixHomogenousApply,
  matrixDirectionsApply : matrixDirectionsApply,

  swapVectors : swapVectors,
  swapAtoms : swapAtoms,

  mag : mag,
  magSqr : magSqr,


  // atom-wise, modifying, taking single vector : self

  /* _operationTakingDstSrcReturningSelfComponentWise_functor */

  inv : inv,
  invOrOne : invOrOne,

  floor : floor,
  ceil : ceil,
  round : round,

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
  _handleVector_functor : _handleVector_functor,
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


// atom-wise, not atom-parallel
// vectors only -> self

  addScaled : Routines.addScaled,
  subScaled : Routines.subScaled,
  mulScaled : Routines.mulScaled,
  divScaled : Routines.divScaled,
  clamp : Routines.clamp,


  // reduce to scalar

  /* _operationReduceToScalar_functor */

  polynomApply : polynomApply.trivial,
  polynomApplyFiltering : polynomApply.filtering,

  reduceToAverage : reduceToAverage.trivial,
  reduceToAverageFiltering : reduceToAverage.filtering,

  reduceToProduct : reduceToProduct.trivial,
  reduceToProductFiltering : reduceToProduct.filtering,

  reduceToSum : reduceToSum.trivial,
  reduceToSumFiltering : reduceToSum.filtering,

  reduceToAbsSum : reduceToAbsSum.trivial,
  reduceToAbsSumFiltering : reduceToAbsSum.filtering,

  reduceToMag : reduceToMag.trivial,
  reduceToMagFiltering : reduceToMag.filtering,
  // mag : reduceToMag.trivial,

  reduceToMagSqr : reduceToMagSqr.trivial,
  reduceToMagSqrFiltering : reduceToMagSqr.filtering,
  // magSqr : reduceToMagSqr.trivial,


  // reduce to extremal

  /* _operationReduceToExtremal_functor*/

  reduceToClosestFiltering : reduceToClosest.filtering,
  reduceToFurthestFiltering : reduceToFurthest.filtering,
  reduceToMinFiltering : reduceToMin.filtering,
  reduceToMinAbsFiltering : reduceToMinAbs.filtering,
  reduceToMaxFiltering : reduceToMax.filtering,
  reduceToMaxAbsFiltering : reduceToMaxAbs.filtering,
  reduceToMinmaxFiltering : reduceToMinmax.filtering,

  reduceToClosest : reduceToClosest.trivial,
  reduceToFurthest : reduceToFurthest.trivial,
  reduceToMin : reduceToMin.trivial,
  reduceToMinAbs : reduceToMinAbs.trivial,
  reduceToMax : reduceToMax.trivial,
  reduceToMaxAbs : reduceToMaxAbs.trivial,
  reduceToMinmax : reduceToMinmax.trivial,

  reduceToMinValue : reduceToMinValue,
  reduceToMaxValue : reduceToMaxValue,
  reduceToMinmaxValue : reduceToMinmaxValue,


  // not cumulative reductor

  dot : dot,
  distance : distance,
  distanceSqr : distanceSqr,


  // interruptible reductor with bool result

  isFinite : _isFinite,
  isNan : _isNan,
  isValid : isValid,
  isInteger : isInteger,
  isZero : isZero,

  _equalAre : _equalAre,
  equalAre : equalAre,
  identicalAre : identicalAre,
  equivalentAre : equivalentAre,

  areParallel : areParallel,

}

//

var Forbidden =
{
  /*clamp : 'clamp',*/
  randomInRange : 'randomInRange',
  mix : 'mix',
  add : 'add',
  sub : 'sub',
  mul : 'mul',
  div : 'div',
  min : 'min',
  max : 'max',
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
  var returningSelf = operation.returningSelf;
  var returningNew = operation.returningNew;
  var returningArray = operation.returningArray;
  var returningNumber = operation.returningNumber;
  var modifying = operation.modifying;
  var reducing = operation.reducing;

  /* verify */

  _.assert( operation.name === routineName || operation.name === undefined );
  _.assert( operation.routine === theRoutine || operation.routine === undefined );
  _.assert( _.routineIs( theRoutine ) );
  _.assert( _.mapIs( operation ) );
  _.assert( _.numberIs( takingArguments ) || _.arrayIs( takingArguments ) );
  _.assert( _.numberIs( takingVectors ) || _.arrayIs( takingVectors ) );
  _.assert( _.boolIs( atomWise ) );
  _.assert( _.boolIs( commutative ) );
  _.assert( _.boolIs( takingVectorsOnly ) );
  _.assert( _.boolIs( returningSelf ) );
  _.assert( _.boolIs( returningNew ) );
  _.assert( _.boolIs( returningArray ) );
  _.assert( _.boolIs( returningNumber ) );
  _.assert( _.boolIs( modifying ) );
  _.assert( _.boolIs( reducing ) );

  _.accessorForbid
  ({
    object : theRoutine,
    names : _.mapKeys( OperationDescriptor ),
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

_.assert( _.numberIs( routineMathematical.assign.operation.takingArguments ) );

for( var r in routineMathematical )
_adjustRoutine( routineMathematical[ r ],r );

// --
// proto
// --

var Proto =
{

  _routineMathematical : routineMathematical,

  EPS : EPS,
  EPS2 : EPS2,

  Forbidden : Forbidden,

}

_.mapExtend( Proto,routineMathematical );
_.mapExtend( Self,Proto );

_.assert( _.vector.reduceToAverage );
_.assert( _.vector.isValid );
_.assert( _.vector.reduceToMaxValue );
_.assert( routineMathematical.reduceToMaxValue );

_.assert( _.vector.EPS >= 0 );
_.assert( _.vector.EPS2 >= 0 );

_.accessorForbid
({
  object : Self,
  names : Forbidden,
});

})();
