// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminUserAdapter extends TypeAdapter<AdminUser> {
  @override
  final int typeId = 4;

  @override
  AdminUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdminUser(
      username: fields[0] as String,
      passwordHash: fields[1] as String,
      createdAt: fields[2] as DateTime,
      isActive: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AdminUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.passwordHash)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
