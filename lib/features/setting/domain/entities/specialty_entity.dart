class SpecialtyEntity {
  final int id;
  final String title;

  const SpecialtyEntity({
    required this.id,
    required this.title,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialtyEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SpecialtyEntity(id: $id, title: $title)';
}
