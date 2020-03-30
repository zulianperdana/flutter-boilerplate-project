///cart model
class Device extends Object{
  const Device({
    this.deviceId,
    this.version,
    this.buildNumber
 });
  final String deviceId;
  final String version;
  final String buildNumber;

  

 String get appVersion => version+' ('+buildNumber+')';
}