class Artist {
  String artistId;
  String dateTimeStarted;

  Artist({required this.artistId, required this.dateTimeStarted});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
        artistId: json['artist_id'],
        dateTimeStarted: json['date_time_started']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artist_id'] = this.artistId;
    data['date_time_started'] = this.dateTimeStarted;
    return data;
  }
}