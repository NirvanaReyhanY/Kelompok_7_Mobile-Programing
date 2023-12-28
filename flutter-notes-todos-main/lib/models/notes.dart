// This class represents a Notes object, which contains information about a note.
class Notes {
  String? id; // Unique identifier for the note.
  String? userId; // User ID associated with the note.
  String? title; // Title of the note.
  String? notes; // Content or description of the note.
  String? date; // Date associated with the note.
  String? status; // Status of the note (e.g., 'selesai' or 'belum').

  // Constructor for creating a Notes object.
  Notes({
    this.id,
    this.userId,
    this.title,
    this.notes,
    this.date,
    this.status,
  });

  // Factory method to create a Notes object from a JSON map.
  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    notes = json['notes'];
    date = json['date'];
    status = json['status'];
  }

  // Method to convert the Notes object to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['notes'] = this.notes;
    data['date'] = this.date;
    data['status'] = this.status;
    return data;
  }
}
