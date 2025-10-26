// Helper to convert HH:MM:SS string to total seconds
int durationToSeconds(String duration) {
  if (duration.isEmpty) return 0;
  try {
    List<String> parts = duration.split(':');
    if (parts.length == 3) {
      // Handles HH:MM:SS
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      int seconds = int.tryParse(parts[2]) ?? 0;
      return hours * 3600 + minutes * 60 + seconds;
    } else if (parts.length == 2) {
      // Handles MM:SS (less likely given your data, but good for robustness)
      int minutes = int.tryParse(parts[0]) ?? 0;
      int seconds = int.tryParse(parts[1]) ?? 0;
      return minutes * 60 + seconds;
    }
  } catch (_) {
    // Log or handle parsing error gracefully
  }
  return 0;
}

// Helper to convert total seconds back to HH:MM:SS string
String secondsToDuration(int totalSeconds) {
  final Duration duration = Duration(seconds: totalSeconds);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));

  // Only show hours if total duration is 1 hour or more
  if (duration.inHours > 0) {
    return "$hours:$minutes:$seconds";
  } else {
    // Format as MM:SS if less than an hour, or 00:MM:SS if you prefer standard
    return "00:$minutes:$seconds"; // Example: 00:10:43
  }
}
