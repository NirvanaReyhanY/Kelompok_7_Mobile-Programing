// This class provides static constants for API endpoints used in the application.
class ApiConnect {
  // The base URL for the API server.
  static const hostConnect = "https://apiserverrrr.000webhostapp.com";

  // The complete base URL for connecting to the API.
  static const connectApi = "$hostConnect";

  // Endpoint to add a user.
  static const adduser = "$connectApi/adduser.php";

  // Endpoint to retrieve notes from the server.
  static const notes = "$connectApi/getnotes.php";

  // Endpoint to delete notes from the server.
  static const delete = "$connectApi/deletenotes.php";

  // Endpoint to add new notes to the server.
  static const add = "$connectApi/addnotes.php";

  // Endpoint to retrieve a specific ID from the server.
  static const getid = "$connectApi/getid.php";

  // Endpoint to edit/update existing notes on the server.
  static const edit = "$connectApi/editnotes.php";
}
