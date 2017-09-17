( function _aVector_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  //if( typeof wBase === 'undefined' )
  try
  {
    require( '../../Base.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wTesting' );

  require( '../cvector/cVector.s' );
  require( '../cvector/vAvector.s' );

}

//

var _ = wTools.withArray.Float32;
var Space = _.Space;
var vector = _.vector;
var vec = _.vector.fromArray;
var avector = _.avector;
var sqrt = _.sqrt;

var Parent = wTools.Tester;

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

function isFinite( test )
{

  test.identical( _.avector.isFinite([ 1,2,3 ]),true );
  test.identical( _.avector.isFinite([ 0,0,0 ]),true );
  test.identical( _.avector.isFinite([ 0,0,1 ]),true );

  test.identical( _.avector.isFinite([ 1,3,NaN ]),false );
  test.identical( _.avector.isFinite([ 1,NaN,3 ]),false );
  test.identical( _.avector.isFinite([ 1,3,-Infinity ]),false );
  test.identical( _.avector.isFinite([ 1,+Infinity,3 ]),false );

  test.identical( _.avector.isFinite([ 1.1,0,1 ]),true );
  test.identical( _.avector.isFinite([ 1,0,1.1 ]),true );

}

//

function isNan( test )
{

  test.identical( _.avector.isNan([ 1,2,3 ]),false );
  test.identical( _.avector.isNan([ 0,0,0 ]),false );
  test.identical( _.avector.isNan([ 0,0,1 ]),false );

  test.identical( _.avector.isNan([ 1,3,NaN ]),true );
  test.identical( _.avector.isNan([ 1,NaN,3 ]),true );
  test.identical( _.avector.isNan([ 1,3,-Infinity ]),false );
  test.identical( _.avector.isNan([ 1,+Infinity,3 ]),false );

  test.identical( _.avector.isNan([ 1.1,0,1 ]),false );
  test.identical( _.avector.isNan([ 1,0,1.1 ]),false );

}

//

function isInt( test )
{

  test.identical( _.avector.isInt([ 1,2,3 ]),true );
  test.identical( _.avector.isInt([ 0,0,0 ]),true );
  test.identical( _.avector.isInt([ 0,0,1 ]),true );

  test.identical( _.avector.isInt([ 1,3,NaN ]),false );
  test.identical( _.avector.isInt([ 1,NaN,3 ]),false );
  test.identical( _.avector.isInt([ 1,3,-Infinity ]),true );
  test.identical( _.avector.isInt([ 1,+Infinity,3 ]),true );

  test.identical( _.avector.isInt([ 1.1,0,1 ]),false );
  test.identical( _.avector.isInt([ 1,0,1.1 ]),false );

}

//

function isZero( test )
{

  test.identical( _.avector.isZero([ 1,2,3 ]),false );
  test.identical( _.avector.isZero([ 0,0,0 ]),true );
  test.identical( _.avector.isZero([ 0,0,1 ]),false );

  test.identical( _.avector.isZero([ 0,3,NaN ]),false );
  test.identical( _.avector.isZero([ 0,NaN,3 ]),false );
  test.identical( _.avector.isZero([ 0,3,-Infinity ]),false );
  test.identical( _.avector.isZero([ 0,+Infinity,3 ]),false );

  test.identical( _.avector.isZero([ 1.1,0,1 ]),false );
  test.identical( _.avector.isZero([ 1,0,1.1 ]),false );

}

//

function to( test )
{

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

    /*_.arrayFillTimes( [], 16 ).map( function(){ return Math.floor( Math.random() * 16 ) } ),*/

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

  var a = [ 1,2,3,4 ];
  var b = [ 6,7,8,9 ];

  var or1 = [ 3,1,5 ];
  var or2 = [ -1,3,0 ];

  test.description = 'anrarrays'; //

  var expected = 80;
  var got = _.avector.dot( a,b );
  test.identical( got,expected )

  test.description = 'orthogonal anrarrays'; //

  var expected = 0;
  var got = _.avector.dot( or1,or2 );
  test.identical( got,expected )

  test.description = 'empty anarrays'; //

  var expected = 0;
  var got = _.avector.dot( [],[] );
  test.identical( got,expected )

  test.description = 'empty vectors'; //

  var expected = 0;
  var got = _.avector.dot( vec([]),vec([]) );
  test.identical( got,expected )

  test.description = 'sub vectors'; //

  var av = _.vector.fromSubArray( a,1,3 );
  var bv = _.vector.fromSubArray( b,1,3 );
  var expected = 74;
  var got = _.avector.dot( av,bv );
  test.identical( got,expected );

  test.description = 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.avector.dot( 1 ) );
  test.shouldThrowErrorSync( () => _.avector.dot( [ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.avector.dot( [ 1 ],[ 1,2,3 ] ) );
  test.shouldThrowErrorSync( () => _.avector.dot( [ 1 ],undefined ) );
  test.shouldThrowErrorSync( () => _.avector.dot( [ 1 ],[ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.avector.dot( [ 1 ],[ 1 ],[ 1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.dot( [],function(){} ) );

  debugger;
}

//

function cross( test )
{
  debugger;

  test.description = 'trivial, make new'; //

  var a = [ 1,2,3 ];
  var b = [ 4,5,6 ];
  var expected = [ -3,+6,-3 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'zero, make new'; //

  var a = [ 0,0,0 ];
  var b = [ 0,0,0 ];
  var expected = [ 0,0,0 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'same, make new'; //

  var a = [ 1,1,1 ];
  var b = [ 1,1,1 ];
  var expected = [ 0,0,0 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'perpendicular1, make new'; //

  var a = [ 1,0,0 ];
  var b = [ 0,0,1 ];
  var expected = [ 0,-1,0 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'perpendicular2, make new'; //

  var a = [ 0,0,1 ];
  var b = [ 1,0,0 ];
  var expected = [ 0,+1,0 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'perpendicular3, make new'; //

  var a = [ 1,0,0 ];
  var b = [ 0,1,0 ];
  var expected = [ 0,0,+1 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'perpendicular4, make new'; //

  var a = [ 0,1,0 ];
  var b = [ 1,0,0 ];
  var expected = [ 0,0,-1 ];
  var got = _.avector.cross( null,a,b );
  test.identical( got,expected );
  test.shouldBe( got !== a );

  test.description = 'trivial'; ///

  var a = [ 1,2,3 ];
  var b = [ 4,5,6 ];
  var expected = [ -3,+6,-3 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'zero'; //

  var a = [ 0,0,0 ];
  var b = [ 0,0,0 ];
  var expected = [ 0,0,0 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'same'; //

  var a = [ 1,1,1 ];
  var b = [ 1,1,1 ];
  var expected = [ 0,0,0 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular1'; //

  var a = [ 1,0,0 ];
  var b = [ 0,0,1 ];
  var expected = [ 0,-1,0 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular2'; //

  var a = [ 0,0,1 ];
  var b = [ 1,0,0 ];
  var expected = [ 0,+1,0 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular3'; //

  var a = [ 1,0,0 ];
  var b = [ 0,1,0 ];
  var expected = [ 0,0,+1 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular4'; //

  var a = [ 0,1,0 ];
  var b = [ 1,0,0 ];
  var expected = [ 0,0,-1 ];
  var got = _.avector.cross( a,b );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'trivial'; ///

  var a = [ 1,2,3 ];
  var b = [ 4,5,6 ];
  var c = [ 7,8,9 ];
  var expected = [ 78,6,-66 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'zero'; //

  var a = [ 0,0,0 ];
  var b = [ 0,0,0 ];
  var c = [ 7,8,9 ];
  var expected = [ 0,0,0 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'same'; //

  var a = [ 1,1,1 ];
  var b = [ 1,1,1 ];
  var c = [ 7,8,9 ];
  var expected = [ 0,0,0 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular1'; //

  var a = [ 1,0,0 ];
  var b = [ 0,0,1 ];
  var c = [ 7,8,9 ];
  var expected = [ -9,0,7 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular2'; //

  var a = [ 0,0,1 ];
  var b = [ 1,0,0 ];
  var c = [ 7,8,9 ];
  var expected = [ 9,0,-7 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular3'; //

  var a = [ 1,0,0 ];
  var b = [ 0,1,0 ];
  var c = [ 7,8,9 ];
  var expected = [ -8,7,0 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'perpendicular4'; //

  var a = [ 0,1,0 ];
  var b = [ 1,0,0 ];
  var c = [ 7,8,9 ];
  var expected = [ 8,-7,0 ];
  var got = _.avector.cross( a,b,c );
  test.identical( got,expected );
  test.shouldBe( got === a );

  test.description = 'bad arguments'; ///

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.avector.cross( 1 ) );
  test.shouldThrowErrorSync( () => _.avector.cross( [ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.avector.cross( [ 1 ],[ 1,2,3 ] ) );
  test.shouldThrowErrorSync( () => _.avector.cross( undefined,[ 1,2,3 ],[ 1,2,3 ] ) );
  test.shouldThrowErrorSync( () => _.avector.cross( null,[ 1,2,3 ] ) );
  test.shouldThrowErrorSync( () => _.avector.cross( [ 1 ],undefined ) );
  test.shouldThrowErrorSync( () => _.avector.cross( [ 1 ],[ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.avector.cross( [ 1 ],[ 1 ],[ 1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.cross( [],function(){} ) );

}

//

function subarray( test )
{

  test.description = 'trivial'; //

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

function add( test )
{

  test.description = 'vector vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.add( null,ins1,ins2 );

  test.identical( got,[ 4,6,8 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.add( null,ins1,ins2,ins3 );

  test.identical( got,[ 14,26,38 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.add( null,ins1,ins2 );

  test.identical( got,[ 11,12,13 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.add( null,ins1,ins2,ins3 );

  test.identical( got,[ 21,32,43 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.add( null,ins1,ins2 );

  test.identical( got,[ 11,12,13 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.add( null,ins1,ins2,ins3 );

  test.identical( got,[ 21,32,43 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar, new dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.add( null,ins1,ins2 );

  test.identical( got,11 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar scalar, new dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.add( null,ins1,ins2,ins3 );

  test.identical( got,111 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector, first argument is dst'; ///

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.add( ins1,ins2 );

  test.identical( got,[ 4,6,8 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'vector vector vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.add( ins1,ins2,ins3 );

  test.identical( got,[ 14,26,38 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.add( ins1,ins2 );

  test.identical( got,[ 11,12,13 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.add( ins1,ins2,ins3 );

  test.identical( got,[ 21,32,43 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.add( ins1,ins2 );

  test.identical( got,[ 11,12,13 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.add( ins1,ins2,ins3 );

  test.identical( got,[ 21,32,43 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'scalar scalar, first argument is dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.add( ins1,ins2 );

  test.identical( got,11 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  test.description = 'scalar scalar scalar, first argument is dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.add( ins1,ins2,ins3 );

  test.identical( got,111 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  if( !Config.debug )
  return;

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.avector.add( [ 1,2,3 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.add( [ 1,2,3 ],[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.add( '1',[ 3,4,5 ],null ) );

  test.shouldThrowErrorSync( () => _.avector.add( [ 0,0,0 ],[ 1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.add( [ 0,0 ],[ 1,1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.add( [ 0 ],[ 1,1,1 ] ) );

}

//

function sub( test )
{

  test.description = 'vector vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.sub( null,ins1,ins2 );

  test.identical( got,[ -2,-2,-2 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.sub( null,ins1,ins2,ins3 );

  test.identical( got,[ -12,-22,-32 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.sub( null,ins1,ins2 );

  test.identical( got,[ -9,-8,-7 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.sub( null,ins1,ins2,ins3 );

  test.identical( got,[ -19,-28,-37 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.sub( null,ins1,ins2 );

  test.identical( got,[ 9,8,7 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.sub( null,ins1,ins2,ins3 );

  test.identical( got,[ -1,-12,-23 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar, new dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.sub( null,ins1,ins2 );

  test.identical( got,-9 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar scalar, new dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.sub( null,ins1,ins2,ins3 );

  test.identical( got,-109 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector, first argument is dst'; ///

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.sub( ins1,ins2 );

  test.identical( got,[ -2,-2,-2 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'vector vector vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.sub( ins1,ins2,ins3 );

  test.identical( got,[ -12,-22,-32 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.sub( ins1,ins2 );

  test.identical( got,[ -9,-8,-7 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.sub( ins1,ins2,ins3 );

  test.identical( got,[ -19,-28,-37 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.sub( ins1,ins2 );

  test.identical( got,[ 9,8,7 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.sub( ins1,ins2,ins3 );

  test.identical( got,[ -1,-12,-23 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'scalar scalar, first argument is dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.sub( ins1,ins2 );

  test.identical( got,-9 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  test.description = 'scalar scalar scalar, first argument is dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.sub( ins1,ins2,ins3 );

  test.identical( got,-109 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  if( !Config.debug )
  return;

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.avector.sub( [ 1,2,3 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.sub( [ 1,2,3 ],[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.sub( '1',[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.sub( [ 0,0,0 ],[ 1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.sub( [ 0,0 ],[ 1,1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.sub( [ 0 ],[ 1,1,1 ] ) );

}

//

function mul( test )
{

  test.description = 'vector vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.mul( null,ins1,ins2 );

  test.identical( got,[ 3,8,15 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.mul( null,ins1,ins2,ins3 );

  test.identical( got,[ 30,160,450 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.mul( null,ins1,ins2 );

  test.identical( got,[ 10,20,30 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.mul( null,ins1,ins2,ins3 );

  test.identical( got,[ 100,400,900 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.mul( null,ins1,ins2 );

  test.identical( got,[ 10,20,30 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.mul( null,ins1,ins2,ins3 );

  test.identical( got,[ 100,400,900 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar, new dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.mul( null,ins1,ins2 );

  test.identical( got,10 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar scalar, new dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.mul( null,ins1,ins2,ins3 );

  test.identical( got,1000 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector, first argument is dst'; ///

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.mul( ins1,ins2 );

  test.identical( got,[ 3,8,15 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'vector vector vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.mul( ins1,ins2,ins3 );

  test.identical( got,[ 30,160,450 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.mul( ins1,ins2 );

  test.identical( got,[ 10,20,30 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.mul( ins1,ins2,ins3 );

  test.identical( got,[ 100,400,900 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.mul( ins1,ins2 );

  test.identical( got,[ 10,20,30 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.mul( ins1,ins2,ins3 );

  test.identical( got,[ 100,400,900 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'scalar scalar, first argument is dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.mul( ins1,ins2 );

  test.identical( got,10 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  test.description = 'scalar scalar scalar, first argument is dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.mul( ins1,ins2,ins3 );

  test.identical( got,1000 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  if( !Config.debug )
  return;

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.avector.mul( [ 1,2,3 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.mul( [ 1,2,3 ],[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.mul( '1',[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.mul( [ 0,0,0 ],[ 1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.mul( [ 0,0 ],[ 1,1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.mul( [ 0 ],[ 1,1,1 ] ) );

}

//

function div( test )
{

  test.description = 'vector vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.div( null,ins1,ins2 );

  test.identical( got,[ 1/3,2/4,3/5 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.div( null,ins1,ins2,ins3 );

  test.identical( got,[ 1/3/10,2/4/20,3/5/30 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.div( null,ins1,ins2 );

  test.identical( got,[ 1/10,2/10,3/10 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.div( null,ins1,ins2,ins3 );

  test.identical( got,[ 1/10/10,2/10/20,3/10/30 ] );
  test.identical( ins1,[ 1,2,3 ] );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar vector, new dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.div( null,ins1,ins2 );

  test.identical( got,[ 10/1,10/2,10/3 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'vector scalar vector, new dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.div( null,ins1,ins2,ins3 );

  test.identical( got,[ 10/1/10,10/2/20,10/3/30 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar, new dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.div( null,ins1,ins2 );

  test.identical( got,1/10 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'scalar scalar scalar, new dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.div( null,ins1,ins2,ins3 );

  test.identical( got,1/10/100 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );
  test.shouldBe( got !== ins1 );

  test.description = 'vector vector, first argument is dst'; ///

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];

  var got = _.avector.div( ins1,ins2 );

  test.identical( got,[ 1/3,2/4,3/5 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'vector vector vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = [ 3,4,5 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.div( ins1,ins2,ins3 );

  test.identical( got,[ 1/3/10,2/4/20,3/5/30 ] );
  test.identical( ins2,[ 3,4,5 ] );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;

  var got = _.avector.div( ins1,ins2 );

  test.identical( got,[ 1/10,2/10,3/10 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = [ 1,2,3 ];
  var ins2 = 10;
  var ins3 = [ 10,20,30 ];

  var got = _.avector.div( ins1,ins2,ins3 );

  test.identical( got,[ 1/10/10,2/10/20,3/10/30 ] );
  test.identical( ins2,10 );
  test.shouldBe( got === ins1 );

  test.description = 'scalar vector, first argument is dst'; //

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];

  var got = _.avector.div( ins1,ins2 );

  test.identical( got,[ 10/1,10/2,10/3 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'vector scalar vector, first argument is dst'; /* */

  var ins1 = 10;
  var ins2 = [ 1,2,3 ];
  var ins3 = [ 10,20,30 ];

  var got = _.avector.div( ins1,ins2,ins3 );

  test.identical( got,[ 10/1/10,10/2/20,10/3/30 ] );
  test.identical( ins1,10 );
  test.identical( ins2,[ 1,2,3 ] );

  test.description = 'scalar scalar, first argument is dst'; //

  var ins1 = 1;
  var ins2 = 10;

  var got = _.avector.div( ins1,ins2 );

  test.identical( got,1/10 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  test.description = 'scalar scalar scalar, first argument is dst'; /* */

  var ins1 = 1;
  var ins2 = 10;
  var ins3 = 100;

  var got = _.avector.div( ins1,ins2,ins3 );

  test.identical( got,1/10/100 );
  test.identical( ins1,1 );
  test.identical( ins2,10 );

  if( !Config.debug )
  return;

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.avector.div( [ 1,2,3 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.div( [ 1,2,3 ],[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.div( '1',[ 3,4,5 ],null ) );
  test.shouldThrowErrorSync( () => _.avector.div( [ 0,0,0 ],[ 1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.div( [ 0,0 ],[ 1,1,1 ] ) );
  test.shouldThrowErrorSync( () => _.avector.div( [ 0 ],[ 1,1,1 ] ) );

}

//

function mix( test )
{

  test.description = 'trivial';

  var src = [ 1,2,3 ];
  var got = _.avector.mix( src,5,0.1 );
  var expected = [ 1.4 , 2.3 , 3.2 ];

  test.equivalent( got,expected );
  test.shouldBe( src === got );

  var src = [ 1,2,3 ]
  var got = _.avector.mix( 5,src,0.1 );
  var expected = [ 4.6 , 4.7 , 4.8 ];

  test.equivalent( got,expected );
  test.shouldBe( src !== got );

  test.description = 'many elements in progress';

  var got = _.avector.mix( 1,3,[ -1,0,0.3,0.7,1,2 ] );
  var expected = [ -1 , 1 , 1.6 , 2.4 , 3 , 5 ];
  test.equivalent( got,expected );

  test.description = 'only scalars';

  var got = _.avector.mix( 1,3,0.5 );
  var expected = 2;
  test.equivalent( got,expected );

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.avector.mix( [ 1,2 ],[ 3 ],0.5 ) );

  test.shouldThrowErrorSync( () => _.avector.mix() );
  test.shouldThrowErrorSync( () => _.avector.mix( [ 1,2 ] ) );
  test.shouldThrowErrorSync( () => _.avector.mix( [ 1,2 ],[ 3,4 ] ) );
  test.shouldThrowErrorSync( () => _.avector.mix( [ 1,2 ],[ 3,4 ],[ 5,6 ],1 ) );
  test.shouldThrowErrorSync( () => _.avector.mix( '0',[ 3,4 ],[ 5,6 ] ) );
  test.shouldThrowErrorSync( () => _.avector.mix( [ 1,2 ],'0',[ 5,6 ] ) );
  test.shouldThrowErrorSync( () => _.avector.mix( [ 1,2 ],[ 3,4 ],'0' ) );

}

//

function distributionRangeSummary( test )
{

  var empty = [];
  var a = [ 1,2,3,4,5 ];
  var b = [ 55,22,33,99,2,22,3,33,4,99,5,44 ];
  var filter = ( e,o ) => !(e % 2);

  test.description = 'distributionRangeSummary single element'; //

  var ar = [ 1 ];
  var expected =
  {
    min : { value : 1, index : 0, container : vec( ar ) },
    max : { value : 1, index : 0, container : vec( ar ) },
    median : 1,
  };

  var got = _.avector.distributionRangeSummary( ar );
  test.identical( got,expected );

  test.description = 'reduceToMax single element'; //

  var ar = [ 1 ];
  var expected = { value : 1, index : 0, container : vec( ar ) };
  var got = _.avector.reduceToMax( ar );
  test.identical( got,expected );

  var ar = [ 1 ];
  var expected = { value : 1, index : 0, container : vec( ar ) };
  var got = vector.reduceToMax( vec( ar ) );
  test.identical( got,expected );

  test.description = 'trivial'; //

  var expected =
  {
    min : { value : 1, index : 0, container : vec( a ) },
    max : { value : 5, index : 4, container : vec( a ) },
    median : 3,
  };

  var got = _.avector.distributionRangeSummary( a );
  test.identical( got,expected );

  test.description = 'simplest case with filtering'; //

  var expected =
  {
    min : { value : 2, index : 1, container : vec( a ) },
    max : { value : 4, index : 3, container : vec( a ) },
    median : 3,
  };

  var got = _.avector.distributionRangeSummaryFiltering( a,filter );
  test.identical( got,expected );

  test.description = 'several vectors'; //

  var expected =
  {
    min : { value : 1, index : 0, container : vec( a ) },
    max : { value : 99, index : 3, container : vec( b ) },
    median : 50,
  };

  var got = _.avector.distributionRangeSummary( a,b );
  test.identical( got,expected );

  test.description = 'several vectors with filtering'; //

  var expected =
  {
    min : { value : 2, index : 1, container : vec( a ) },
    max : { value : 44, index : 11, container : vec( b ) },
    median : 23,
  };

  var got = _.avector.distributionRangeSummaryFiltering( a,b,filter );
  test.identical( got,expected );

  test.description = 'empty array'; //

  var expected =
  {
    min : { value : NaN, index : -1, container : null },
    max : { value : NaN, index : -1, container : null },
    median : NaN,
  };
  var got = _.avector.distributionRangeSummary( empty );
  test.identical( got,expected )

  test.description = 'empty array with filtering'; //

  var expected =
  {
    min : { value : NaN, index : -1, container : null },
    max : { value : NaN, index : -1, container : null },
    median : NaN,
  };
  var got = _.avector.distributionRangeSummaryFiltering( empty,filter );
  test.identical( got,expected )

  // test.description = 'no array'; //
  //
  // var expected =
  // {
  //   min : { value : NaN, index : -1, container : null },
  //   max : { value : NaN, index : -1, container : null },
  // };
  // var got = _.avector.distributionRangeSummary();
  // test.identical( got,expected )
  //
  // test.description = 'no array with filtering'; //
  //
  // var expected =
  // {
  //   min : { value : NaN, index : -1, container : null },
  //   max : { value : NaN, index : -1, container : null },
  // };
  // var got = _.avector.distributionRangeSummaryFiltering( filter );
  // test.identical( got,expected )

  test.description = 'bad arguments'; //

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummary() );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummary( 1 ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummary( '1' ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummary( [ 1 ],1 ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummary( [ 1 ],undefined ) );

    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering() );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering( [ 1,2,3 ] ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering( [ 1,2,3 ],null ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering( [ 1,2,3 ],() => true ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering( 1,filter ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering( [ 1 ],1,filter ) );
    test.shouldThrowErrorSync( () => _.avector.distributionRangeSummaryFiltering( [ 1 ],undefined,filter ) );

  }

}

//

function reduceToMean( test )
{

  test.description = 'simple even'; //

  var expected = 2.5;
  var got = _.avector.reduceToMean([ 1,2,3,4 ]);
  test.equivalent( got,expected );

  test.description = 'simple odd'; //

  var expected = 2;
  var got = _.avector.reduceToMean([ 1,2,3 ]);
  test.equivalent( got,expected );

  test.description = 'several vectors'; //

  var expected = 3;
  var got = _.avector.reduceToMean( [ 1,2,3 ],[ 4,5 ] );
  test.equivalent( got,expected );

  test.description = 'empty'; //

  var expected = NaN;
  var got = _.avector.reduceToMean([]);
  test.equivalent( got,expected );

  test.description = 'simple even, filtering'; //

  var expected = 2;
  debugger;
  var got = _.avector.reduceToMeanFiltering( [ 1,2,3,4 ],( e,op ) => e % 2 );
  debugger;
  test.equivalent( got,expected );

  test.description = 'simple odd, filtering'; //

  var expected = 2;
  var got = _.avector.reduceToMeanFiltering( [ 1,2,3 ],( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'several vectors, filtering'; //

  var expected = 3;
  var got = _.avector.reduceToMeanFiltering( [ 1,2,3 ],[ 4,5 ],( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'empty, filtering'; //

  var expected = NaN;
  var got = _.avector.reduceToMeanFiltering( [],( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.avector.reduceToMean() );
  test.shouldThrowErrorSync( () => _.avector.reduceToMean( 'x' ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMean( 1 ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMean( [ 1 ],'x' ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMean( [ 1 ],1 ) );

  test.shouldThrowErrorSync( () => _.avector.reduceToMeanFiltering() );
  test.shouldThrowErrorSync( () => _.avector.reduceToMeanFiltering( () => true ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMeanFiltering( 'x',() => true ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMeanFiltering( 1,() => true ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMeanFiltering( [ 1 ],'x',() => true ) );
  test.shouldThrowErrorSync( () => _.avector.reduceToMeanFiltering( [ 1 ],1,() => true ) );

}

//

function median( test )
{

  test.description = 'simple even'; //

  var expected = 5;
  var got = _.avector.median([ 1,2,3,9 ]);
  test.equivalent( got,expected );

  test.description = 'simple odd'; //

  var expected = 5;
  var got = _.avector.median([ 1,2,9 ]);
  test.equivalent( got,expected );

  test.description = 'empty'; //

  var expected = NaN;
  var got = _.avector.median([]);
  test.equivalent( got,expected );

}

//

function mean( test )
{

  test.description = 'simple even'; //

  var expected = 2.5;
  var got = _.avector.mean([ 1,2,3,4 ]);
  test.equivalent( got,expected );

  test.description = 'simple odd'; //

  var expected = 2;
  var got = _.avector.mean([ 1,2,3 ]);
  test.equivalent( got,expected );

  test.description = 'empty'; //

  var expected = 0;
  var got = _.avector.mean([]);
  test.equivalent( got,expected );

  test.description = 'simple even, filtering'; //

  var expected = 2;
  var got = _.avector.meanFiltering( [ 1,2,3,4 ],( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'simple odd, filtering'; //

  var expected = 2;
  var got = _.avector.meanFiltering( [ 1,2,3 ],( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'empty, filtering'; //

  var expected = 0;
  var got = _.avector.meanFiltering( [],( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.mean() );
  test.shouldThrowErrorSync( () => _.mean( 'x' ) );
  test.shouldThrowErrorSync( () => _.mean( 1 ) );
  test.shouldThrowErrorSync( () => _.mean( [ 1 ],'x' ) );
  test.shouldThrowErrorSync( () => _.mean( [ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.mean( [ 1 ],[ 1 ] ) );
  test.shouldThrowErrorSync( () => _.mean( [ 1 ],[ 1 ] ) );

  test.shouldThrowErrorSync( () => _.meanFiltering() );
  test.shouldThrowErrorSync( () => _.meanFiltering( () => true ) );
  test.shouldThrowErrorSync( () => _.meanFiltering( 'x',() => true ) );
  test.shouldThrowErrorSync( () => _.meanFiltering( 1,() => true ) );
  test.shouldThrowErrorSync( () => _.meanFiltering( [ 1 ],'x',() => true ) );
  test.shouldThrowErrorSync( () => _.meanFiltering( [ 1 ],1,() => true ) );
  test.shouldThrowErrorSync( () => _.meanFiltering( [ 1 ],[ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.meanFiltering( [ 1 ],[ 1 ],() => true ) );

}

//

function moment( test )
{
  debugger;

  test.description = 'first even'; //

  var expected = 2.5;
  var got = _.avector.moment( [ 1,2,3,4 ],1 );
  test.equivalent( got,expected );

  test.description = 'first odd'; //

  var expected = 2;
  var got = _.avector.moment( [ 1,2,3 ],1 );
  test.equivalent( got,expected );

  test.description = 'first empty'; //

  var expected = 0;
  var got = _.avector.moment( [],1 );
  test.equivalent( got,expected );

  test.description = 'second even'; //

  var expected = 30 / 4;
  var got = _.avector.moment( [ 1,2,3,4 ],2 );
  test.equivalent( got,expected );

  test.description = 'second odd'; //

  var expected = 14 / 3;
  var got = _.avector.moment( [ 1,2,3 ],2 );
  test.equivalent( got,expected );

  test.description = 'second empty'; //

  var expected = 0;
  var got = _.avector.moment( [],2 );
  test.equivalent( got,expected );

  test.description = 'simple even, filtering'; //

  var expected = 5;
  var got = _.avector.momentFiltering( [ 1,2,3,4 ],2,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'simple odd, filtering'; //

  var expected = 5;
  var got = _.avector.momentFiltering( [ 1,2,3 ],2,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'empty, filtering'; //

  var expected = 0;
  var got = _.avector.momentFiltering( [],2,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.moment() );
  test.shouldThrowErrorSync( () => _.moment( [ 1 ] ) );
  test.shouldThrowErrorSync( () => _.moment( 1 ) );
  test.shouldThrowErrorSync( () => _.moment( 'x',1 ) );
  test.shouldThrowErrorSync( () => _.moment( 1,1 ) );
  test.shouldThrowErrorSync( () => _.moment( [ 1 ],'x' ) );
  test.shouldThrowErrorSync( () => _.moment( [ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.moment( [ 1 ],[ 1 ] ) );
  test.shouldThrowErrorSync( () => _.moment( [ 1 ],[ 1 ] ) );

  test.shouldThrowErrorSync( () => _.momentFiltering() );
  test.shouldThrowErrorSync( () => _.momentFiltering( () => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( [ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( 1 ),() => true );
  test.shouldThrowErrorSync( () => _.momentFiltering( 'x',1,() => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( 1,1,() => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( [ 1 ],'x',() => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( 1,[ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( [ 1 ],[ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentFiltering( [ 1 ],[ 1 ],() => true ) );

}

//

function momentCentral( test )
{

  test.description = 'first even'; //

  var expected = 0;
  var got = _.avector.momentCentral( [ 1,2,3,4 ],1,2.5 );
  test.equivalent( got,expected );

  test.description = 'first odd'; //

  var expected = 0;
  var got = _.avector.momentCentral( [ 1,2,3 ],1,2 );
  test.equivalent( got,expected );

  test.description = 'first empty'; //

  var expected = 0;
  var got = _.avector.momentCentral( [],1,0 );
  test.equivalent( got,expected );

  test.description = 'second even'; //

  var expected = 5 / 4;
  var got = _.avector.momentCentral( [ 1,2,3,4 ],2,2.5 );
  test.equivalent( got,expected );

  test.description = 'second odd'; //

  var expected = 2 / 3;
  debugger;
  var got = _.avector.momentCentral( [ 1,2,3 ],2,2 );
  test.equivalent( got,expected );

  test.description = 'second empty'; //

  var expected = 0;
  var got = _.avector.momentCentral( [],2,0 );
  test.equivalent( got,expected );

  test.description = 'first even'; //

  var expected = 0;
  var got = _.avector.momentCentral( [ 1,2,3,4 ],1 );
  test.equivalent( got,expected );

  test.description = 'first odd'; //

  var expected = 0;
  var got = _.avector.momentCentral( [ 1,2,3 ],1 );
  test.equivalent( got,expected );

  test.description = 'first empty'; //

  var expected = 0;
  var got = _.avector.momentCentral( [],1 );
  test.equivalent( got,expected );

  test.description = 'second even'; //

  var expected = 5 / 4;
  var got = _.avector.momentCentral( [ 1,2,3,4 ],2 );
  test.equivalent( got,expected );

  test.description = 'second odd'; //

  var expected = 2 / 3;
  debugger;
  var got = _.avector.momentCentral( [ 1,2,3 ],2 );
  test.equivalent( got,expected );

  test.description = 'second empty'; //

  var expected = 0;
  var got = _.avector.momentCentral( [],2 );
  test.equivalent( got,expected );

  test.description = 'first even, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentral( [ 1,2,3,4 ],1,null );
  test.equivalent( got,expected );

  test.description = 'first odd, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentral( [ 1,2,3 ],1,null );
  test.equivalent( got,expected );

  test.description = 'first empty, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentral( [],1,null );
  test.equivalent( got,expected );

  test.description = 'second even, with mean : null'; //

  var expected = 5 / 4;
  var got = _.avector.momentCentral( [ 1,2,3,4 ],2,null );
  test.equivalent( got,expected );

  test.description = 'second odd, with mean : null'; //

  var expected = 2 / 3;
  debugger;
  var got = _.avector.momentCentral( [ 1,2,3 ],2,null );
  test.equivalent( got,expected );

  test.description = 'second empty, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentral( [],2,null );
  test.equivalent( got,expected );

  test.description = 'first even, filtering'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [ 1,2,3,4 ],1,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'first odd, filtering'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [ 1,2,3 ],1,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'first empty, filtering'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [],1,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'second even, filtering'; //

  var expected = 1;
  var got = _.avector.momentCentralFiltering( [ 1,2,3,4 ],2,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'second odd, filtering'; //

  var expected = 1;
  var got = _.avector.momentCentralFiltering( [ 1,2,3 ],2,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'second empty, filtering'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [],2,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'first even, filtering, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [ 1,2,3,4 ],1,null,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'first odd, filtering, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [ 1,2,3 ],1,null,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'first empty, filtering, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [],1,null,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'second even, filtering, with mean : null'; //

  var expected = 1;
  var got = _.avector.momentCentralFiltering( [ 1,2,3,4 ],2,null,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'second odd, filtering, with mean : null'; //

  var expected = 1;
  var got = _.avector.momentCentralFiltering( [ 1,2,3 ],2,null,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'second empty, filtering, with mean : null'; //

  var expected = 0;
  var got = _.avector.momentCentralFiltering( [],2,null,( e,op ) => e % 2 );
  test.equivalent( got,expected );

  test.description = 'bad arguments'; //

  test.shouldThrowErrorSync( () => _.momentCentral() );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ] ) );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ],'1' ) );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ],[ 1 ] ) );
  test.shouldThrowErrorSync( () => _.momentCentral( 1 ) );
  test.shouldThrowErrorSync( () => _.momentCentral( 'x',1 ) );
  test.shouldThrowErrorSync( () => _.momentCentral( 1,1 ) );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ],'x' ) );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ],1 ) );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ],[ 1 ] ) );
  test.shouldThrowErrorSync( () => _.momentCentral( [ 1 ],[ 1 ] ) );

  test.shouldThrowErrorSync( () => _.momentCentralFiltering() );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( () => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( [ 1 ],'1',() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( [ 1 ],[ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( [ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( 1 ),() => true );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( 'x',1,() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( 1,1,() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( [ 1 ],'x',() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( 1,[ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( [ 1 ],[ 1 ],() => true ) );
  test.shouldThrowErrorSync( () => _.momentCentralFiltering( [ 1 ],[ 1 ],() => true ) );

}

//

function atomParrallelWithScalar( test )
{

  test.description = 'assignScalar'; //

  var dst = [ 1,2,3 ];
  _.avector.assignScalar( dst,5 );
  test.identical( dst,[ 5,5,5 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.assignScalar( dst,5 );
  test.identical( dst,vec([ 5,5,5 ]) );

  var dst = [];
  _.avector.assignScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'addScalar'; //

  var dst = [ 1,2,3 ];
  _.avector.addScalar( dst,5 );
  test.identical( dst,[ 6,7,8 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.addScalar( dst,5 );
  test.identical( dst,vec([ 6,7,8 ]) );

  var dst = [];
  _.avector.addScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'subScalar'; //

  var dst = [ 1,2,3 ];
  _.avector.subScalar( dst,5 );
  test.identical( dst,[ -4,-3,-2 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.subScalar( dst,5 );
  test.identical( dst,vec([ -4,-3,-2 ]) );

  var dst = [];
  _.avector.subScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'mulScalar'; //

  var dst = [ 1,2,3 ];
  _.avector.mulScalar( dst,5 );
  test.identical( dst,[ 5,10,15 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.mulScalar( dst,5 );
  test.identical( dst,vec([ 5,10,15 ]) );

  var dst = [];
  _.avector.mulScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'divScalar'; //

  var dst = [ 1,2,3 ];
  _.avector.divScalar( dst,5 );
  test.identical( dst,[ 1/5,2/5,3/5 ] );

  var dst = vec([ 1,2,3 ]);
  _.vector.divScalar( dst,5 );
  test.identical( dst,vec([ 1/5,2/5,3/5 ]) );

  var dst = [];
  _.avector.divScalar( dst,5 );
  test.identical( dst,[] );

  test.description = 'bad arguments'; //

  function shouldThrowError( name )
  {

    test.shouldThrowErrorSync( () => _.avector[ name ]() );
    test.shouldThrowErrorSync( () => _.avector[ name ]( 1 ) );
    // test.shouldThrowErrorSync( () => _.avector[ name ]( 1,3 ) );
    test.shouldThrowErrorSync( () => _.avector[ name ]( '1','3' ) );
    test.shouldThrowErrorSync( () => _.avector[ name ]( [],[] ) );
    test.shouldThrowErrorSync( () => _.avector[ name ]( [],1,3 ) );
    test.shouldThrowErrorSync( () => _.avector[ name ]( [],1,undefined ) );
    test.shouldThrowErrorSync( () => _.avector[ name ]( [],undefined ) );

    test.shouldThrowErrorSync( () => _.vector[ name ]() );
    test.shouldThrowErrorSync( () => _.vector[ name ]( 1 ) );
    // test.shouldThrowErrorSync( () => _.vector[ name ]( 1,3 ) );
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
  _.avector.addVectors( dst,src1 );
  test.identical( dst,[ 4,4,4 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.avector.addVectors( dst,src1,src2 );
  test.identical( dst,[ 15,16,17 ] );

  test.description = 'addVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.avector.addVectors( dst,src1 );
  test.identical( dst,vec([ 4,4,4 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.avector.addVectors( dst,src1,src2 );
  test.identical( dst,vec([ 15,16,17 ]) );

  test.description = 'addVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.avector.addVectors( dst,src1 );
  test.identical( dst,[ 4,4,4 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.avector.addVectors( dst,src1,src2 );
  test.identical( dst,[ 15,16,17 ] );

  test.description = 'subVectors anarrays'; //

  var dst = ([ 1,2,3 ]);
  var src1 = ([ 3,2,1 ]);
  _.avector.subVectors( dst,src1 );
  test.identical( dst,([ -2,0,+2 ]) );

  var dst = ([ 1,2,3 ]);
  var src1 = ([ 3,2,1 ]);
  var src2 = ([ 11,12,13 ]);
  _.avector.subVectors( dst,src1,src2 );
  test.identical( dst,([ -13,-12,-11 ]) );

  test.description = 'subVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.avector.subVectors( dst,src1 );
  test.identical( dst,vec([ -2,0,+2 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.avector.subVectors( dst,src1,src2 );
  test.identical( dst,vec([ -13,-12,-11 ]) );

  test.description = 'mulVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.avector.mulVectors( dst,src1 );
  test.identical( dst,vec([ 3,4,3 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.avector.mulVectors( dst,src1,src2 );
  test.identical( dst,vec([ 33,48,39 ]) );

  test.description = 'mulVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.avector.mulVectors( dst,src1 );
  test.identical( dst,[ 3,4,3 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.avector.mulVectors( dst,src1,src2 );
  test.identical( dst,[ 33,48,39 ] );

  test.description = 'divVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.avector.divVectors( dst,src1 );
  test.identical( dst,vec([ 1/3,1,3 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,12,13 ]);
  _.avector.divVectors( dst,src1,src2 );
  test.identical( dst,vec([ 1/3/11,1/12,3/13 ]) );

  test.description = 'divVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.avector.divVectors( dst,src1 );
  test.identical( dst,[ 1/3,1,3 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,12,13 ];
  _.avector.divVectors( dst,src1,src2 );
  test.identical( dst,[ 1/3/11,1/12,3/13 ] );

  test.description = 'minVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.avector.minVectors( dst,src1 );
  test.identical( dst,vec([ 1,2,1 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,0,13 ]);
  _.avector.minVectors( dst,src1,src2 );
  test.identical( dst,vec([ 1,0,1 ]) );

  test.description = 'minVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.avector.minVectors( dst,src1 );
  test.identical( dst,[ 1,2,1 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,0,13 ];
  _.avector.minVectors( dst,src1,src2 );
  test.identical( dst,[ 1,0,1 ] );

  test.description = 'maxVectors vectors'; //

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  _.avector.maxVectors( dst,src1 );
  test.identical( dst,vec([ 3,2,3 ]) );

  var dst = vec([ 1,2,3 ]);
  var src1 = vec([ 3,2,1 ]);
  var src2 = vec([ 11,0,13 ]);
  _.avector.maxVectors( dst,src1,src2 );
  test.identical( dst,vec([ 11,2,13 ]) );

  test.description = 'maxVectors anarrays'; //

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  _.avector.maxVectors( dst,src1 );
  test.identical( dst,[ 3,2,3 ] );

  var dst = [ 1,2,3 ];
  var src1 = [ 3,2,1 ];
  var src2 = [ 11,0,13 ];
  _.avector.maxVectors( dst,src1,src2 );
  test.identical( dst,[ 11,2,13 ] );

  test.description = 'empty vector'; //

  function checkEmptyVector( rname )
  {

    var dst = [];
    debugger;
    var got = _.avector[ rname ]( dst,[],[] );
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

    test.shouldThrowErrorSync( () => _.avector[ rname ]() );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],[ 5 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],1 ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],undefined ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],'1' ) );

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
  _.avector.addScaled( dst,src1,src2 );
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
  _.avector.subScaled( dst,src1,src2 );
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
  _.avector.mulScaled( dst,src1,src2 );
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
  _.avector.divScaled( dst,src1,src2 );
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
  _.avector.clamp( dst,dst,src1,src2 );
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
  _.avector.addScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.avector.addScaled( dst,src2,src1 );
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
  _.avector.subScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.avector.subScaled( dst,src2,src1 );
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
  _.avector.mulScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.avector.mulScaled( dst,src2,src1 );
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
  _.avector.divScaled( dst,src1,src2 );
  test.identical( dst,expected );
  var dst = [ 1,2,3 ];
  _.avector.divScaled( dst,src2,src1 );
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
  _.avector.clamp( dst,dst,src1,src2 );
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
  _.avector.clamp( dst,dst,src1,src2 );
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
    var op = _.vector[ rname ].operation;

    var dst = [];
    var args = _.dup( [],op.takingArguments[ 0 ]-1 );
    args.unshift( dst );
    var got = _.avector[ rname ].apply( _,args );
    test.shouldBe( got === dst );
    test.identical( got , [] );

    var dst = vec([]);
    var args = _.dup( vec([]),op.takingArguments[ 0 ]-1 );
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

    test.shouldThrowErrorSync( () => _.avector[ rname ]() );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],[ 5 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3 ],[ 5,5 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( 1,[ 3,3 ],[ 5,5 ] ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],undefined ) );
    test.shouldThrowErrorSync( () => _.avector[ rname ]( [ 1,2 ],[ 3,4 ],'1' ) );

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

  var r = avector.swapVectors( v1,v2 );

  test.shouldBe( r === undefined );
  test.identical( v1,v1Expected );
  test.identical( v2,v2Expected );

  test.description = 'swapVectors empty arrays'; //

  var v1 = [];
  var v2 = [];
  var v1Expected = [];
  var v2Expected = [];

  var r = avector.swapVectors( v1,v2 );

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
  var r = avector.swapAtoms( v1,0,2 );

  test.shouldBe( r === v1 );
  test.identical( v1,v1Expected );

  test.description = 'swapAtoms array with single atom'; //

  var v1 = [ 1 ];
  var v1Expected = [ 1 ];
  var r = avector.swapAtoms( v1,0,0 );

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

  test.description = 'trivial'; //

  var expected = 7;
  var got = _.avector.polynomApply( [ 1,1,1 ],2 );
  test.identical( got,expected );

  test.description = 'trivial'; //

  var expected = 36;
  var got = _.avector.polynomApply( [ 0,1,2 ],4 );
  test.identical( got,expected );

  test.description = 'trivial'; //

  var expected = 6;
  var got = _.avector.polynomApply( [ 2,1,0 ],4 );
  test.identical( got,expected );

  test.description = 'trivial'; //

  var expected = 262;
  var got = _.avector.polynomApply( [ 2,1,0,4 ],4 );
  test.identical( got,expected );

}

//

function set( test )
{

  test.description = 'set scalar';

  var src = [ 1,2,3 ];
  var got = _.avector.assign( src,0 );
  var expected = [ 0,0,0 ];
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'set scalar to null vector';

  var src = [];
  var got = _.avector.assign( src,1 );
  var expected = [];
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'set avector';

  var src = [ 1,2,3 ];
  var got = _.avector.assign( src,[ 4,5,6 ] );
  var expected = [ 4,5,6 ];
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'set multiple scalars';

  var src = [ 1,2,3 ];
  var got = _.avector.assign( src,4,5,6 );
  var expected = [ 4,5,6 ];
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'null avector';

  var src = [];
  var got = _.avector.assign( src );
  var expected = [];
  test.identical( expected,got );
  test.shouldBe( got === src );

  /* */

  test.description = 'assign scalar by method';

  var src = vector.fromArray([ 1,2,3 ]);
  debugger;
  var got = src.assign( 0 );
  var expected = vector.fromArray([ 0,0,0 ]);
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'assign scalar to null vector';

  var src = vector.fromArray([]);
  var got = src.assign( 1 );
  var expected = vector.fromArray([]);
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'assign avector';

  var src = vector.fromArray([ 1,2,3 ]);
  var got = src.assign([ 4,5,6 ] );
  var expected = vector.fromArray([ 4,5,6 ]);
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'assign multiple scalars';

  var src = vector.fromArray([ 1,2,3 ]);
  var got = src.assign([ 4,5,6 ]);
  var expected = vector.fromArray([ 4,5,6 ]);
  test.identical( expected,got );
  test.shouldBe( got === src );

  test.description = 'null avector';

  var src = vector.fromArray([]);
  var got = src.assign();
  var expected = vector.fromArray([]);
  test.identical( expected,got );
  test.shouldBe( got === src );

  /* */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.avector.assign() );
  test.shouldThrowErrorSync( () => _.avector.assign( [],1,1 ) );
  test.shouldThrowErrorSync( () => _.avector.assign( [ 0 ],1,1 ) );
  test.shouldThrowErrorSync( () => _.avector.assign( [ 0 ],'1' ) );
  test.shouldThrowErrorSync( () => _.avector.assign( [ 0 ],[ 1,1 ] ) );

}

//

function experiment( test )
{

  var summary = _.avector.distributionSummary([ 1,2,3,4,9 ]);
  logger.log( 'summary',summary );

  debugger;
  test.identical( 1,1 );
}

experiment.experimental = 1;

// --
// proto
// --

var Self =
{

  name : 'VectorTest',
  silencing : 1,
  // routine : 'set',
  // verbosity : 7,
  // debug : 1,

  tests :
  {

    vectorIs : vectorIs,

    isFinite : isFinite,
    isNan : isNan,
    isInt : isInt,
    isZero : isZero,

    to : to,

    sort : sort,
    dot : dot,
    cross : cross,
    subarray : subarray,

    add : add,
    sub : sub,
    mul : mul,
    div : div,

    mix : mix,

    distributionRangeSummary : distributionRangeSummary,
    reduceToMean : reduceToMean,
    median : median,
    mean : mean,
    moment : moment,
    momentCentral : momentCentral,

    atomParrallelWithScalar : atomParrallelWithScalar,
    atomParrallelOnlyVectors : atomParrallelOnlyVectors,
    atomNotParallel : atomNotParallel,

    swap : swap,
    polynomApply : polynomApply,

    set : set,

    experiment : experiment,

  },

};

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
