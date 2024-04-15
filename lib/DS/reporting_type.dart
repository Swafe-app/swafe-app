import 'package:swafe/models/signalement/signalement_model.dart';

enum ReportingType {
  insecurite(
      title: 'Je me fais suivre',
      pin: 'assets/images/insecurite.png',
      threat: 'assets/images/lowDangerPin.svg'),
  violence(
      title: 'Violence physique',
      pin: 'assets/images/violence.png',
      threat: 'assets/images/midDangerPin.svg'),
  violenceVerbale(
      title: 'Violence verbale',
      pin: 'assets/images/agressionVerbale.png',
      threat: 'assets/images/lowDangerPin.svg'),
  vol(
      title: 'Vol',
      pin: 'assets/images/vol.png',
      threat: 'assets/images/lowDangerPin.svg'),
  harcelement(
      title: 'Harcèlement',
      pin: 'assets/images/harcelement.png',
      threat: 'assets/images/midDangerPin.svg'),
  agressionSexuelle(
      title: 'Agression Sexuelle',
      pin: 'assets/images/agression.png',
      threat: 'assets/images/midDangerPin.svg'),
  incendie(
      title: 'Incendie',
      pin: 'assets/images/incendie.png',
      threat: 'assets/images/highDangerPin.svg'),
  meteo(
      title: 'Météo',
      pin: 'assets/images/meteo.png',
      threat: 'assets/images/lowDangerPin.svg'),
  travaux(
      title: 'Travaux',
      pin: 'assets/images/travaux.png',
      threat: 'assets/images/lowDangerPin.svg'),
  feuPieton(
      title: 'Feu de pieton dysfonctionnel',
      pin: 'assets/images/feuPieton.png',
      threat: 'assets/images/lowDangerPin.svg'),
  eclairage(
      title: 'Mauvais éclairage',
      pin: 'assets/images/light.png',
      threat: 'assets/images/signalement_point.svg'),
  autre(
      title: 'Autre',
      pin: 'assets/images/autreReport.png',
      threat: 'assets/images/lowDangerPin.svg');

  const ReportingType({
    required this.pin,
    required this.threat,
    required this.title,
  });

  final String pin;
  final String threat;
  final String title;
}

ReportingType convertStringToReportingType(
    SignalementDangerItemsEnum reportingTypeEnum) {
  switch (reportingTypeEnum) {
    case SignalementDangerItemsEnum.jeMeFaisSuivre:
      return ReportingType.insecurite;
    // Default value for unrecognized types
    case SignalementDangerItemsEnum.agressionPhysique:
      return ReportingType.violence;
    case SignalementDangerItemsEnum.agressionVerbale:
       return ReportingType.violenceVerbale;
    case SignalementDangerItemsEnum.vol:
      return ReportingType.vol;
    case SignalementDangerItemsEnum.harcelement:
      return ReportingType.harcelement;
    case SignalementDangerItemsEnum.agressionSexuelle:
      return ReportingType.agressionSexuelle;
      case SignalementDangerItemsEnum.incendie:
       return ReportingType.incendie;
     case SignalementDangerItemsEnum.meteo:
       return ReportingType.meteo;
     case SignalementDangerItemsEnum.travaux:
       return ReportingType.travaux;
     case SignalementDangerItemsEnum.feuDePietonDysfonctionnel:
       return ReportingType.feuPieton;
     case SignalementDangerItemsEnum.mauvaisEclairage:
       return ReportingType.eclairage;
    default:
      return ReportingType.autre;
  }
}
