String norm(String v) {
  return v.toString().trim().replaceAll(" ", "_").toLowerCase();
}