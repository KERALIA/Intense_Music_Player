enum AdvanceListOrder {
  alphabetical,
  dateAdded,
  random;

  String get label => switch (this) {
    AdvanceListOrder.alphabetical => 'Alphabetical',
    AdvanceListOrder.dateAdded => 'Date Added',
    AdvanceListOrder.random => 'Random',
  };

  String get description => switch (this) {
    AdvanceListOrder.alphabetical => 'Advance to the next category alphabetically',
    AdvanceListOrder.dateAdded => 'Advance to the next most recently added category',
    AdvanceListOrder.random => 'Advance to a random category',
  };
}
