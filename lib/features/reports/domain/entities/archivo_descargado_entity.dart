class ArchivoDescargadoEntity {
  final List<int> bytes;
  final String? contentType;
  final String? fileName;

  const ArchivoDescargadoEntity({
    required this.bytes,
    this.contentType,
    this.fileName,
  });
}
