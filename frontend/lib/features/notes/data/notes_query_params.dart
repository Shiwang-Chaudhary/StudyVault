class NotesQueryParams {
  final String? subject;
  final String? college;
  final String? branch;
  final String? semester;
  final String? search;
  final String? sort;
  final String? userId;

  const NotesQueryParams({
    this.subject,
    this.college,
    this.branch,
    this.semester,
    this.search,
    this.sort,
    this.userId,
  });

  /*final p1 = NotesQueryParams(subject: "Math");
    final p2 = NotesQueryParams(subject: "Math");
    Without below function, riverpod assumes both of them as different object that means even if we pass same value,
    riverpod creates two different provider for them which isnt good, thats why we uses these functions so that riverpod
    can check on the basis of values and hashcode instead of addresses
  */
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotesQueryParams &&
        other.subject == subject &&
        other.college == college &&
        other.branch == branch &&
        other.semester == semester &&
        other.search == search &&
        other.sort == sort &&
        other.userId == userId;
  }

  @override
  int get hashCode =>
      Object.hash(subject, college, branch, semester, search, sort, userId);
}
