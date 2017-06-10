( function _aVector_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  //if( typeof wBase === 'undefined' )
  try
  {
    require( '../../abase/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wTesting' );

  require( '../arithmetic/fVector.s' );
  require( '../arithmetic/xAnArray.s' );

}

//

var _ = wTools.withArray.Float32;
var Space = _.Space;
var vector = _.vector;
var vec = _.vector.fromArray;
var anarray = _.anarray;
var sqrt = _.sqrt;

var Parent = wTools.Testing;

_.assert( sqrt );

// --
// test
// --

function vectorIs( test )
{

  var a = [ 1,2,3 ];
  var n1 = 1;
  var n2 = '1';
  var n3 = arguments;
  var n4 = function( x ){};

  var v1 = vector.fromArray([ 1,2,3 ]);
  var v2 = vector.fromSubArray( [ -1,1,2,3,-1 ],1,3 );
  var v3 = vector.fromSubArrayWithStride( [ -1,1,-1,2,-1,3,-1 ],1,3,2 );
  var v4 = vector.fromArrayWithStride( [ 1,-1,2,-1,3 ],2 );
  var v5 = vector.from([ 1,2,3 ]);

  test.description = 'vectorIs'; //

  test.shouldBe( !_.vectorIs( a ) );
  test.shouldBe( !_.vectorIs( n1 ) );
  test.shouldBe( !_.vectorIs( n2 ) );
  test.shouldBe( !_.vectorIs( n3 ) );

  test.shouldBe( _.vectorIs( v1 ) );
  test.shouldBe( _.vectorIs( v2 ) );
  test.shouldBe( _.vectorIs( v3 ) );
  test.shouldBe( _.vectorIs( v4 ) );
  test.shouldBe( _.vectorIs( v5 ) );

  test.description = 'clsIsVector'; //

  test.shouldBe( !_.clsIsVector( a.constructor ) );
  test.shouldBe( !_.clsIsVector( n3.constructor ) );
  test.shouldBe( !_.clsIsVector( n4.constructor ) );

  test.shouldBe( _.clsIsVector( v1.constructor ) );
  test.shouldBe( _.clsIsVector( v2.constructor ) );
  test.shouldBe( _.clsIsVector( v3.constructor ) );
  test.shouldBe( _.clsIsVector( v4.constructor ) );
  test.shouldBe( _.clsIsVector( v5.constructor ) );

}

//

function to( test )
{
  debugger;

  if( Space )
  {

    test.description = 'vector to space'; //

    var v = vector.from([ 1,2,3 ]);
    var got = v.to( Space );
    var expected = Space.makeCol([ 1,2,3 ]);
    test.identical( got,expected );

  }

  test.description = 'vector to array'; //

  var v = vector.from([ 1,2,3 ]);
  var got = v.to( [].constructor );
  var expected = [ 1,2,3 ];
  test.identical( got,expected );

  test.description = 'vector to vector'; //

  var v = vector.from([ 1,2,3 ]);
  var got = v.to( vector.fromArray( [] ).constructor );
  test.shouldBe( got === v );

  test.description = 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => vector.from([ 1,2,3 ]).to() );
  test.shouldThrowErrorSync( () => vector.from([ 1,2,3 ]).to( [],1 ) );
  test.shouldThrowErrorSync( () => vector.from([ 1,2,3 ]).to( 1 ) );
  test.shouldThrowErrorSync( () => vector.from([ 1,2,3 ]).to( null ) );
  test.shouldThrowErrorSync( () => vector.from([ 1,2,3 ]).to( '1' ) );
  test.shouldThrowErrorSync( () => vector.from([ 1,2,3 ]).to( [],1 ) );

}

//

function sort( test )
{

  // 13.00 13.00 10.00 10.00 10.00 2.000 10.00 15.00 2.000 14.00 10.00 6.000 6.000 15.00 4.000 8.000

  var samples =
  [

    [ 0 ],

    [ 0,1 ],
    [ 1,0 ],

    [ 1,0,2 ],
    [ 2,0,1 ],
    [ 0,1,2 ],
    [ 0,2,1 ],
    [ 2,1,0 ],
    [ 1,2,0 ],

    [ 0,1,1 ],
    [ 1,0,1 ],
    [ 1,1,0 ],

    [ 0,0,1,1 ],
    [ 0,1,1,0 ],
    [ 1,1,0,0 ],
    [ 1,0,1,0 ],
    [ 0,1,0,1 ],

    /*_.arrayFill({ times : 16 }).map( function(){ return Math.floor( Math.random() * 16 ) } ),*/

  ];

  for( var s = 0 ; s < samples.length ; s++ )
  {
    var sample1 = samples[ s ].slice();
    var sample2 = samples[ s ].slice();
    debugger;
    _.vector.sort( _.vector.fromArray( sample1 ) );
    sample2.sort();
    test.identical( sample1,sample2 );
  }

}

