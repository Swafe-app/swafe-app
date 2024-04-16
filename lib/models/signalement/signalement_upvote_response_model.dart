class SignalementUpVoteResponse {
  final int upVote;

  SignalementUpVoteResponse({
    required this.upVote,
  });

  factory SignalementUpVoteResponse.fromJson(Map<String, dynamic> json) {
    return SignalementUpVoteResponse(
      upVote: json['upVote'],
    );
  }
}
