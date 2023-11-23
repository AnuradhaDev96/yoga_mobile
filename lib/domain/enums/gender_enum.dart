enum GenderEnum {
  male(dtoValue: 'male', text: "Male"),
  female(dtoValue: 'female', text: "Female"),
  other(dtoValue: 'other', text: "Other");

  final String dtoValue;
  final String text;

  const GenderEnum({required this.dtoValue, required this.text});
}