//

function dot( test )
{
  debugger;

  var a = [ 1,2,3,4 ];
  var b = [ 6,7,8,9 ];

  var or1 = [ 3,1,5 ];
  var or2 = [ -1,3,0 ];

  test.description = 'anrarrays'; //

  var expected = 80;
  var got = _.anarray.dot( a,b );
  test.identical( got,expected )

  test.description = 'orthogonal anrarrays'; //

  var expected = 0;
  var got = _.anarray.dot( or1,or2 );
  test.identical( got,expected )

  test.description = 'empty anarrays'; //

  var expected = 0;
  var got = _.anarray.dot( [],[] );
  test.identical( got,expected )

  test.description = 'empty vectors'; //

  var expected = 0;
  var got = _.anarray.dot( vec([]),vec([]) );
  test.identical( got,expected )

  test.description = 'sub vectors'; //

  var av = _.vector.fromSubArray( a,1,3 );
  var bv = _.vector.fromSubArray( b,1,3 );
  var expected = 74;
  var got = _.anarray.dot( av,bv );
  test.identical( got,expected );

  test.description = 'bad arguments'; //

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => _.anarray.dot( 1 ) );
    test.shouldThrowErrorSync( () => _.anarray.dot( [ 1 ],1 ) );
    test.shouldThrowErrorSync( () => _.anarray.dot( [ 1 ],[ 1,2,3 ] ) );
    test.shouldThrowErrorSync( () => _.anarray.dot( [ 1 ],undefined ) );
    test.shouldThrowErrorSync( () => _.anarray.dot( [ 1 ],[ 1 ],1 ) );
    test.shouldThrowErrorSync( () => _.anarray.dot( [ 1 ],[ 1 ],[ 1 ] ) );
    test.shouldThrowErrorSync( () => _.anarray.dot( [],function(){} ) );

  }

  debugger;
}

//

function subarray( test )
{

  test.description = 'simplest'; //

  var v = vec([ 1,2,3 ]);
  test.identical( v.subarray( 0,2 ),vec([ 1,2 ]) );
  test.identical( v.subarray( 1,3 ),vec([ 2,3 ]) );

  test.description = 'subarray from vector with stride'; //

  var v = vector.fromSubArrayWithStride( [ -1,1,-2,2,-2,3 ],1,3,2 );
  test.identical( v.subarray( 0,2 ),vec([ 1,2 ]) );
  test.identical( v.subarray( 1,3 ),vec([ 2,3 ]) );

  test.description = 'get empty subarray'; //

  var v = vector.fromSubArrayWithStride( [ -1,1,-2,2,-2,3 ],1,3,2 );
  test.identical( v.subarray( 0,0 ),vec([]) );
  test.identical( v.subarray( 2,2 ),vec([]) );
  test.identical( v.subarray( 3,3 ),vec([]) );
  test.identical( v.subarray( 10,3 ),vec([]) );
  test.identical( v.subarray( 10,0 ),vec([]) );
  test.identical( v.subarray( 10,10 ),vec([]) );
  test.identical( v.subarray( 10,11 ),vec([]) );
  test.identical( v.subarray( -2,-2 ),vec([]) );
  test.identical( v.subarray( -2,-1 ),vec([]) );

  test.description = 'missing argument'; //

  test.identical( v.subarray( undefined,2 ),vec([ 1,2 ]) );
  test.identical( v.subarray( 1 ),vec([ 2,3 ]) );

  test.description = 'bad arguments'; //

  var v = vec([ 1,2,3 ]);
  test.shouldThrowErrorSync( () => v.subarray() );
  var v = vec([ 1,2,3 ]);
  test.shouldThrowErrorSync( () => v.subarray( 10,10,10 ) );

  // var v = vector.fromSubArrayWithStride( [ -1,1,-2,2,-2,3 ],1,3,2 );
  // test.shouldThrowErrorSync( () => v.subarray( -1,1 ) );
  //
  // var v = vec([ 1,2,3 ]);
  // test.shouldThrowErrorSync( () => v.subarray( -1,1 ) );
  //
  // var v = vector.fromSubArrayWithStride( [ -1,1,-2,2,-2,3 ],1,3,2 );
  // test.shouldThrowErrorSync( () => v.subarray( 10,10 ) );
  //
  // var v = vec([ 1,2,3 ]);
  // test.shouldThrowErrorSync( () => v.subarray( 10,10 ) );

  debugger;
}

