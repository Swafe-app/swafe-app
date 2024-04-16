class SignalementDownVoteResponse {
  final int downVote;

  SignalementDownVoteResponse({
    required this.downVote,
  });

  factory SignalementDownVoteResponse.fromJson(Map<String, dynamic> json) {
    return SignalementDownVoteResponse(
      downVote: json['downVote'],
    );
  }
}
