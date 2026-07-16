// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alac_converter_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlacAudioMetadata {

 int get sampleRate; int get channels; int get bitDepth; BigInt get durationSamples; double get durationSeconds;
/// Create a copy of AlacAudioMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlacAudioMetadataCopyWith<AlacAudioMetadata> get copyWith => _$AlacAudioMetadataCopyWithImpl<AlacAudioMetadata>(this as AlacAudioMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlacAudioMetadata&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.durationSamples, durationSamples) || other.durationSamples == durationSamples)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,sampleRate,channels,bitDepth,durationSamples,durationSeconds);

@override
String toString() {
  return 'AlacAudioMetadata(sampleRate: $sampleRate, channels: $channels, bitDepth: $bitDepth, durationSamples: $durationSamples, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $AlacAudioMetadataCopyWith<$Res>  {
  factory $AlacAudioMetadataCopyWith(AlacAudioMetadata value, $Res Function(AlacAudioMetadata) _then) = _$AlacAudioMetadataCopyWithImpl;
@useResult
$Res call({
 int sampleRate, int channels, int bitDepth, BigInt durationSamples, double durationSeconds
});




}
/// @nodoc
class _$AlacAudioMetadataCopyWithImpl<$Res>
    implements $AlacAudioMetadataCopyWith<$Res> {
  _$AlacAudioMetadataCopyWithImpl(this._self, this._then);

  final AlacAudioMetadata _self;
  final $Res Function(AlacAudioMetadata) _then;

/// Create a copy of AlacAudioMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sampleRate = null,Object? channels = null,Object? bitDepth = null,Object? durationSamples = null,Object? durationSeconds = null,}) {
  return _then(_self.copyWith(
sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,durationSamples: null == durationSamples ? _self.durationSamples : durationSamples // ignore: cast_nullable_to_non_nullable
as BigInt,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AlacAudioMetadata].
extension AlacAudioMetadataPatterns on AlacAudioMetadata {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlacAudioMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlacAudioMetadata() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlacAudioMetadata value)  $default,){
final _that = this;
switch (_that) {
case _AlacAudioMetadata():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlacAudioMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _AlacAudioMetadata() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sampleRate,  int channels,  int bitDepth,  BigInt durationSamples,  double durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlacAudioMetadata() when $default != null:
return $default(_that.sampleRate,_that.channels,_that.bitDepth,_that.durationSamples,_that.durationSeconds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sampleRate,  int channels,  int bitDepth,  BigInt durationSamples,  double durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _AlacAudioMetadata():
return $default(_that.sampleRate,_that.channels,_that.bitDepth,_that.durationSamples,_that.durationSeconds);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sampleRate,  int channels,  int bitDepth,  BigInt durationSamples,  double durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _AlacAudioMetadata() when $default != null:
return $default(_that.sampleRate,_that.channels,_that.bitDepth,_that.durationSamples,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _AlacAudioMetadata implements AlacAudioMetadata {
  const _AlacAudioMetadata({required this.sampleRate, required this.channels, required this.bitDepth, required this.durationSamples, required this.durationSeconds});
  

@override final  int sampleRate;
@override final  int channels;
@override final  int bitDepth;
@override final  BigInt durationSamples;
@override final  double durationSeconds;

/// Create a copy of AlacAudioMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlacAudioMetadataCopyWith<_AlacAudioMetadata> get copyWith => __$AlacAudioMetadataCopyWithImpl<_AlacAudioMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlacAudioMetadata&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.durationSamples, durationSamples) || other.durationSamples == durationSamples)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,sampleRate,channels,bitDepth,durationSamples,durationSeconds);

@override
String toString() {
  return 'AlacAudioMetadata(sampleRate: $sampleRate, channels: $channels, bitDepth: $bitDepth, durationSamples: $durationSamples, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$AlacAudioMetadataCopyWith<$Res> implements $AlacAudioMetadataCopyWith<$Res> {
  factory _$AlacAudioMetadataCopyWith(_AlacAudioMetadata value, $Res Function(_AlacAudioMetadata) _then) = __$AlacAudioMetadataCopyWithImpl;
@override @useResult
$Res call({
 int sampleRate, int channels, int bitDepth, BigInt durationSamples, double durationSeconds
});




}
/// @nodoc
class __$AlacAudioMetadataCopyWithImpl<$Res>
    implements _$AlacAudioMetadataCopyWith<$Res> {
  __$AlacAudioMetadataCopyWithImpl(this._self, this._then);

  final _AlacAudioMetadata _self;
  final $Res Function(_AlacAudioMetadata) _then;

/// Create a copy of AlacAudioMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sampleRate = null,Object? channels = null,Object? bitDepth = null,Object? durationSamples = null,Object? durationSeconds = null,}) {
  return _then(_AlacAudioMetadata(
sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,durationSamples: null == durationSamples ? _self.durationSamples : durationSamples // ignore: cast_nullable_to_non_nullable
as BigInt,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
