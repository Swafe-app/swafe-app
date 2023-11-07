enum ReportingType {
  insecurite(pin: '',threat: 'assets/images/lowDangerPin.svg'),
  violence(pin: '',threat: 'assets/images/midDangerPin.svg'),
  vol(pin: '',threat: 'assets/images/lowDangerPin.svg'),
  harcelement(pin: '',threat: 'assets/images/midDangerPin.svg'),
  agressionSexuelle(pin: '',threat: 'assets/images/midDangerPin.svg'),
  incendie(pin: '',threat: 'assets/images/highDangerPin.svg'),
  attentat(pin: '',threat: 'assets/images/highDangerPin.svg'),
  meteorologique(pin: '',threat: 'assets/images/highDangerPin.svg');
  const ReportingType({
    required this.pin,
    required this.threat,
  });

  final String pin;
  final String threat;
}
  ReportingType convertStringToReportingType(String reportingTypeString) {
    switch (reportingTypeString) {
      case 'insecurite':
        return ReportingType.insecurite;
    // Default value for unrecognized types
      case 'violence':
        return ReportingType.violence;
      case 'vol':
        return ReportingType.vol;
      case 'harcelement':
        return ReportingType.harcelement;
      case 'agressionSexuelle':
        return ReportingType.agressionSexuelle;
      case 'incendie':
        return ReportingType.incendie;
      case 'attentat':
        return ReportingType.attentat;
      case 'meteorologique':
        return ReportingType.meteorologique;
      default:
        return ReportingType.vol;
    }
  }
