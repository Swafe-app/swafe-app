enum ReportingType {
  insecurite(title: 'Insecurité',pin: 'assets/images/insecurite.png',threat: 'assets/images/lowDangerPin.svg'),
  violence(title: 'Violence',pin: 'assets/images/violence.png',threat: 'assets/images/midDangerPin.svg'),
  vol(title:'Vol',pin: 'assets/images/vol.png',threat: 'assets/images/lowDangerPin.svg'),
  harcelement(title: 'Harcèlement',pin: 'assets/images/harcelement.png',threat: 'assets/images/midDangerPin.svg'),
  agression(title: 'Agression',pin: 'assets/images/agression.png', threat: 'assets/images/lowDangerPin.svg'),
  agressionSexuelle(title: 'Agression Sexuelle',pin: '',threat: 'assets/images/midDangerPin.svg'),
  incendie(title: 'Incendie',pin: '',threat: 'assets/images/highDangerPin.svg'),
  attentat(title: 'Attentat',pin: '',threat: 'assets/images/highDangerPin.svg'),
  meteorologique(title: 'Métérologique',pin: '',threat: 'assets/images/highDangerPin.svg');
  const ReportingType({
    required this.pin,
    required this.threat,
    required this.title,
  });

  final String pin;
  final String threat;
  final String title;
}
  ReportingType convertStringToReportingType(String reportingTypeString) {
    switch (reportingTypeString) {
      case 'Insecurité':
        return ReportingType.insecurite;
    // Default value for unrecognized types
      case 'Violence':
        return ReportingType.violence;
      case 'Vol':
        return ReportingType.vol;
      case 'Harcèlement':
        return ReportingType.harcelement;
      case 'Agression':
        return ReportingType.agression;
      case 'Agression Sexuelle':
        return ReportingType.agressionSexuelle;
      case 'Incendie':
        return ReportingType.incendie;
      case 'Attentat':
        return ReportingType.attentat;
      case 'Météorologique':
        return ReportingType.meteorologique;
      default:
        return ReportingType.vol;
    }
  }
