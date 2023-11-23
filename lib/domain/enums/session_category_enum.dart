enum SessionCategoryEnum {
  fullBody(text: "Full Body", source: 'assets/png/category_full_body.png'),
  upperBody(text: "Upper Body", source: 'assets/png/category_upper_body.png'),
  lowerBody(text: "Lower Body", source: 'assets/png/category_lower_body.png'),
  hips(text: "Hips", source: 'assets/png/category_hips.png');

  final String text;
  final String source;

  const SessionCategoryEnum({required this.text, required this.source});
}
