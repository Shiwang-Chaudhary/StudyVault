// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class LocalPdfModelAdapter extends TypeAdapter<LocalPdfModel> {
  @override
  final typeId = 0;

  @override
  LocalPdfModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalPdfModel(
      id: fields[0] as String,
      title: fields[1] as String,
      localPath: fields[2] as String,
      fileSize: fields[3] as String,
      downloadedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LocalPdfModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.localPath)
      ..writeByte(3)
      ..write(obj.fileSize)
      ..writeByte(4)
      ..write(obj.downloadedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalPdfModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PdfHistoryModelAdapter extends TypeAdapter<PdfHistoryModel> {
  @override
  final typeId = 1;

  @override
  PdfHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfHistoryModel(
      title: fields[4] as String,
      isLocal: fields[6] as bool,
      localPathOrUrl: fields[5] as String,
      pdfId: fields[0] as String,
      lastPage: (fields[1] as num).toInt(),
      totalPages: (fields[2] as num).toInt(),
      lastOpened: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PdfHistoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.pdfId)
      ..writeByte(1)
      ..write(obj.lastPage)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.lastOpened)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.localPathOrUrl)
      ..writeByte(6)
      ..write(obj.isLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