//

function reduceToMinmax( test )
{

  var empty = [];
  var a = [ 1,2,3,4,5 ];
  var b = [ 55,22,33,99,2,22,3,33,4,99,5,44 ];
  var filter = ( e,o ) => !(e % 2);

  test.description = 'reduceToMinmax single element'; //

  var ar = [ 1 ];
  var expected =
  {
    min : { value : 1, index : 0, container : vec( ar ) },
    max : { value : 1, index : 0, container : vec( ar ) },
  };

  var got = _.anarray.reduceToMinmax( ar );
  test.identical( got,expected );

  test.description = 'reduceToMax single element'; //

  var ar = [ 1 ];
  var expected = { value : 1, index : 0, container : vec( ar ) };
  var got = _.anarray.reduceToMax( ar );
  test.identical( got,expected );

  var ar = [ 1 ];
  var expected = { value : 1, index : 0, container : vec( ar ) };
  var got = vector.reduceToMax( vec( ar ) );
  test.identical( got,expected );

  test.description = 'simplest'; //

  var expected =
  {
    min : { value : 1, index : 0, container : vec( a ) },
    max : { value : 5, index : 4, container : vec( a ) },
  };

  var got = _.anarray.reduceToMinmax( a );
  test.identical( got,expected );

  test.description = 'simplest case with filtering'; //

  var expected =
  {
    min : { value : 2, index : 1, container : vec( a ) },
    max : { value : 4, index : 3, container : vec( a ) },
  };

  var got = _.anarray.reduceToMinmaxFiltering( a,filter );
  test.identical( got,expected );

  test.description = 'several vectors'; //

  var expected =
  {
    min : { value : 1, index : 0, container : vec( a ) },
    max : { value : 99, index : 3, container : vec( b ) },
  };

  var got = _.anarray.reduceToMinmax( a,b );
  test.identical( got,expected );

  test.description = 'several vectors with filtering'; //

  var expected =
  {
    min : { value : 2, index : 1, container : vec( a ) },
    max : { value : 44, index : 11, container : vec( b ) },
  };

  var got = _.anarray.reduceToMinmaxFiltering( a,b,filter );
  test.identical( got,expected );

  test.description = 'empty array'; //

  var expected =
  {
    min : { value : NaN, index : -1, container : null },
    max : { value : NaN, index : -1, container : null },
  };
  var got = _.anarray.reduceToMinmax( empty );
  test.identical( got,expected )

  test.description = 'empty array with filtering'; //

  var expected =
  {
    min : { value : NaN, index : -1, container : null },
    max : { value : NaN, index : -1, container : null },
  };
  var got = _.anarray.reduceToMinmaxFiltering( empty,filter );
  test.identical( got,expected )

  test.description = 'no array'; //

  var expected =
  {
    min : { value : NaN, index : -1, container : null },
    max : { value : NaN, index : -1, container : null },
  };
  var got = _.anarray.reduceToMinmax();
  test.identical( got,expected )

  test.description = 'no array with filtering'; //

  var expected =
  {
    min : { value : NaN, index : -1, container : null },
    max : { value : NaN, index : -1, container : null },
  };
  var got = _.anarray.reduceToMinmaxFiltering( filter );
  test.identical( got,expected )

  test.description = 'bad arguments'; //

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmax( 1 ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmax( [ 1 ],1 ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmax( [ 1 ],undefined ) );

    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmaxFiltering( [ 1,2,3 ] ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmaxFiltering( [ 1,2,3 ],null ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmaxFiltering( [ 1,2,3 ],function(){} ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmaxFiltering( 1,filter ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmaxFiltering( [ 1 ],1,filter ) );
    test.shouldThrowErrorSync( () => _.anarray.reduceToMinmaxFiltering( [ 1 ],undefined,filter ) );

  }

}

//

function atomParrallelWithScalar( test )
{

  test.description = 'assignScalar'; //

  var dst = [ 1,2,3 ];
  _.anarray.assignScalar( dst,5 );
  test.identical( dst,[ 5,5,5 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.assignScalar( dst,5 );
  test.identical( dst,vec([ 5,5,5 ]) );

  var dst = [];
  _.anarray.assignScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'addScalar'; //

  var dst = [ 1,2,3 ];
  _.anarray.addScalar( dst,5 );
  test.identical( dst,[ 6,7,8 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.addScalar( dst,5 );
  test.identical( dst,vec([ 6,7,8 ]) );

  var dst = [];
  _.anarray.addScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'subScalar'; //

  var dst = [ 1,2,3 ];
  _.anarray.subScalar( dst,5 );
  test.identical( dst,[ -4,-3,-2 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.subScalar( dst,5 );
  test.identical( dst,vec([ -4,-3,-2 ]) );

  var dst = [];
  _.anarray.subScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'mulScalar'; //

  var dst = [ 1,2,3 ];
  _.anarray.mulScalar( dst,5 );
  test.identical( dst,[ 5,10,15 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.mulScalar( dst,5 );
  test.identical( dst,vec([ 5,10,15 ]) );

  var dst = [];
  _.anarray.mulScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'divScalar'; //

  var dst = [ 1,2,3 ];
  _.anarray.divScalar( dst,5 );
  test.identical( dst,[ 1/5,2/5,3/5 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.divScalar( dst,5 );
  test.identical( dst,vec([ 1/5,2/5,3/5 ]) );

  var dst = [];
  _.anarray.divScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'bad arguments'; //

  function shouldThrowError( name )
  {

    test.shouldThrowErrorSync( () => _.anarray[ name ]() );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( 1 ) );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( 1,3 ) );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( '1','3' ) );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( [],[] ) );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( [],1,3 ) );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( [],1,undefined ) );
    test.shouldThrowErrorSync( () => _.anarray[ name ]( [],undefined ) );

    test.shouldThrowErrorSync( () => _.vector[ name ]() );
    test.shouldThrowErrorSync( () => _.vector[ name ]( 1 ) );
    test.shouldThrowErrorSync( () => _.vector[ name ]( 1,3 ) );
    test.shouldThrowErrorSync( () => _.vector[ name ]( '1','3' ) );
    test.shouldThrowErrorSync( () => _.vector[ name ]( [],[] ) );
    test.shouldThrowErrorSync( () => _.vector[ name ]( [],1,3 ) );
    test.shouldThrowErrorSync( () => _.vector[ name ]( [],1,undefined ) );
    test.shouldThrowErrorSync( () => _.vector[ name ]( [],undefined ) );

  }

  if( Config.debug )
  {
    shouldThrowError( 'assignScalar' );
    shouldThrowError( 'addScalar' );
    shouldThrowError( 'subScalar' );
    shouldThrowError( 'mulScalar' );
    shouldThrowError( 'divScalar' );
  }

}

//

function atomParrallelOnlyVectors( test )
{

  test.description = 'addVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.anarray.addVectors( dst,src1 );
  test.identical( dst,[ 4,4,4 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.anarray.addVectors( dst,src1,src2 );
  test.identical( dst,[ 15,16,17 ] );

  test.description = 'addVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.anarray.addVectors( dst,src1 );
  test.identical( dst,vec([ 4,4,4 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.anarray.addVectors( dst,src1,src2 );
  test.identical( dst,vec([ 15,16,17 ]) );

  test.description = 'addVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.anarray.addVectors( dst,src1 );
  test.identical( dst,[ 4,4,4 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.anarray.addVectors( dst,src1,src2 );
  test.identical( dst,[ 15,16,17 ] );

  test.description = 'subVectors anarrays'; //

  var dst = ([ 1,2,3 ]);
  var src1 = ([ 3,2,1 ]);
  _.anarray.subVectors( dst,src1 );
  test.identical( dst,([ -2,0,+2 ]) );

  var dst = ([ 1,2,3 ]);
  var src1 = ([ 3,2,1 ]);
  var src2 = ([ 11,12,13 ]);
  _.anarray.subVectors( dst,src1,src2 );
  test.identical( dst,([ -13,-12,-11 ]) );

  test.description = 'subVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.anarray.subVectors( dst,src1 );
  test.identical( dst,vec([ -2,0,+2 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.anarray.subVectors( dst,src1,src2 );
  test.identical( dst,vec([ -13,-12,-11 ]) );

  test.description = 'mulVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.anarray.mulVectors( dst,src1 );
  test.identical( dst,vec([ 3,4,3 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.anarray.mulVectors( dst,src1,src2 );
  test.identical( dst,vec([ 33,48,39 ]) );

  test.description = 'mulVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.anarray.mulVectors( dst,src1 );
  test.identical( dst,[ 3,4,3 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.anarray.mulVectors( dst,src1,src2 );
  test.identical( dst,[ 33,48,39 ] );

  test.description = 'divVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.anarray.divVectors( dst,src1 );
  test.identical( dst,vec([ 1/3,1,3 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.anarray.divVectors( dst,src1,src2 );
  test.identical( dst,vec([ 1/3/11,1/12,3/13 ]) );

  test.description = 'divVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.anarray.divVectors( dst,src1 );
  test.identical( dst,[ 1/3,1,3 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.anarray.divVectors( dst,src1,src2 );
  test.identical( dst,[ 1/3/11,1/12,3/13 ] );

  test.description = 'minVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.anarray.minVectors( dst,src1 );
  test.identical( dst,vec([ 1,2,1 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,0,13 ]);
  _.anarray.minVectors( dst,src1,src2 );
  test.identical( dst,vec([ 1,0,1 ]) );

  test.description = 'minVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.anarray.minVectors( dst,src1 );
  test.identical( dst,[ 1,2,1 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,0,13 ];
  _.anarray.minVectors( dst,src1,src2 );
  test.identical( dst,[ 1,0,1 ] );

  test.description = 'maxVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.anarray.maxVectors( dst,src1 );
  test.identical( dst,vec([ 3,2,3 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,0,13 ]);
  _.anarray.maxVectors( dst,src1,src2 );
  test.identical( dst,vec([ 11,2,13 ]) );

  test.description = 'maxVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.anarray.maxVectors( dst,src1 );
  test.identical( dst,[ 3,2,3 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,0,13 ];
  _.anarray.maxVectors( dst,src1,src2 );
  test.identical( dst,[ 11,2,13 ] );

  test.description = 'empty vector'; //

  function checkEmptyVector( rname )
  {

    var dst = [];
    debugger;
    var got = _.anarray[ rname ]( dst,[],[] );
    test.shouldBe( got === dst );
    test.identical( got , [] );

    var dst = vec([]);
    var got = _.vector[ rname ]( dst,vec([]),vec([]) );
    test.shouldBe( got === dst );
    test.identical( got , vec([]) );

  }

  checkEmptyVector( 'assignVectors' );
  checkEmptyVector( 'addVectors' );
  checkEmptyVector( 'subVectors' );
  checkEmptyVector( 'mulVectors' );
  checkEmptyVector( 'subVectors' );
  checkEmptyVector( 'minVectors' );
  checkEmptyVector( 'maxVectors' );

  test.description = 'bad arguments'; //

  if( !Config.debug )
  return;

  function shouldThrowError( rname )
  {

    test.shouldThrowErrorSync( () => _.anarray[ rname ]() );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],[ 5 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],1 ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],undefined ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],'1' ) );

    test.shouldThrowErrorSync( () => _.vector[ rname ]() );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),vec([ 5 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),1 ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),undefined ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),'1' ) );

  }

  shouldThrowError( 'assignVectors' );
  shouldThrowError( 'addVectors' );
  shouldThrowError( 'subVectors' );
  shouldThrowError( 'mulVectors' );
  shouldThrowError( 'subVectors' );
  shouldThrowError( 'minVectors' );
  shouldThrowError( 'maxVectors' );

}

//

function atomNotParallel( test )
{

  test.description = 'addScaled vector,vector'; //

  var expected = [ 31,42,33 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 10,20,30 ];
  _.anarray.addScaled( dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ 31,42,33 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 10,20,30 ]);
  _.vector.addScaled( dst,src1,src2 );
  test.identical( dst,expected );

  test.description = 'subScaled vector,vector'; //

  var expected = [ -29,-38,-27 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 10,20,30 ];
  _.anarray.subScaled( dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ -29,-38,-27 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 10,20,30 ]);
  _.vector.subScaled( dst,src1,src2 );
  test.identical( dst,expected );

  test.description = 'mulScaled vector,vector'; //

  var expected = [ 30,80,90 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 10,20,30 ];
  _.anarray.mulScaled( dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ 30,80,90 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 10,20,30 ]);
  _.vector.mulScaled( dst,src1,src2 );
  test.identical( dst,expected );

  test.description = 'divScaled vector,vector'; //

  var expected = [ 1/30,2/40,3/30 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 10,20,30 ];
  _.anarray.divScaled( dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ 1/30,2/40,3/30 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 10,20,30 ]);
  _.vector.divScaled( dst,src1,src2 );
  test.identical( dst,expected );

  test.description = 'clamp vector,vector'; //

  var expected = [ 30,20,20,20,15,15 ];
  var dst = [ 10,20,10,30,30,15 ];
  var src1 = [ 30,20,20,20,10,10 ];
  var src2 = [ 40,20,20,20,15,15 ];
  _.anarray.clamp( dst,dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ 30,20,20,20,15,15 ]);
  var dst = vec([ 10,20,10,30,30,15 ]);
  var src1 = vec([ 30,20,20,20,10,10 ]);
  var src2 = vec([ 40,20,20,20,15,15 ]);
  debugger;
  _.vector.clamp( dst,dst,src1,src2 );
  test.identical( dst,expected );

  test.description = 'addScaled vector,scaler'; //

  var expected = [ 31,22,13 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = 10;
  _.anarray.addScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.anarray.addScaled( dst,src2,src1 );
  test.identical( dst,expected );

  var expected = vec([ 31,22,13 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = 10;
  _.vector.addScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = vec([ 1,2,3 ]);
  _.vector.addScaled( dst,src2,src1 );
  test.identical( dst,expected );

  test.description = 'subScaled vector,scaler'; //

  var expected = [ -29,-18,-7 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = 10;
  _.anarray.subScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.anarray.subScaled( dst,src2,src1 );
  test.identical( dst,expected );

  var expected = vec([ -29,-18,-7 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = 10;
  _.vector.subScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = vec([ 1,2,3 ]);
  _.vector.subScaled( dst,src2,src1 );
  test.identical( dst,expected );

  test.description = 'mulScaled vector,scaler'; //

  var expected = [ 30,40,30 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = 10;
  _.anarray.mulScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.anarray.mulScaled( dst,src2,src1 );
  test.identical( dst,expected );

  var expected = vec([ 30,40,30 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = 10;
  _.vector.mulScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = vec([ 1,2,3 ]);
  _.vector.mulScaled( dst,src2,src1 );
  test.identical( dst,expected );

  test.description = 'divScaled vector,scaler'; //

  var expected = [ 1/30,2/20,3/10 ];
  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = 10;
  _.anarray.divScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.anarray.divScaled( dst,src2,src1 );
  test.identical( dst,expected );

  var expected = vec([ 1/30,2/20,3/10 ]);
  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = 10;
  _.vector.divScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = vec([ 1,2,3 ]);
  _.vector.divScaled( dst,src2,src1 );
  test.identical( dst,expected );

  test.description = 'clamp vector,scaler'; //

  var expected = [ 20,20,20,20,20,15 ];
  var dst = [ 10,20,10,20,20,15 ];
  var src1 = [ 20,20,20,20,10,10 ];
  var src2 = 20;
  _.anarray.clamp( dst,dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ 20,20,20,20,20,15 ]);
  var dst = vec([ 10,20,10,20,20,15 ]);
  var src1 = vec([ 20,20,20,20,10,10 ]);
  var src2 = 20;
  _.vector.clamp( dst,dst,src1,src2 );
  test.identical( dst,expected );

  var expected = [ 15,20,15,20,15,15 ];
  var dst = [ 10,20,10,30,30,15 ];
  var src1 = 15;
  var src2 = [ 40,20,20,20,15,15 ];
  _.anarray.clamp( dst,dst,src1,src2 );
  test.identical( dst,expected );

  var expected = vec([ 15,20,15,20,15,15 ]);
  var dst = vec([ 10,20,10,30,30,15 ]);
  var src1 = 15;
  var src2 = vec([ 40,20,20,20,15,15 ]);
  _.vector.clamp( dst,dst,src1,src2 );
  test.identical( dst,expected );

  test.description = 'empty vector'; //

  function checkEmpty( rname )
  {

    var dst = [];
    var args = _.dup( [],_.vector[ rname ].takingArguments[ 0 ]-1 );
    args.unshift( dst );
    var got = _.anarray[ rname ].apply( _,args );
    test.shouldBe( got === dst );
    test.identical( got , [] );

    var dst = vec([]);
    var args = _.dup( vec([]),_.vector[ rname ].takingArguments[ 0 ]-1 );
    args.unshift( dst );
    var got = _.vector[ rname ].apply( _,args );
    test.shouldBe( got === dst );
    test.identical( got , vec([]) );

  }

  checkEmpty( 'addScaled' );
  checkEmpty( 'subScaled' );
  checkEmpty( 'mulScaled' );
  checkEmpty( 'subScaled' );
  checkEmpty( 'clamp' );

  test.description = 'bad arguments'; //

  if( !Config.debug )
  return;

  function shouldThrowError( rname )
  {

    test.shouldThrowErrorSync( () => _.anarray[ rname ]() );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],[ 5 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3 ],[ 5,5 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( 1,[ 3,3 ],[ 5,5 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],undefined ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],'1' ) );

    test.shouldThrowErrorSync( () => _.vector[ rname ]() );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),vec([ 5 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3 ]),vec([ 5,5 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( 1,vec([ 3,3 ]),vec([ 5,5 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),undefined ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),'1' ) );

  }

  shouldThrowError( 'addScaled' );
  shouldThrowError( 'subScaled' );
  shouldThrowError( 'mulScaled' );
  shouldThrowError( 'subScaled' );
  shouldThrowError( 'clamp' );

}

//

function bsphereFromBbox( test )
{

  test.description = 'simplest'; //

  var expected = [ 0.5,0.5,0.5,sqrt( 0.5 ) ];
  var bsphere = [ 0,0,0,0 ];
  var bbox = [ 0,0,0,1,1,1 ];

  _.anarray.bsphereFromBbox( bsphere,bbox );
  test.equivalent( bsphere,expected );

  var expected = vec( expected );
  var bsphere = vec([ 0,0,0,0 ]);
  var bbox = vec( bbox );

  _.vector.bsphereFromBbox( bsphere,bbox );
  test.equivalent( bsphere,expected );

  test.description = 'same sizes, different position'; //

  var expected = [ -2.5,0.5,5.5,sqrt( 0.5 ) ];
  var bsphere = [ 0,0,0,0 ];
  var bbox = [ -3,0,5,-2,1,6 ];

  _.anarray.bsphereFromBbox( bsphere,bbox );
  test.equivalent( bsphere,expected );

  var expected = vec( expected );
  var bsphere = vec([ 0,0,0,0 ]);
  var bbox = vec( bbox );

  _.vector.bsphereFromBbox( bsphere,bbox );
  test.equivalent( bsphere,expected );

  test.description = 'different sizes, different position'; //

  var expected = [ -2,0.5,7,sqrt( 5 ) ];
  var bsphere = [ 0,0,0,0 ];
  var bbox = [ -3,0,5,-1,1,9 ];

  _.anarray.bsphereFromBbox( bsphere,bbox );
  test.equivalent( bsphere,expected );

  var expected = vec( expected );
  var bsphere = vec([ 0,0,0,0 ]);
  var bbox = vec( bbox );

  _.vector.bsphereFromBbox( bsphere,bbox )
  test.equivalent( bsphere,expected );

  test.description = 'bad arguments'; //

  if( !Config.debug )
  return;

  function shouldThrowError( rname )
  {

    test.shouldThrowErrorSync( () => _.anarray[ rname ]() );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],[ 5 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],1 ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],undefined ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2 ],[ 3,4 ],'1' ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2,3,4 ],[ 1,2,3,4,5 ] ) );
    test.shouldThrowErrorSync( () => _.anarray[ rname ]( [ 1,2,3 ],[ 1,2,3,4,5,6 ] ) );

    test.shouldThrowErrorSync( () => _.vector[ rname ]() );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),vec([ 5 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),1 ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),undefined ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2 ]),vec([ 3,4 ]),'1' ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2,3,4 ]),vec([ 1,2,3,4,5 ]) ) );
    test.shouldThrowErrorSync( () => _.vector[ rname ]( vec([ 1,2,3 ]),vec([ 1,2,3,4,5,6 ]) ) );

  }

  shouldThrowError( 'bsphereFromBbox' );

  debugger;
}

//

function swap( test )
{

  test.description = 'swapVectors vectors'; //

  var v1 = vector.from([ 1,2,3 ]);
  var v2 = vector.from([ 10,20,30 ]);
  var v1Expected = vector.from([ 10,20,30 ]);
  var v2Expected = vector.from([ 1,2,3 ]);

  var r = vector.swapVectors( v1,v2 );

  test.shouldBe( r === undefined );
  test.identical( v1,v1Expected );
  test.identical( v2,v2Expected );

  test.description = 'swapVectors arrays'; //

  var v1 = [ 1,2,3 ];
  var v2 = [ 10,20,30 ];
  var v1Expected = [ 10,20,30 ];
  var v2Expected = [ 1,2,3 ];

  var r = anarray.swapVectors( v1,v2 );

  test.shouldBe( r === undefined );
  test.identical( v1,v1Expected );
  test.identical( v2,v2Expected );

  test.description = 'swapVectors empty arrays'; //

  var v1 = [];
  var v2 = [];
  var v1Expected = [];
  var v2Expected = [];

  var r = anarray.swapVectors( v1,v2 );

  test.shouldBe( r === undefined );
  test.identical( v1,v1Expected );
  test.identical( v2,v2Expected );

  test.description = 'swapAtoms vectors'; //

  var v1 = vector.from([ 1,2,3 ]);
  var v1Expected = vector.from([ 3,2,1 ]);
  var r = vector.swapAtoms( v1,0,2 );

  test.shouldBe( r === v1 );
  test.identical( v1,v1Expected );

  test.description = 'swapAtoms arrays'; //

  var v1 = [ 1,2,3 ];
  var v1Expected = [ 3,2,1 ];
  var r = anarray.swapAtoms( v1,0,2 );

  test.shouldBe( r === v1 );
  test.identical( v1,v1Expected );

  test.description = 'swapAtoms array with single atom'; //

  var v1 = [ 1 ];
  var v1Expected = [ 1 ];
  var r = anarray.swapAtoms( v1,0,0 );

  test.shouldBe( r === v1 );
  test.identical( v1,v1Expected );

  test.description = 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => vector.swapVectors() );
  test.shouldThrowErrorSync( () => vector.swapVectors( vector.from([ 1,2,3 ]) ) );
  test.shouldThrowErrorSync( () => vector.swapVectors( vector.from([ 1,2,3 ]), vector.from([ 1,2,3 ]), vector.from([ 1,2,3 ]) ) );
  test.shouldThrowErrorSync( () => vector.swapVectors( vector.from([ 1,2,3 ]), vector.from([ 1,2 ]) ) );
  test.shouldThrowErrorSync( () => vector.swapVectors( vector.from([ 1,2,3 ]), [ 1,2,3 ] ) );
  test.shouldThrowErrorSync( () => vector.swapVectors( [ 1,2,3 ], [ 1,2,3 ] ) );

  test.shouldThrowErrorSync( () => vector.swapAtoms() );
  test.shouldThrowErrorSync( () => vector.swapAtoms( vector.from([ 1,2,3 ]) ) );
  test.shouldThrowErrorSync( () => vector.swapAtoms( vector.from([ 1,2,3 ]),0 ) );
  test.shouldThrowErrorSync( () => vector.swapAtoms( vector.from([ 1,2,3 ]),0,+3 ) );
  test.shouldThrowErrorSync( () => vector.swapAtoms( vector.from([ 1,2,3 ]),0,-1 ) );
  test.shouldThrowErrorSync( () => vector.swapAtoms( vector.from([ 1,2,3 ]),'0','1' ) );
  test.shouldThrowErrorSync( () => vector.swapAtoms( vector.from([ 1,2,3 ]),[ 0 ],[ 1 ] ) );

}

//

function polynomApply( test )
{

  test.description = 'simple'; //

  debugger;

  var expected = 7;
  var got = _.anarray.polynomApply( [ 1,1,1 ],2 );
  test.identical( got,expected );

  test.description = 'simple'; //

  var expected = 20;
  var got = _.anarray.polynomApply( [ 0,1,2 ],4 );
  test.identical( got,expected );

}

// --
// proto
// --

var Self =
{

  name : 'VectorTest',
  verbosity : 7,
  debug : 1,

  tests :
  {

    // vectorIs : vectorIs,
    // to : to,
    //
    // sort : sort,
    // dot : dot,
    // subarray : subarray,
    // reduceToMinmax : reduceToMinmax,
    //
    // atomParrallelWithScalar : atomParrallelWithScalar,
    // atomParrallelOnlyVectors : atomParrallelOnlyVectors,
    // atomNotParallel : atomNotParallel,
    //
    // bsphereFromBbox : bsphereFromBbox,
    // swap : swap,

    polynomApply : polynomApply,

  },

};

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

} )( );
