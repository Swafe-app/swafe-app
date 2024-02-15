String getErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'invalid-email':
      return 'L\'adresse e-mail fournie est mal formatée.';
    case 'user-disabled':
      return 'Ce compte utilisateur a été désactivé.';
    case 'user-not-found':
      return 'Aucun utilisateur trouvé avec cet e-mail.';
    case 'wrong-password':
      return 'Le mot de passe est incorrect.';
    case 'email-already-in-use':
      return 'Cette adresse e-mail est déjà utilisée par un autre compte.';
    case 'operation-not-allowed':
      return 'L\'opération n\'est pas autorisée.';
    case 'weak-password':
      return 'Le mot de passe fourni est trop faible.';
    case 'too-many-requests':
      return 'Nous avons détecté trop de requêtes. Veuillez réessayer plus tard.';
    case 'network-request-failed':
      return 'Échec de la connexion réseau. Vérifiez votre connexion Internet.';
    case 'requires-recent-login':
      return 'Cette opération est sensible et nécessite une authentification récente. Veuillez vous reconnecter avant de réessayer.';
    default:
      return 'Une erreur inattendue s\'est produite. Veuillez réessayer plus tard.';
  }
}
