class Hadith {
  final String text;
  final String source;
  final String number;
  final String reference;

  Hadith({
    required this.text,
    required this.source,
    required this.number,
    required this.reference,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    // API structure varies, adapting to likely simple schema
    // Typically: { "hadithnumber": ..., "text": ..., "reference": ... }
    return Hadith(
      text: json['text'] as String? ?? '',
      source: 'Sahih Bukhari', // Source is implicit from the endpoint
      number: json['hadithnumber']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
    );
  }
}
